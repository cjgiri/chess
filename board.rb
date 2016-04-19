require_relative 'piece.rb'
require_relative 'display.rb'
require 'byebug'

class Board
  attr_reader :grid, :black_pieces, :white_pieces

  def initialize
    @grid= Array.new(8) {Array.new(8)}
    # @grid.first(2).each do |row|
    #   row.length.times do |index|
    #     row[index] = Piece.new(:w,self)
    #   end
    # end
    #
    # @grid.last(2).each do |row|
    #   row.length.times do |index|
    #     row[index] = Piece.new(:b,self)
    #   end
    # end
    @black_pieces = []
    @white_pieces = []
  end

  # def inspect
  #
  # end

  def piece(row,col)
    grid[row][col].color
  end

  def move(start_pos,end_pos)
    # debugger
    if grid[*start_pos].nil? || !Board.in_bounds?(end_pos)
      raise ArgumentError
    end
    rm_piece = grid[end_pos[0]][end_pos[1]]
    grid[end_pos[0]][end_pos[1]] = grid[start_pos[0]][start_pos[1]]
    grid[start_pos[0]][start_pos[1]].move_piece(end_pos)
    grid[start_pos[0]][start_pos[1]] = nil
    unless rm_piece.nil?
      pieces = rm_piece.color == :w ? white_pieces : black_pieces
      pieces.delete_if { |x| x.object_id == rm_piece.object_id }
    end
    return rm_piece
  end

  def self.in_bounds?(pos)
    (0..7).include?(pos[0]) && (0..7).include?(pos[1])
  end

  def add_new_piece(color,pos,type)
    # byebug
    case type
    when :R
      p = Rook.new(color,self,pos)
    when :Q
      p = Queen.new(color,self,pos)
    when :N
      p = Knight.new(color,self,pos)
    when :K
      p = King.new(color,self,pos)
    when :B
      p = Bishop.new(color,self,pos)
    else
      p = Pawn.new(color,self,pos)
    end
    grid[pos[0]][pos[1]] = p
    p.color == :w ? @white_pieces << p : @black_pieces << p
  end

  def in_check?(color)
    # king = other_pieces = nil
    case color
    when :w
      other_pieces = black_pieces
      king_idx = white_pieces.index { |p| p.is_a?(King) }
      king = white_pieces[king_idx]
    when :b
      # debugger
      other_pieces = white_pieces
      king_idx = black_pieces.index { |p| p.is_a?(King) }
      king = black_pieces[king_idx]
    else
      raise "What is going on"
    end

    other_pieces.any? do |p|
      p.moves.include?(king.pos)
    end
  end

  def checkmate?(color)
    case color
    when :w
      own_pieces = white_pieces
    when :b
      own_pieces = black_pieces
    end
    return in_check?(color) && own_pieces.all? { |piece| piece.valid_moves.empty?}
  end

  def dup
    new_board = Board.new
    (white_pieces+black_pieces).each do |piece|
      # byebug
      new_pos, new_color = piece.pos, piece.color
      new_type = nil
      case piece
      when Rook
        new_type = :R
      when Knight
        new_type = :N
      when Bishop
        new_type = :B
      when Queen
        new_type = :Q
      when King
        new_type = :K
      when Pawn
        new_type = :p
      else
        raise "Piece type error"
      end

      new_board.add_new_piece(new_color,new_pos,new_type)
    end
    return new_board
  end


end

def test_dup
  b=Board.new
  d=Display.new(b)
  b.add_new_piece(:b,[3,3],:K)
  b.add_new_piece(:w,[2,2],:Q)
  c = b.dup
  old_king = b.grid[3][3]
  old_queen = b.grid[2][2]
  f=Display.new(c)
  c.move([3,3],[6,6])
  d.render
  f.render

  new_king = c.grid[6][6]
  new_queen = c.grid[2][2]
  puts "KING SAME? #{new_king == old_king} & QUEEN SAME? #{new_queen == old_queen}"

end

if __FILE__ == $PROGRAM_NAME
  b=Board.new
  d=Display.new(b)
  b.add_new_piece(:b,[3,3],:K)
  b.add_new_piece(:w,[2,2],:Q)
  puts "King can move: #{b.grid[3][3].moves}"
  puts
  puts "Queen can move: #{b.grid[2][2].moves}"
  puts
  puts  "Is the black king in check? #{b.in_check?(:b)}"
  puts  "Is the black king in checkmate? #{b.checkmate?(:b)}"
  puts  "The black king can move: #{b.grid[3][3].valid_moves}"

  d.render
  puts

  b.move([3,3],[7,0])
  b.move([2,2],[1,0])
  b.add_new_piece(:b,[4,3],:B)
  b.add_new_piece(:w,[1,6],:B)
  b.add_new_piece(:w,[0,1],:R)

  d.render

  puts  "Is the black king in check? #{b.in_check?(:b)}"
  puts  "Is the black king in checkmate? #{b.checkmate?(:b)}"
  puts  "The black king can move: #{b.grid[7][0].valid_moves}"



  # until false == true
  #   d.render
  #   d.get_input
  # end
end
