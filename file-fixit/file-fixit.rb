# Google Code Jam - 2010 - Round 1B
# Problem A. File Fix-It
# http://code.google.com/codejam/contest/dashboard?c=635101#s=p0

require 'benchmark'
require 'set'

class FileFixit
  
  def solve(dataset)    
    File.open(dataset, 'r') do |input|
      File.open(dataset.sub(/\.in/, '.out'), 'w') do |output|
        test_cases = input.readline.to_i
        1.upto(test_cases) do |test_case|
          n,m = input.readline.split(/ /).map { |s| s.to_i }
          
          existing_paths = []
          1.upto(n) do
            existing_paths << input.readline.chomp
          end
          
          new_paths = []
          1.upto(m) do
            new_paths << input.readline.chomp
          end
          
          ops = mkdir(existing_paths, new_paths)
          output << %Q{Case ##{test_case}: #{ops}\n}
        end
      end
    end
  end
  
  def mkdir(existing_paths, new_paths)
    lookup = Set.new
    existing_paths.each do |path|
      to_components(path).each { |c| lookup.add?(c) }      
    end
    ops = 0
    new_paths.each do |path|
      to_components(path).each do |c|
        if !lookup.include?(c)
          ops += 1
          lookup.add?(c)
        end
      end
    end
    ops
  end
  
  def to_components(path)
    paths = []
    pos = nil
    while(pos != 0)
      paths << path
      pos = path.rindex('/')
      path = path.slice(0..pos-1)
    end
    paths
  end
end

problem = FileFixit.new
Benchmark.bm do |x|
  x.report('small') { problem.solve('A-small-practice.in') }
  x.report('large') { problem.solve('A-large-practice.in') }
end
