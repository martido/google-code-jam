# Google Code Jam - 2010 - Qualification
# Problem B. Fair Warning
# http://code.google.com/codejam/contest/dashboard?c=433101#s=p1&a=0

require 'benchmark'

class FairWarning

  def solve(dataset)
    File.open(dataset, 'r') do |input|
      File.open(dataset.sub(/\.in/, '.out'), 'w') do |output|
        test_cases = input.readline.to_i
        1.upto(test_cases) do |test_case|
          line = input.readline.split(/ /)
          slarsecs = line[1..-1].map { |s| s.to_i }
          apocalypse = compute_apocalypse(slarsecs)
          output << %Q{Case ##{test_case}: #{apocalypse}\n}
        end
      end
    end
  end

  def compute_apocalypse(slarsecs)
    # The difference between two consecutive numbers in the array
    # must be a multiple of the largest possible T we are looking
    # for. This is because (a + y) % T = 0 and (b + y) % T = 0.
    # It then follows that |(a + y) - (b + y)| % T = 0. T is then
    # equal to the greatest common divisor of all the differences
    # of two consecutive numbers in the array.
    diff = slarsecs.each_cons(2).map { |a,b| (a-b).abs }
    # The GCD of 3 or more numbers can be computed by using
    # associativity, i.e. gcd(a,b,c) = gcd(gcd(a,b),c)
    # Note: The Google solution mentions yet another way to
    # compute the GCD of N numbers.
    gcd = diff.reduce { |prev,d| gcd(prev,d) }
    if slarsecs.first % gcd == 0
      0
    else
      gcd - slarsecs.first % gcd
    end
  end

  # Greatest common divisor using Euclid's algorithm.
  def gcd(a,b)
    return a if b == 0
    gcd(b, a % b)
  end
end

problem = FairWarning.new
Benchmark.bm do |x|
  x.report('small') { problem.solve('B-small-practice.in') }
  x.report('large') { problem.solve('B-large-practice.in') }
end
