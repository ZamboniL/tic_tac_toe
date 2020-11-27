# frozen_string_literal: true

# Main loop of the game
def main
  game_board = Board.new
  x = Piece.new('X', game_board)
  o = Piece.new('O', game_board)
  loop do
    x.round
    break if game_board.game_over?

    o.round
    break if game_board.game_over?
  end
  game_end(game_board)
end

# game over final output
def game_end(board)
  if board.game_over? == 'test'
    puts "\n GAME OVER: TIE"
  else
    puts "\nGAME OVER: PLAYER #{board.game_over?} WON"
  end
end

# Draws the Board
class Board
  attr_accessor :cells

  def initialize
    @middle_cell = '---+---+---'
    @final_row = '|'
    @cells = Array.new(10) { |i| i.zero? ? 'empty' : i } # the cells array for the possible moves
    draw_board
  end

  # draw the current board state
  def draw_board
    puts "
    #{draw_row(1)}
    #{@middle_cell}
    #{draw_row(4)}
    #{@middle_cell}
    #{draw_row(7)}"
  end

  # check to see if the game is over
  def game_over?
    return 'TIE' if cells.all? { |i| i.is_a? String }

    any_column_win? || any_row_win? || any_diagonal_win?
  end

  private

  # get a specific row drawing
  def draw_row(index)
    " #{cells[index]} #{@final_row} #{cells[index + 1]} #{@final_row} #{cells[index + 2]}"
  end

  # if any column, row or diagonal has been won
  def any_column_win?
    column_win?(1) || column_win?(2) || column_win?(3)
  end

  def any_row_win?
    row_win?(1) || row_win?(4) || row_win?(7)
  end

  def any_diagonal_win?
    diagonal_win?(1, 4) || diagonal_win?(3, 2)
  end

  # if a individual column, row or diagonal has been won
  def column_win?(index)
    column = get_column(index)
    return cells[index] if column[0..2].all? { |i| i == cells[index] }

    false
  end

  def row_win?(index)
    row = get_row(index)
    return cells[index] if row[0..2].all? { |i| i == cells[index] }

    false
  end

  def diagonal_win?(index, multiplyer)
    diagonal = get_diagonal(index, multiplyer)
    return cells[index] if diagonal.all? { |i| i == cells[index] }

    false
  end

  # get a specific column, row or diagonal
  def get_column(index)
    Array.new(3) { |i| cells[index + (i * 3)] }
  end

  def get_row(index)
    Array.new(3) { |i| cells[index + i] }
  end

  def get_diagonal(index, multiplyer)
    Array.new(3) { |i| cells[index + i * multiplyer] }
  end
end

# Game piece either X or O
class Piece
  def initialize(player_name, board)
    @player_name = player_name
    @board = board
  end

  # the piece round loop
  def round
    valid_move = false
    until valid_move
      puts "\nIt's your turn Player #{@player_name}, where will you place #{@player_name}?"
      position = gets.chomp.to_i
      valid_move = check_position(position)
      puts 'Not a valid move!' unless valid_move
    end
    switch_position(position)
    @board.draw_board
  end

  private

  # check if the player input was a valid position
  def check_position(position)
    return false unless position == @board.cells[position]
    return false if position < 1 || position > 9

    true
  end

  # string for the invalid move
  def invalid_move
    'Not a valid move!'
  end

  # putting the players move on the board
  def switch_position(index)
    @board.cells[index] = @player_name
  end
end

main
