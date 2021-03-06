require_relative 'piece.rb'
require_relative 'display.rb'

class Board
  attr_reader :grid, :black_pieces, :white_pieces, :unicode

  def initialize(unicode = false)
    @grid= Array.new(8) {Array.new(8) { NullPiece.instance }}
    @black_pieces = []
    @white_pieces = []
    @unicode = unicode
  end


  def reset
    black = [ [:R,:N,:B,:Q,:K,:B,:N,:R],
              [:p,:p,:p,:p,:p,:p,:p,:p] ]

    white = [ [:p,:p,:p,:p,:p,:p,:p,:p],
              [:R,:N,:B,:Q,:K,:B,:N,:R] ]

    grid.first(2).each_with_index do |row,row_idx|
      row.each_with_index do |el,col_idx|
        add_new_piece(:b,[row_idx,col_idx],black[row_idx][col_idx])
      end
    end

    grid.last(2).each_with_index do |row,row_idx|
      row.each_with_index do |el,col_idx|
        add_new_piece(:w,[row_idx+6,col_idx],white[row_idx][col_idx])
      end
    end
  end

  def [](pos)
    row = pos[0]
    col = pos[1]
    grid[row][col]
  end

  def []=(pos,new_piece)
    row = pos[0]
    col = pos[1]
    grid[row][col] = new_piece
  end

  def move(start_pos,end_pos,color)
    # TODO raise different error for causing king to still be in check next turn
    raise "Invalid Move! No piece there!" if self[start_pos].nil?
    raise "Invalid Move! Not a legal move!" unless self[start_pos].valid_moves.include?(end_pos)
    raise "Invalid Move! Not your piece!" unless self[start_pos].color == color
    move!(start_pos,end_pos)
  end

  def move!(start_pos,end_pos)
    if grid[*start_pos].nil? || !Board.in_bounds?(end_pos)
      raise ArgumentError
    end

    rm_piece = self[end_pos]
    self[end_pos] = self[start_pos]
    self[start_pos].move_piece(end_pos)
    self[start_pos] = NullPiece.instance

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
    own_pieces = ( color == :w ? white_pieces : black_pieces )
    return in_check?(color) && own_pieces.all? { |piece| piece.valid_moves.empty?}
  end

  def draw?(color)
    pieces = ( color == :w ? white_pieces : black_pieces )
    pieces.all? { |piece| piece.valid_moves.empty? }
  end

  def dup
    new_board = Board.new
    (white_pieces+black_pieces).each do |piece|
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
