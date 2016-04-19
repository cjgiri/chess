require_relative 'chess.rb'
require 'byebug'

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

def test_checkmate
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

  b.move!([3,3],[7,0])
  b.move!([2,2],[1,0])
  b.add_new_piece(:b,[4,3],:B)
  b.add_new_piece(:w,[1,6],:B)
  b.add_new_piece(:w,[0,1],:R)

  d.render

  puts  "Is the black king in check? #{b.in_check?(:b)}"
  puts  "Is the black king in checkmate? #{b.checkmate?(:b)}"
  puts  "The black king can move: #{b.grid[7][0].valid_moves}"
end

def test_reset
  b = Board.new
  b.reset
  d = Display.new(b)
  d.render
end

if __FILE__ == $PROGRAM_NAME
  test_reset
end
