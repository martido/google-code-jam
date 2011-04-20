# Google Code Jam - 2009 - Round 1C
# Problem A. All Your Base
# http://code.google.com/codejam/contest/dashboard?c=189252#s=p0

require 'benchmark'

class AllYourBase
  
  def solve(dataset)    
    File.open(dataset, 'r') do |input|
      File.open(dataset.sub(/\.in/, '.out'), 'w') do |output|
        test_cases = input.readline.to_i
        1.upto(test_cases) do |test_case|
          symbols = input.readline.chomp
          seconds = translate(symbols)
          output << %Q{Case ##{test_case}: #{seconds}\n}
        end
      end
    end
  end
  
  def translate(symbols)
    lookup = {}
    symbols.each_char do |s|
      if !lookup.include?(s)
        size = lookup.size
        case size
          when 0 then lookup[s] = 1
          when 1 then lookup[s] = 0
          else lookup[s] = size
        end
      end
    end    
    result = 0
    base = lookup.size > 1 ? lookup.size : 2
    symbols.split(//).each_with_index do |s,i|
      result += lookup[s] * base**(symbols.size - 1 - i)
    end
    result
  end
end

problem = AllYourBase.new
Benchmark.bm do |x|
  x.report('small') { problem.solve('A-small-practice.in') }
  x.report('large') { problem.solve('A-large-practice.in') }
end
