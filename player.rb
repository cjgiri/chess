require_relative 'display.rb'

class Player
  attr_reader :color
  attr_accessor :display

  def initialize
    @display = nil
    @color = nil
  end

  def color=(new_color)
    if color.nil?
      @color = new_color
    end
  end

  def play_turn
    start_pos = end_pos = nil
    while start_pos.nil? || end_pos.nil?
      display.clear
      display.render
      input = display.get_input
      unless input.nil?
        start_pos.nil? ? start_pos = input : end_pos = input
      end
    end
    [ start_pos, end_pos ]
  end

  def ack
    display.read_char
  end

end
