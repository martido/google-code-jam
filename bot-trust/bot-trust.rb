# Google Code Jam - 2011 - Qualification
# Problem A. Bot Trust
# http://code.google.com/codejam/contest/975485/dashboard

require 'benchmark'

class Action

  def initialize(name, pos)
    @name = name
    @pos = pos
  end

  def name
    @name
  end

  def pos
    @pos
  end

  def to_s
    "Action(#{@name}, #{@pos})"
  end

end

class BotTrust

  def solve(dataset)
    File.open(dataset, 'r') do |input|
      File.open(dataset.sub(/\.in/, '.out'), 'w') do |output|
        test_cases = input.readline.to_i
        1.upto(test_cases) do |test_case|
          line = input.readline.split(/ /).drop(1)

          seq = []
          line.each_with_index do |elem, index|
            seq.push(Action.new(elem, line[index + 1].to_i)) if index % 2 == 0
          end

          time = compute_min_time(seq)
          output << %Q{Case ##{test_case}: #{time}\n}
        end
      end
    end
  end

  def compute_min_time(seq)

    time = 0
    pos_o = 1
    pos_b = 1

    until seq.empty?

      next_action = seq.first
      next_action_o = seq.find { |elem| elem.name == 'O' }
      next_action_b = seq.find { |elem| elem.name == 'B' }

      # puts "Next action: #{next_action}"
      # puts "Next action O: #{next_action_o}"
      # puts "Next action B: #{next_action_b}"

      unless next_action_o.nil?
        if pos_o == next_action_o.pos
          if next_action.name == 'O'
            # puts "O pushes button #{next_action_o.pos}"
            seq.shift
          else
            # puts "O stays at button #{next_action_o.pos}"
          end
        elsif pos_o < next_action_o.pos
          # puts 'O moves right'
          pos_o += 1
        elsif pos_o > next_action_o.pos
          # puts 'O moves left'
          pos_o -= 1
        end
      end

      unless next_action_b.nil?
        if pos_b == next_action_b.pos
          if next_action.name == 'B'
            # puts "B pushes button #{next_action_b.pos}"
            seq.shift
          else
            # puts "B stays at button #{next_action_b.pos}"
          end
        elsif pos_b < next_action_b.pos
          # puts 'B moves right'
          pos_b += 1
        elsif pos_b > next_action_b.pos
          # puts 'B moves left'
          pos_b -= 1
        end
      end

      time += 1
    end

    time
  end

end

problem = BotTrust.new
Benchmark.bm do |x|
  x.report('small') { problem.solve('A-small-practice.in') }
  x.report('large') { problem.solve('A-large-practice.in') }
end
