require 'yaml'

class Hangman
  def initialize
    @words = File.open('5desk.txt').to_a
    @correct_guesses = []
    @incorrect_guesses = []
    @secret_word = []
    @guesses = 0
    @guess = ''
  end
  
  def menu
    puts "(1)New game or (2)Load game"

    @selection = gets.chomp.to_i

    if @selection == 1
      game = Hangman.new.play
    elsif @selection == 2
      game = Hangman.new.load_game
    else
      puts "\nInvalid input"
      menu
    end
  end

  def play
    choose_secret_word
    initiate_correct_guesses

    while @guesses < 6
      player_guess
      if @guess == "save"
        save_game
        exit
      elsif @secret_word.include?(@guess)
      @secret_word.each_with_index do |v, i|
        @correct_guesses[i] = @guess if v == @guess
      end
      p @correct_guesses
      check_winner
      elsif not @secret_word.include?(@guess)
        @guesses += 1
        track_incorrect_guesses
      else 
        return
      end
    end
  end

  def choose_secret_word
    @secret_word = @words.sample.downcase.chars.to_a
    @secret_word.pop
  end

  def player_guess
    puts "type in a letter or type in save if you would like to save and quit: "
    @guess = gets.chomp.downcase
  end
  
  def initiate_correct_guesses
    chars = @secret_word
    chars.each do |c|
      @correct_guesses.push('_')
    end
    puts "correct_guesses are: "
    p @correct_guesses
  end

  def track_incorrect_guesses
    @incorrect_guesses.push(@guess)
    puts ""
    puts "incorrect guesses are: "
    p @incorrect_guesses
    puts ""
  end

  def check_winner
    if @secret_word == @correct_guesses
      puts "player wins!"
      exit
    elsif @guesses > 6
      puts "computer wins!"
      exit
    else 
      return
    end
  end

  def save_game
    game_state = YAML.dump({
      correct_guesses: @correct_guesses,
      incorrect_guesses: @incorrect_guesses,
      guesses: @guesses,
      secret_word: @secret_word
   })
   File.open("save_data.txt", "w") {|f| f.write game_state}
  end

  def load_game
    game_state = File.open('save_data.txt', 'r') { |f| YAML.load(f) }

    @incorrect_guesses = game_state[:incorrect_guesses]
    @guesses = game_state[:guesses]
    @secret_word = game_state[:secret_word]
    @correct_guesses = game_state[:correct_guesses]
    
    puts "correct guesses are: "
    p @correct_guesses
    puts "------"
    puts "incorrect_guesses are: "
    p @incorrect_guesses

    play
  end
end

game = Hangman.new.menu