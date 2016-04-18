require 'colorize'
# require_relative 'cursorable'
require 'io/console'
# require_relative 'board.rb'


class Display

  KEYMAP = {
    " " => :space,
    "w" => :up,
    "a" => :left,
    "s" => :down,
    "d" => :right,
    "\r" => :return,
    "\n" => :newline,
    "\e" => :escape,
    "\e[A" => :up,
    "\e[B" => :down,
    "\e[C" => :right,
    "\e[D" => :left,
    "\004" => :delete,
    "\u0003" => :ctrl_c,
  }

  MOVES = {
    left:  [0,-1],
    right: [0 ,1],
    up:    [-1,0],
    down:  [1 ,0]
  }

  def initialize(board)
    @board = board
    @cursor_pos = [0,0]
  end

  def build_grid
    @board.grid.map.with_index do |row, i|
      row.map.with_index do |piece, j|
        color_options = colors_for(i, j)
        piece.to_s.colorize(color_options)
      end
    end
  end

  def colors_for(i, j)
    if [i, j] == @cursor_pos
      bg = :light_red
    elsif (i + j).odd?
      bg = :light_blue
    else
      bg = :blue
    end
    color = :green
    unless @board.grid[i][j].nil?
      color = @board.grid[i][j].color == :w ? :white : :black
    end
    { background: bg, color: color }
  end

  def render
    system("clear")
    build_grid.each { |row| puts row.join }
  end

  def read_char
    STDIN.echo = false
    STDIN.raw!
    output = STDIN.getc.chr
    STDIN.echo = true
    STDIN.cooked!

    return output
  end

  def get_input
    key = KEYMAP[read_char]
    handle_key(key)
  end

  def handle_key(key)
    case key
    when :ctrl_c
      exit
    when :left, :right, :up, :down
      update_pos(MOVES[key])
      nil
    when :return, :space
      @cursor_pos
    end

  end

  def update_pos(delta)
    new_pos = [ @cursor_pos[0] + delta[0], @cursor_pos[1] + delta[1] ]
    @cursor_pos = new_pos if Board.in_bounds?(new_pos)
  end


end
