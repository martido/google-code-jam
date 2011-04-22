# Google Code Jam - 2010 - Qualification
# Problem A. SnapperChain
# http://code.google.com/codejam/contest/dashboard?c=433101#s=p0&a=0

require 'benchmark'

class SnapperChain
  
  def solve(dataset)    
    File.open(dataset, 'r') do |input|
      File.open(dataset.sub(/\.in/, '.out'), 'w') do |output|
        test_cases = input.readline.to_i
        1.upto(test_cases) do |test_case|
          # n = number of Snapper devices
          # k = number of times fingers are snapped
          n,k = input.readline.split(/ /).map { |s| s.to_i }
          state = light_state(n,k)
          output << %Q{Case ##{test_case}: #{state}\n}
        end
      end
    end
  end
  
  def light_state(n, k)
    # ON/OFF states of a snapper can be viewed as a sequence of
    # bits (1 = ON, 0 = OFF). If you run through an example you
    # will notice that with each snap of your finger the value
    # of the sequence is incremented by one. Thus, for the light
    # to receive power you need to have a sequence of 1s. This
    # is achieved by snapping you fingers 2**n - 1 times.
    if (k + 1) % (2**n) == 0
      :ON
    else
      :OFF
    end
  end
  
end

problem = SnapperChain.new
Benchmark.bm do |x|
  x.report('small') { problem.solve('A-small-practice.in') }
  x.report('large') { problem.solve('A-large-practice.in') }
end
