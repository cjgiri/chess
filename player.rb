require_relative 'display.rb'

class Player
  attr_reader :color

  def initialize(display)
    @display = display
    @color = nil
  end

  def color=(new_color)
    if color.nil?
      @color = new_color
    end
  end

  def play_turn

  end

end
