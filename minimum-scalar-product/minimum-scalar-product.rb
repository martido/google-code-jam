# Google Code Jam - 2008 - Round 1
# Problem A. Minimum Scalar Product
# http://code.google.com/codejam/contest/dashboard?c=32016#s=p0

require 'benchmark'

class MinimumScalarProduct

  def solve(dataset)
    File.open(dataset, 'r') do |input|
      File.open(dataset.sub(/\.in/, '.out'), 'w') do |output|
        test_cases = input.readline.to_i
        1.upto(test_cases) do |test_case|
          vector_size = input.readline.to_i
          v1 = input.readline.split(/ /).map { |s| s.to_i }
          v2 = input.readline.split(/ /).map { |s| s.to_i }
          result = scalar_product(v1, v2)
          output << %Q{Case ##{test_case}: #{result}\n}
        end
      end
    end
  end

  def scalar_product(v1, v2)
    v1.sort!
    v2.sort! { |a,b| b <=> a }
    sp = 0
    0.upto(v1.length - 1) do |i|
      sp += v1[i] * v2[i]
    end
    sp
  end

  def scalar_product_naive(v1, v2)
    min = nil
    v1.permutation.to_a.each do |p1|
      v2.permutation.to_a.each do |p2|
        sp = 0
        p1.zip(p2).each do |x|
          sp += x.inject { |p, e| p *= e }
        end
        min = sp if min.nil? || sp < min
      end
    end
    min
  end
end

problem = MinimumScalarProduct.new
Benchmark.bm do |x|
  x.report('small') { problem.solve('A-small-practice.in') }
  x.report('large') { problem.solve('A-large-practice.in') }
end
