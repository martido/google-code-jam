# Google Code Jam - 2009 - Qualification Round
# Problem A. Alien Language
# http://code.google.com/codejam/contest/dashboard?c=90101#s=p0

require 'benchmark'

class AlienLanguage

  def solve(dataset)
    File.open(dataset, 'r') do |input|
      File.open(dataset.sub(/\.in/, '.out'), 'w') do |output|
        length, words, test_cases = input.readline.split(/ /).map { |s| s.to_i }
        @words = []
        1.upto(words) do
          @words << input.readline.chomp
        end
        1.upto(test_cases) do |test_case|
          pattern = input.readline.chomp
          count = interpret(pattern)
          output << %Q{Case ##{test_case}: #{count}\n}
        end
      end
    end
  end

  def interpret(pattern)
    matches = 0
    regexp = to_regexp(pattern)
    @words.each do |word|
      matches += 1 if word.match(/#{regexp}/)
    end
    matches
  end

  def to_regexp(pattern)
    pattern.gsub(/\((.*?)\)/, '[\1]')
  end

  # Solution taken from http://www.intellitures.com/blog/?p=200
  def interpret_improved(pattern)
    matches = 0
    tokens = tokenize(pattern)
    @words.each do |word|
      index = 0
      found_char = true
      word.each_char do |char|
        if !tokens[index].include?(char)
          found_char = false
          break
        end
        index += 1
      end
      matches += 1 if found_char
    end
    matches
  end

  def tokenize(pattern)
    tokens = []
    pattern.scan(/[a-z]|\(.*?\)/) do |t|
      if t.start_with?('(')
        tokens << t.slice!(1..-2)
      else
        tokens << t
      end
    end
    tokens
  end
end

problem = AlienLanguage.new
Benchmark.bm do |x|
  x.report('small') { problem.solve('A-small-practice.in') }
  x.report('large') { problem.solve('A-large-practice.in') }
end
