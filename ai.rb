class AIPlayer
  attr_reader :name
  def initialize(name)
    @name = name
    @dictionary = File.readlines('dictionary.txt').map do |line|
      line.strip
    end
  end

  #make more complicated
  def guess(fragment, num_players)
    return kill_blow(fragment) unless kill_blow(fragment).nil?
    return good_move(fragment, num_players) unless
      good_move(fragment, num_players).nil?
    bad_move(fragment)
  end

  def kill_blow(fragment)
    char = nil
    @dictionary.shuffle.each do |word|
       if word[0...fragment.length] == fragment &&
            word.length == fragment.length + 1
         char = word[-1]
       end
    end
    char
  end

  def good_move(fragment, num_players)
    char = nil
    @dictionary.shuffle.each do |word|
       if word[0...fragment.length] == fragment &&
            word.length < fragment.length + num_players - 1
         char = word[fragment.length]
       end
    end
    char
  end

  def bad_move(fragment)
    char = nil
    @dictionary.shuffle.each do |word|
       if word[0...fragment.length] == fragment
         char = word[fragment.length]
       end
    end
    char
  end

  def alert_invalid_guess
  end

end
