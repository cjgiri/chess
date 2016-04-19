require 'colorize'
require 'io/console'

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

  def render
    build_grid.each { |row| puts row.join }
  end

  def clear
    system("clear")
  end

  def get_input
    key = KEYMAP[read_char]
    handle_key(key)
  end

  private
  def build_grid
    output = @board.grid.map.with_index do |row, i|
      row.map.with_index do |piece, j|
        color_options = colors_for(i, j)
        if [i,j] == @cursor_pos
          piece.to_s.colorize(color_options).blink.bold.swap
        else
          piece.to_s.colorize(color_options)
        end
      end
    end
    output.each_with_index do |row, ind|
      row.push(" #{ind + 1} ")
      row.unshift(" #{ind + 1} ")
    end
    letters = ['   ',' a ',' b ',' c ',' d ',' e ',' f ',' g ',' h ']
    output.push(letters)
    output.unshift(letters)
  end

  def colors_for(i, j)
    if [i, j] == @cursor_pos
      bg = :light_yellow
    elsif (i + j).odd?
      bg = :light_black
    else
      bg = :light_white
    end
    color = :light_yellow
    unless @board.grid[i][j].nil?
      color = @board.grid[i][j].color == :w ? :blue : :red
    end
    { background: bg, color: color }
  end
  def read_char
    STDIN.echo = false
    STDIN.raw!
    output = STDIN.getc.chr
    if output == "\e" then
      output << STDIN.read_nonblock(3) rescue nil
      output << STDIN.read_nonblock(2) rescue nil
    end
    STDIN.echo = true
    STDIN.cooked!

    return output
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
