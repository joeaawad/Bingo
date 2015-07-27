require "pp"

class BingoScorer

	attr_accessor :bingo, :bingo_board, :straight_winner

	def initialize(bingoboard)
		@bingo_board = bingoboard
		@bingo = false
		@straight_winner = false
	end

	def winner?
		horizontal?
		diagonal1?
		diagonal2?
		oustide_corners
		inside_corners
		small_diamond
		vertical?
		bingo_complete?
	end

	def bingo_complete?
		@bingo
	end

private

	def straight_winner?
		@bingo_board.each do |array| 
			if array.all? { |square| square == "X" }
				@bingo = true
				@straight_winner = true
			end
		end
	end

	def horizontal?
		straight_winner?
		if @straight_winner
			puts "Horizontal Bingo"
			@straight_winner = false #So it doesn't always say vertical bingo when there is only horizontal bingo
		end
	end

	def diagonal1?
		if @bingo_board[0][0] == "X" && @bingo_board[1][1] == "X" && @bingo_board[3][3] == "X" && @bingo_board[4][4] == "X"
			@bingo = true
			puts "Diagonal Bingo"
		end
	end

	def diagonal2?
		if @bingo_board[0][4] == "X" && @bingo_board[1][3] == "X" && @bingo_board[3][1] == "X" && @bingo_board[4][0] == "X"
			@bingo = true
			puts "Diagonal Bingo"
		end
	end

	def oustide_corners
		if @bingo_board[0][0] == "X" && @bingo_board[0][4] == "X" && @bingo_board[4][0] == "X" && @bingo_board[4][4] == "X"
			@bingo = true
			puts "Outside Corners Bingo"
		end
	end

	def inside_corners
		if @bingo_board[1][1] == "X" && @bingo_board[1][3] == "X" && @bingo_board[3][1] == "X" && @bingo_board[3][3] == "X"
			@bingo = true
			puts "Inside Corners Bingo"
		end
	end

	def small_diamond
		if @bingo_board[1][2] == "X" && @bingo_board[2][1] == "X" && @bingo_board[2][3] == "X" && @bingo_board[3][2] == "X"
			@bingo = true
			puts "Small Diamond Bingo"
		end
	end

	def transpose
		@bingo_board = @bingo_board.transpose
	end

	def vertical?
		transpose
		straight_winner?
		if @straight_winner
			puts "Vertical Bingo"
		end
	end
end

class BingoBoard

	attr_accessor :bingo_board, :columns
  
	def initialize(board)
		@bingo_board = board    
		@columns = ["B","I","N","G","O"]
		@letters = ["B", "I", "N", "G", "O"].each_with_object([]){ |letter, letters| letters.concat(Array.new(15, letter)) }
		@numbers = { "B" => [*1..15], "I" => [*16..30], "N" => [*31..45], "G" => [*46..60], "O" => [*61..75] }
		@bingo_scorer = BingoScorer.new(@bingo_board)
		raise ArgumentError.new "Invalid Board" unless valid_board?
	end
  
	def run!
		75.times do
			next_spot
			puts "#{@letter} #{@number}"
			check
			print_board
			break if @bingo_scorer.bingo_complete?
		end
	end

private

	def valid_board?
		board_has_correct_number_of_rows? && board_rows_correct_length?
	end
  
	def board_has_correct_number_of_rows?
		bingo_board.size == 5
	end
  
	def board_rows_correct_length?
		bingo_board.map { |array| return false unless array.size == 5 }
	end

	def next_spot
		@letter = random_letter
		@number = random_number
	end
  
	def random_letter
		@letter = @letters.shuffle!.pop
	end
  
	def random_number 
		@number = @numbers[@letter].shuffle!.pop
	end
  
	def current_column
		columns.index(@letter)
	end
  
	def check
		bingo_board.map do |row|
			if row[current_column] == @number
				row[current_column] = "X"
				puts "Match!"
				@bingo_scorer.bingo_board = @bingo_board
				@bingo_scorer.winner?
			end
		end
	end

	def print_board
		pp bingo_board
	end

end

class GenerateBingoBoard

	def new_board
		subarray_creation
		main_array_creation
		transpose
		free_space
		pp @board
	end

private
  
	def subarray_creation
		bnum = [*1..15].shuffle
		inum = [*16..30].shuffle
		nnum = [*31..45].shuffle
		gnum = [*46..60].shuffle
		onum = [*61..75].shuffle
		
		@b = Array.new
		5.times do
			@b.push(bnum.pop)
		end
		
		@i = Array.new
		5.times do
			@i.push(inum.pop)
		end
		
		@n = Array.new
		5.times do
			@n.push(nnum.pop)
		end
		
		@g = Array.new
		5.times do
			@g.push(gnum.pop)
		end
		
		@o = Array.new
		5.times do
			@o.push(onum.pop)
		end
	end

	def main_array_creation
		@array = [@b, @i, @n, @g, @o]
	end

	def transpose
		@board = @array.transpose
	end

	def free_space
		@board[2][2] = 'X'
	end

end

new_gameboard = GenerateBingoBoard.new
new_board_test = BingoBoard.new(new_gameboard.new_board)
new_board_test.run!