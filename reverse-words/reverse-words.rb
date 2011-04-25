# Google Code Jam - Africa 2010 - Qualification Round
# Problem B. Reverse Words
# http://code.google.com/codejam/contest/dashboard?c=351101#s=p1

require 'benchmark'

class ReverseWords

  def solve(dataset)
    File.open(dataset, 'r') do |input|
      File.open(dataset.sub(/\.in/, '.out'), 'w') do |output|
        input.each_with_index do |line,index|
          next if index == 0
          words = line.chomp!.split(/ /).reverse
          output << %Q{Case ##{index}: #{words.join(" ")}\n}
        end
      end
    end
  end

end

problem = ReverseWords.new
Benchmark.bm do |x|
  x.report('small') { problem.solve('B-small-practice.in') }
  x.report('large') { problem.solve('B-large-practice.in') }
end
