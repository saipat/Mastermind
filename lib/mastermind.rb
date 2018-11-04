class Code

  PEGS = {
    "B" => :blue,
    "G" => :green,
    "O" => :orange,
    "P" => :purple,
    "R" => :red,
    "Y" => :yellow
   }

  attr_reader :pegs

  def self.parse(str)
    pegs = str.chars.map do |ch|
     raise "Incvalid caolor" unless PEGS.keys.include?(ch.upcase)
     PEGS[ch.upcase]
   end

   Code.new(pegs)
  end

  def self.random
    pegs = []
    4.times do
      pegs << PEGS.values.sample
    end
    Code.new(pegs)
  end

  def initialize(pegs)
    @pegs = pegs
  end

  def [](i)
    pegs[i]
  end

  def exact_matches(code2)
    exact_match_count = 0

    @pegs.each_with_index do |peg, idx|
      exact_match_count += 1 if peg == code2[idx]
    end

    exact_match_count
  end

  def near_matches(code2)
    code2_color_count = code2.color_count
    near_match_count = 0

    self.color_count.each do |color, count|
      next unless code2_color_count.has_key?(color)
      near_match_count += [count, code2_color_count[color]].min
    end

    near_match_count - self.exact_matches(code2)
  end

  def ==(code2)
    return false unless code2.is_a?(Code)
    self.pegs == code2.pegs
  end

  protected

  def color_count
    count = Hash.new(0)

    self.pegs.each do |color|
      count[color] += 1
    end

    count
  end
end

class Game
  MAX_TURNS = 3
  attr_reader :secret_code

  def initialize(secret_code = Code.random)
    @secret_code = secret_code
    p @secret_code
  end

  def get_guess
    puts "Please guess the code. Choose from [Blue, Orange, Green, Yellow, Red, Prurple]."

    begin
      string = gets.chomp
      Code.parse(string)
    rescue
      pus "Invalid color. Error parsing the code!"
      retry
    end
  end

  def display_matches(code)
    puts "Your exact matches: #{@secret_code.exact_matches(code)}"
    puts "your near matches: #{@secret_code.near_matches(code)}"
  end

  def play
    MAX_TURNS.times do
      guess = get_guess
      if guess == @secret_code
        puts "You guessed it right pal!"
        return
      end
      display_matches(guess)
    end
    puts "Sorry! you ran out of you MAX turns! Try again."
  end
end


if __FILE__ == $PROGRAM_NAME
  Game.new.play
end
