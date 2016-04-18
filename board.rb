require_relative 'piece.rb'
require_relative 'display.rb'
# require 'byebug'

class Board
  attr_reader :grid

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
  end

end

if __FILE__ == $PROGRAM_NAME
  b=Board.new
  d=Display.new(b)
  b.add_new_piece(:b,[3,3],:R)
  p b.grid[3][3].moves
  puts
  b.add_new_piece(:w,[2,2],:Q)
  p b.grid[2][2].moves
  # until false == true
  #   d.render
  #   d.get_input
  # end
end
