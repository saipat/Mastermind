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
  attr_reader :secret_code
end
