# Google Code Jam - 2010 - Round 1A
# Problem A. Rotate
# http://code.google.com/codejam/contest/dashboard?c=544101#s=p0

require 'benchmark'

class Rotate
  
  def solve(dataset)    
    File.open(dataset, 'r') do |input|
      File.open(dataset.sub(/\.in/, '.out'), 'w') do |output|
        test_cases = input.readline.to_i
        1.upto(test_cases) do |test_case|
          n,k = input.readline.split(/ /).map { |s| s.to_i }
          board = []
          1.upto(n) do
            board << input.readline.chomp.split(//)
          end
          
          # According to the Google solution you don't actually need
          # to rotate the board; shifting all pieces to the right is 
          # eqivalent to rotating the board and letting the pieces 
          # drop down.
          
          rotate_in_place(board, n)
          drop_in_place(board, n)
          winner = find_winner(board, n, k)
          output << %Q{Case ##{test_case}: #{winner}\n}
        end
      end
    end
  end
  
  # Rotate board 90 degrees clockwise (using additional space).
  def rotate(board, n)
    r = []
    0.upto(n-1) do |i| #Rows
      r[i] = []
      0.upto(n-1) do |j| # Columns
        r[i][j] = board[n-j-1][i]
      end
    end
    r
  end
  
  # Rotate board 90 degrees clockwise (in-place).
  # See: http://goo.gl/voIJu
  def rotate_in_place(board, n)
    for i in 0...n/2 # Rows
      for j in i...n-i-1 # Columns
        tmp=board[i][j]
        board[i][j] = board[n-j-1][i]
        board[n-j-1][i]=board[n-i-1][n-j-1]
        board[n-i-1][n-j-1]=board[j][n-i-1]
        board[j][n-i-1] = tmp
      end
    end
  end  
  
  # Drop pieces in-place one column at a time.
  # Probably results in cache misses if the matrix is large enough.
  def drop_in_place(board, n)
    0.upto(n-1) do |j| # Columns
      drop = 0
      (n-1).downto(0) do |i| # Rows
        if board[i][j] == '.'
          drop += 1 
          next
        end
        if drop > 0
          board[i + drop][j] = board[i][j]
          board[i][j] = '.'
        end
      end
    end
  end
  
  def shift_in_place(board, n)
    0.upto(n-1) do |i| # Rows
      shift = 0
      (n-1).downto(0) do |j| # Columns
        if board[i][j] == '.'
          shift += 1
          next
        end
        if shift > 0
          board[i][j + shift] = board[i][j]
          board[i][j] = '.'
        end
      end
    end
  end
  
  def find_winner(board, n, k)
    blue_wins = false
    red_wins = false
    0.upto(n-1) do |i| #Rows
      0.upto(n-1) do |j| # Columns
        next if board[i][j] == '.'
        
        color = board[i][j]
        
        # No need to check if one of the players has alreay won.
        next if (blue_wins and color == 'B') or (red_wins and color == 'R')
        
        # Check in 4 directions for each slot, but only if there's 
        # enough space in the particular direction.
        
        # Check horizonally right.
        if j + k <= n
          x = 1
          while(j + x < n && board[i][j+x] == color)
            x += 1
            if x == k
              blue_wins = true if color == 'B'
              red_wins = true if color == 'R'
            end
          end
        end
        
        # Check vertically down.
        if i + k <= n
          x = 1
          while(i + x < n && board[i+x][j] == color)
            x += 1
            if x == k
              blue_wins = true if color == 'B'
              red_wins = true if color == 'R'
            end
          end
        end
        
        # Check diagonally down & right.
        if i + k <= n && j + k <= n
          x = 1
          while(i + x < n && j + x < n && board[i+x][j+x] == color)
            x += 1
            if x == k
              blue_wins = true if color == 'B'
              red_wins = true if color == 'R'
            end
          end
        end
        
        # Check diagonally down & left.
        if i + k <= n && j - k >= -1
          x = 1
          while(i + x < n && j - x < n && board[i+x][j-x] == color)
            x += 1
            if x == k
              blue_wins = true if color == 'B'
              red_wins = true if color == 'R'
            end
          end
        end
      end
    end
    
    return :Blue if blue_wins and !red_wins
    return :Red if !blue_wins and red_wins
    return :Both if blue_wins and red_wins
    return :Neither if !blue_wins and !red_wins
  end
  
  def print_board(board)
    board.each { |row| p row }
  end
end

problem = Rotate.new
Benchmark.bm do |x|
  x.report('small') { problem.solve('A-small-practice.in') }
  x.report('large') { problem.solve('A-large-practice.in') }
end
