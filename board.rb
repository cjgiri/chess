require_relative 'piece.rb'
require_relative 'display.rb'
# require 'byebug'

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
    if grid[*start_pos].nil? || !Board.in_bounds?(end_pos)
      raise ArgumentError
    end
    grid[end_pos[0]][end_pos[1]] = grid[start_pos[0]][start_pos[1]]
    grid[start_pos[0]][start_pos[1]] = nil
  end

  def self.in_bounds?(pos)
    (0..7).include?(pos[0]) && (0..7).include?(pos[1])
  end

  def add_new_piece(color,pos,type)
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
    king = other_pieces = nil
    case color
    when :w
      other_pieces = black_pieces
      king_idx = white_pieces.index { |p| p.is_a?(King) }
      king = white_pieces[king_idx]
    when :b
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
      new_pos, new_color = piece.pos, piece.color
      new_type = nil
      case piece.class
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
      end

      new_board.add_new_piece(new_color,new_pos,new_type)
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  b=Board.new
  d=Display.new(b)
  b.add_new_piece(:b,[3,4],:K)
  b.add_new_piece(:w,[2,2],:Q)
  p b.grid[3][4].moves
  puts
  p b.grid[2][2].moves
  puts
  p b.in_check?(:b)
  # until false == true
  #   d.render
  #   d.get_input
  # end
end
