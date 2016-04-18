require 'byebug'

class Piece
  attr_reader :color, :pos

  def initialize(color, board, pos=[0,0])
    @color = color
    @pos = pos
    @board = board
    # @possible_moves = []
  end

  def to_s
    return " W " if @color == :w
    return " B "
  end

  def moves
    @possible_moves.dup
  end

  private
  attr_reader :board

end

class SlidingPiece < Piece
  def moves
    possible_moves = []
    move_dirs.each do |dir|
      (1..7).each do |mult|
        poss_move_x = mult*dir[0]+pos[0]
        poss_move_y = mult*dir[1]+pos[1]
        poss_move = [poss_move_x,poss_move_y]
        break unless Board.in_bounds?(poss_move)
        # byebug if board.piece(*poss_move) != color
        if board.grid[poss_move_x][poss_move_y].nil?
          possible_moves << poss_move
        elsif board.piece(*poss_move) != color
          possible_moves << poss_move
          break
        else
          break
        end
      end
    end

    return possible_moves
  end
end

class SteppingPiece < Piece
  def moves
    possible_moves = move_dirs.map do |offset|
      [ pos[0] + offset[0], pos[1] + offset[1] ]
    end.select{ |poss_move| Board.in_bounds?(poss_move) }

    possible_moves.select do |poss_move|
      board.grid[poss_move[0]][poss_move[1]].nil? ||
      board.piece(*poss_move) != color
    end
  end
end

class Bishop < SlidingPiece
  def move_dirs
    [[-1, -1],     [-1, 1],
            #center
    [1, -1],        [1, 1]]
  end
end

class Rook < SlidingPiece
  def move_dirs
           [[-1, 0],
    [0, -1],        [0, 1],
            [1, 0]]
  end
end

class Queen < SlidingPiece
  def move_dirs
    [[-1, -1], [-1, 0], [-1, 1],
     [ 0, -1],          [0, 1],
     [ 1, -1], [ 1, 0], [1, 1 ]]
  end
end

class Knight < SteppingPiece
  def move_dirs
    [      [-2, -1], [-2, 1],
    [-1, -2],              [-1, 2],
    [ 1, -2],              [ 1, 2],
           [2, -1],   [ 2, 1]       ]
  end
end

class King < SteppingPiece
  def move_dirs
    [[-1, -1], [-1, 0], [-1, 1],
     [ 0, -1],          [0, 1],
     [ 1, -1], [ 1, 0], [1, 1 ]]
  end
end

class Pawn < Piece

end


class NilClass

  def to_s
    "   "
  end

end
