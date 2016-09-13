# Ghost
require_relative 'human'
require_relative 'ai'

class Ghost

  GHOST = {
    1 => "G",
    2 => "GH",
    3 => "GHO",
    4 => "GHOS",
    5 => "GHOST"
  }

  attr_accessor :fragment, :losses
  def initialize(*players)
    @dictionary = File.readlines('dictionary.txt').map do |line|
      line.strip
    end
    @fragment = ''
    @players = players.shuffle
    @current_index = 0
    @losses = Hash.new(0)
  end

  def run
    until game_over?
      play_round
    end
    congrats
  end

  def play_round
    until round_over?
      take_turn(current_player)
      record_loss if round_over?
      next_player
    end
    @fragment = ''
  end

  def check_losers!
    @players.each do |player|
      if @losses[player.name] == 5
        p "#{player.name}, you have been removed from the game!"
        @players.delete(player)
        @losses.delete(player.name)
      end
    end
  end

  def congrats
    p "#{@players.first.name}, you won the game!!!"
  end

  def game_over?
    @players.length == 1
  end

  def take_turn(player)
    p "The fragment is '#{@fragment}'."
    p "#{player.name}, you're up!"
    char = player.guess(@fragment, @players.length)
    until valid_play?(char)
      player.alert_invalid_guess
      char = player.guess(@fragment, @players.length)
    end
    @fragment << char
  end

  def next_player
    @current_index = (@current_index + 1) % @players.length
  end

  def valid_play?(char)
    return false if char.length != 1
    new_frag = @fragment + char
    in_dictionary = false
    @dictionary.each do |word|
      in_dictionary = true if word[0...new_frag.length] == new_frag
    end
    in_dictionary
  end

  def round_over?
    @dictionary.include?(@fragment) ? true : false
  end

  def record_loss
    p "The fragment is #{@fragment}."
    @losses[previous_player.name] += 1
    p "#{previous_player.name}, you've lost the round!"
    p "Current losses:"
    @losses.each do |key, value|
      p "#{key}: #{GHOST[value]}"
    end
    check_losers!
  end

  def current_player
    @players[@current_index]
  end

  def previous_player
    @players[@current_index - 1]
  end

end

if __FILE__ == $PROGRAM_NAME
  p1 = HumanPlayer.new('Mike')
  p2 = HumanPlayer.new('Alex')
  p3 = AIPlayer.new('Billy')
  losses = {
    'Billy' => 4,
    'Alex' => 4,
    'Mike' => 4
  }
  game = Ghost.new(p1, p2, p3)
  game.losses = losses
  game.run
end
