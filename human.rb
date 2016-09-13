class HumanPlayer
  attr_reader :name
  def initialize(name)
    @name = name
  end

  def guess(fragment, num_players)
    p "Please enter a character now."
    gets.chomp
  end

  def alert_invalid_guess
    p "Invalid guess, try again!"
  end
end
