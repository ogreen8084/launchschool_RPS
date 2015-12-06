# Nouns: player, move, rule
# Verbs: choose, compare

WINNING_SCORE = 10

class Player
  attr_accessor :move, :name, :score, :move_history
  def initialize
    set_name
    @score = 0
    @move_history = { 'rock' => 0, 'paper' => 0, 'scissors' => 0, 'lizard' => 0, 'spock' => 0 }
  end

  def show_move_history
    move_history
  end

  def update_move_history(choice)
    move_history[choice] += 1
  end
end

class Human < Player
  def set_name
    n = ''
    loop do
      puts "What's your name"
      n = gets.chomp
      break unless n.empty?
      puts "Sorry must enter a value."
    end
    self.name = n
  end

  def choose
    choice = nil
    loop do
      puts "Please choose rock, paper, scissors, lizard or spock:"
      choice = gets.chomp
      break if MOVE_LIST.keys.include? choice
      puts "Sorry, invalid choice."
    end
    update_move_history(choice)
    self.move = MOVE_LIST[choice]
  end
end

class Computer < Player
  def set_name
    self.name = ['R2D2', 'Hal', 'Chappie', 'Sonny', 'Number 5'].sample
  end

  def choose(player_history)
    if name == 'R2D2'
      self.move = MOVE_LIST.values.sample
    elsif name == 'Chappie'
      self.move = 'rock'
    elsif name == 'Sonny'
      self.move = ['rock', 'rock', 'paper', 'paper', 'scissors', 'lizard', 'lizard', 'lizard', 'spock'].sample
    elsif name == 'Hal'
      self.move = 'paper'
    elsif name == 'Number 5'
      self.move = number5_smart(player_history)
    end
  end

  def number5_smart(player_history)
    move_probability = {}
    smart_move = []
    total = player_history.values.inject { |sum, x| sum + x }
    player_history.each do |value, sum|
      move_probability[value] = sum / total.to_f
    end
    move_probability.each do |value, prob|
      repeat = (prob * 100).to_i
      repeat.times { smart_move << value }
    end
    smart_move.sample
  end
end

class Move
  def to_s
    @value
  end

  def rock?
    'rock'
  end

  def paper?
    'paper'
  end

  def scissors?
    'scissors'
  end

  def lizard?
    'lizard'
  end

  def spock?
    'spock'
  end
end

class Paper < Move
  attr_accessor :value
  def initialize
    @value = 'paper'
  end

  def check_win(other)
    return true if other.to_s == 'rock' || other.to_s == 'spock'
    false
  end

  def check_tie(other)
    return true if other.to_s == 'paper'
    false
  end
end

class Rock < Move
  attr_accessor :value
  def initialize
    @value = 'rock'
  end

  def check_win(other)
    return true if other.to_s == 'lizard' || other.to_s == 'scissors'
    false
  end

  def check_tie(other)
    return true if other.to_s == 'rock'
    false
  end
end

class Scissors < Move
  attr_accessor :value
  def initialize
    @value = 'scissors'
  end

  def check_win(other)
    return true if other.to_s == 'paper' || other.to_s == 'lizard'
    false
  end

  def check_tie(other)
    return true if other.to_s == 'scissors'
    false
  end
end

class Spock < Move
  attr_accessor :value
  def initialize
    @value = 'spock'
  end

  def check_win(other)
    return true if other.to_s == 'rock' || other.to_s == 'scissors'
    false
  end

  def check_tie(other)
    return true if other.to_s == 'spock'
    false
  end
end

class Lizard < Move
  attr_accessor :value
  def initialize
    @value = 'lizard'
  end

  def check_win(other)
    return true if other.to_s == 'paper' || other.to_s == 'spock'
    false
  end

  def check_tie(other)
    return true if other.to_s == 'lizard'
    false
  end
end

MOVE_LIST = { 'rock' => Rock.new, 'paper' => Paper.new, 'scissors' => Scissors.new, 'lizard' => Lizard.new, 'spock' => Spock.new }

class RPSGame
  attr_accessor :human, :computer

  def initialize
    @human = Human.new
    @computer = Computer.new
  end

  def display_welcome_message
    puts "Welcome to Rock, Paper, Scissors"
  end

  def display_goodbye_message
    puts "Thanks for playing Rock, Paper, Scissors. Goodbye!"
  end

  def display_winner
    if human.move.check_win(computer.move)
      puts "#{human.name} won"
      human.score += 1
    elsif human.move.check_tie(computer.move)
      puts "It's a tie"
    else
      puts "#{computer.name} won!"
      computer.score += 1
    end
  end

  def display_score
    puts "#{human.name} has a score of: #{human.score}"
    puts "#{computer.name} has a score of: #{computer.score}"
  end

  def play_again?
    answer = ''
    loop do
      puts "Play again? (y/n)"
      answer = gets.chomp
      break if ['y', 'n'].include?(answer.downcase)
      puts "Sorry, must be y or n"
    end

    if answer.downcase == 'y'
      @computer = Computer.new
      return true
    end
    return false if answer.downcase == 'n'
  end

  def display_moves
    puts "#{human.name} chose: #{human.move}"
    puts "#{computer.name} chose: #{computer.move}"
  end

  def score_reset
    human.score = 0
    computer.score = 0
  end

  def win_message(winner, loser_score)
    puts "#{winner.name} has won #{WINNING_SCORE} to #{loser_score}"
    score_reset
  end

  def check_winner
    if human.score == WINNING_SCORE
      win_message(human, computer.score)
      play_again?
    elsif computer.score == WINNING_SCORE
      win_message(computer, human.score)
      play_again?
    else
      true
    end
  end

  def play
    display_welcome_message
    loop do
      human.choose
      computer.choose(human.move_history)
      display_moves
      display_winner
      display_score
      break unless check_winner
    end
    display_goodbye_message
  end
end

RPSGame.new.play
