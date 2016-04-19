require_relative 'board.rb'
require_relative 'player.rb'
require 'byebug'


class Game
  attr_reader :board, :display, :players
  def initialize(unicode, *players)
    @board = Board.new(unicode)
    @display = Display.new(board)
    board.reset

    @players = players
    @players[0].color=(:w)
    @players[1].color=(:b)
    @players[0].display = display
    @players[1].display = display
  end

  def play
    # TODO check for ties here
    until board.checkmate?(:b) || board.checkmate?(:w)
      current_player = players.first
      begin
        move = current_player.play_turn
        board.move(move[0],move[1],current_player.color)
      rescue RuntimeError => e
        puts "#{e.message}\nPlease try again; press any key to continue..."
        current_player.ack
        retry
      end
      @players = players.drop(1) + [current_player]
    end
    winner =  board.checkmate?(:b) ? "White" : "Black"
    puts "#{winner} won!"
  end

end

if __FILE__ == $PROGRAM_NAME
  player1 = Player.new
  player2 = Player.new
  chess = Game.new(false,player1,player2)
  p chess.board.checkmate?(:b)
  chess.play
end
