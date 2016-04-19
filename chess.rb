require_relative 'board.rb'
require 'byebug'


class Game
  attr_reader :board, :display
  def initialize(*players)
    @board = Board.new
    @display = Display.new(board)
    board.reset
    @players = players
    @players[0].color=(:w)
    @players[1].color=(:b)
  end

  def play
    until board.checkmate?(:b) || board.checkmate?(:w)
      current_player = players.first
      begin
        move = current_player.play_turn
        board.move(move[0],move[1],current_player.color)
      rescue
        puts "Not a valid move! Please try again; press any key to continue"
        gets
        retry
      end
      players = players.drop(1) + current_player
    end
  end

end
