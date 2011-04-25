# Google Code Jam - 2010 - Qualification
# Problem C. Theme Park
# http://code.google.com/codejam/contest/dashboard?c=433101#s=p2

require 'benchmark'

class ThemePark

  def solve(dataset)
    File.open(dataset, 'r') do |input|
      File.open(dataset.sub(/\.in/, '.out'), 'w') do |output|
        test_cases = input.readline.to_i
        1.upto(test_cases) do |test_case|
          # r = number of times the roller coaster will run in a day
          # k = number of people the roller coaster can hold at once
          # n = number of groups that are queued for the roller coaster
          r, k, n = input.readline.split(/ /).map { |s| s.to_i }
          groups = input.readline.split(/ /).map { |s| s.to_i }
          profit = run(r, k, n, groups)
          output << %Q{Case ##{test_case}: #{profit}\n}
        end
      end
    end
  end

  # Optimized version of the naive algorithm that works by detecting
  # cycles in the queue; complexity is O(n * n) in the worst case.
  #
  # According to the Google solution there are also O(n * logn) and
  # even O(n) algorithms that solve this problem.
  def run(r, k, n, groups)

    total_profit = 0
    head = 0 # Keeps track of the head of the queue.
    cache = {}

    1.upto(r) do |i|

      # A cycle was detected.
      if cache.include?(head)
        runs_per_cycle = i - cache[head][:run]
        remaining_runs = r - (i - 1)
        remaining_cycles = remaining_runs / runs_per_cycle
        profit_per_cycle = total_profit - cache[head][:profit]
        total_profit += remaining_cycles * profit_per_cycle

        if(remaining_runs % runs_per_cycle > 0)
          last = head
          1.upto(remaining_runs % runs_per_cycle) do
            last = cache[last][:next]
          end
          total_profit += cache[last][:profit] - cache[head][:profit]
        end
        break
      end

      people = 0
      start = head

      # Simulate the roller coaster run.
      0.upto(n) do |j|
        if j == n || people + groups[head] > k
          cache[start] = {
            :run => i,
            :profit => total_profit, # The profit *before* run #i.
            :next => head # The head of the queue for the next run.
          }
          total_profit += people
          break
        end
        people += groups[head]
        head = head + 1 >= n ? 0 : head + 1
      end
    end
    total_profit
  end

  # Works well on the small data set, but is far too slow for
  # the large one; complexity is O(r * n) in the worst case.
  def run_naive(r, k, n, groups)

    profit = 0
    head = 0 # Keeps track of the head of the queue.

    1.upto(r) do
      people = 0
      0.upto(n) do |j|
        if j == n || people + groups[head] > k
          profit += people
          break
        end
        people += groups[head]
        head = head + 1 > n - 1 ? 0 : head + 1
      end
    end
    profit
  end
end

problem = ThemePark.new
Benchmark.bm do |x|
  x.report('small') { problem.solve('C-small-practice.in') }
  x.report('large') { problem.solve('C-large-practice.in') }
end
