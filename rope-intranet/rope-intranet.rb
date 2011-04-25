# Google Code Jam - 2010 - Round 1C
# Problem A. Rope Intranet
# http://code.google.com/codejam/contest/dashboard?c=619102#s=p0

require 'benchmark'

class RopeIntranet

  def solve(dataset)
    File.open(dataset, 'r') do |input|
      File.open(dataset.sub(/\.in/, '.out'), 'w') do |output|
        test_cases = input.readline.to_i
        1.upto(test_cases) do |test_case|
          wires_count = input.readline.to_i
          wires = []
          1.upto(wires_count) do
            wires << input.readline.split(/ /).map { |s| s.to_i }
          end
          points = intersection_points(wires)
          output << %Q{Case ##{test_case}: #{points}\n}
        end
      end
    end
  end

  def intersection_points(wires)
    count = 0
    0.upto(wires.length - 1) do |i|
      (i+1).upto(wires.length - 1) do |j|
        if (wires[i][0] < wires[j][0] && wires[i][1] > wires[j][1]) ||
           (wires[i][0] > wires[j][0] && wires[i][1] < wires[j][1])
          count += 1
        end
      end
    end
    count
  end
end

problem = RopeIntranet.new
Benchmark.bm do |x|
  x.report('small') { problem.solve('A-small-practice.in') }
  x.report('large') { problem.solve('A-large-practice.in') }
end
