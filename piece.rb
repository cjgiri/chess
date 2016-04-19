require 'byebug'

class Piece
  attr_reader :color, :pos

  def initialize(color, board, pos=[0,0])
    @color = color
    @pos = pos
    @board = board
  end

  def inspect
    "CLASS: #{self.class} COLOR: #{color} POS: #{pos}"
  end

  def to_s
    return " W " if @color == :w
    return " B "
  end

  def moves
  end

  def move_piece(new_pos)
    @pos = new_pos
  end

  def valid_moves
    moves.select do |move|
      new_board = board.dup
      new_board.move!(pos,move)
      !new_board.in_check?(color)
    end
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

  def to_s
    " B "
  end
  def move_dirs
    [[-1, -1],     [-1, 1],
            #center
    [1, -1],        [1, 1]]
  end
end

class Rook < SlidingPiece

  def to_s
    " R "
  end
  def move_dirs
           [[-1, 0],
    [0, -1],        [0, 1],
            [1, 0]]
  end
end

class Queen < SlidingPiece

  def to_s
    " Q "
  end
  def move_dirs
    [[-1, -1], [-1, 0], [-1, 1],
     [ 0, -1],          [0, 1],
     [ 1, -1], [ 1, 0], [1, 1 ]]
  end
end

class Knight < SteppingPiece
  def to_s
    " N "
  end
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
  def to_s
    " K "
    # " \u265A ".encode('utf-8')
  end
end

class Pawn < Piece
  def initialize(color, board, pos=[0,0])
    @moved = false
    super
  end

  def move_dirs
    # TODO add diagonal taking functionality
    out = []
    out << color == :w ? [-1,0] : [1,0]
    out << [ out[0][0]*2,out[0][1] ] unless moved
    out
  end

  def to_s
    " p "
  end
end


class NilClass

  def to_s
    "   "
  end

end
