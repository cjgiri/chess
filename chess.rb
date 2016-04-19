require_relative 'board.rb'
require 'byebug'


class Game
  attr_reader :board, :display
  def initialize
    @board = Board.new
    @display = Display.new(board)
    board.reset
  end
end
