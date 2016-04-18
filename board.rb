require_relative 'piece.rb'

class Board

  def initialize
    @grid= Array.new(8) {Array.new(8)}

    @grid.first(2).each do |row|
      row.length.times do |index|
        row[index] = Piece.new()
      end
    end

    @grid.last(2).each do |row|
      row.length.times do |index|
        row[index] = Piece.new()
      end
    end


  end

  def move(start_pos,end_pos)
    if grid[*start_pos].nil? ||
      (0..7).include?(end_pos[0]) ||
      (0..7).include?(end_pos[1])
        raise ArgumentError
      end
    grid[*end_pos] = grid[*start_pos]
    grid[*start_pos] = nil
  end

end
