class Piece
  attr_reader :color, :pos

  def initialize(color, pos=[0,0])
    @color = color
    @pos = pos
  end

  def to_s
    return "W" if @color == :w
    return "B"
  end

end

class NilClass

  def to_s
    " "
  end

end
