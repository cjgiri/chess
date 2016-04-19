require_relative 'piece.rb'
require_relative 'display.rb'
require 'byebug'

class Board
  attr_reader :grid, :black_pieces, :white_pieces

  def initialize
    @grid= Array.new(8) {Array.new(8)}
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
    row = start_pos[0]
    col = start_pos[1]
    raise "Invalid Move!" unless grid[row][col].valid_moves.include?(end_pos)
    move!(start_pos,end_pos)
  end

  def move!(start_pos,end_pos)
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
