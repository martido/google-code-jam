# Google Code Jam - Africa 2010 - Qualification Round
# Problem A. Store Credit
# http://code.google.com/codejam/contest/dashboard?c=351101#s=p0

require 'benchmark'

class StoreCredit

  def solve(dataset)
    File.open(dataset, 'r') do |input|
      File.open(dataset.sub(/\.in/, '.out'), 'w') do |output|
        test_cases = input.readline.to_i
        1.upto(test_cases) do |test_case|
          store_credit = input.readline.to_i
          available_items = input.readline.to_i
          prices = input.readline.split(/ /).map { |s| s.to_i }
          cart = buy(store_credit, available_items, prices)
          output << %Q{Case ##{test_case}: #{cart.join(" ")}\n}
        end
      end
    end
  end

  def buy(store_credit, available_items, prices)

    sorted_prices = prices.sort

    # Discard items which are more expensive than store_credit.
    tail = available_items - 1
    while sorted_prices[tail] > store_credit do
      tail -= 1
    end

    cart = []

    0.upto(tail) do |head|
      h = sorted_prices[head]
      t = sorted_prices[tail]
      sum = h + t
      if sum < store_credit
        next
      elsif sum > store_credit
        tail -= 1
        redo
      else # There's always exactly one solution.
        cart << prices.index(h) + 1
        cart << prices.rindex(t) + 1
        break
      end
    end

    # Lower index comes first.
    cart.sort!
  end

  def buy_naive(store_credit, available_items, prices)
    buy = []
    0.upto(prices.length - 1) do |i|
      stop = false
      1.upto(prices.length - 1) do |j|
        next if i == j
        if prices[i] + prices[j] == store_credit
          buy << i + 1 << j + 1
          stop = true
          break
        end
      end
      break if stop
    end
    buy
  end
end

problem = StoreCredit.new
Benchmark.bm do |x|
  x.report('small') { problem.solve('A-small-practice.in') }
  x.report('large') { problem.solve('A-large-practice.in') }
end
