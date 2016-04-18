require_relative 'piece.rb'
require_relative 'display.rb'
# require 'byebug'

class Board
  attr_reader :grid

  def initialize
    @grid= Array.new(8) {Array.new(8)}
    @grid.first(2).each do |row|
      row.length.times do |index|
        row[index] = Piece.new(:w)
      end
    end

    @grid.last(2).each do |row|
      row.length.times do |index|
        row[index] = Piece.new(:b)
      end
    end


  end

  def move(start_pos,end_pos)
    if grid[*start_pos].nil? || !Board.in_bounds?(end_pos)
      raise ArgumentError
    end
    grid[*end_pos] = grid[*start_pos]
    grid[*start_pos] = nil
  end

  def self.in_bounds?(pos)
    (0..7).include?(pos[0]) && (0..7).include?(pos[1])
  end

end

b=Board.new
d=Display.new(b)
until false == true
  d.render
  d.get_input
end
