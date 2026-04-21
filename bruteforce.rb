require 'benchmark'

def bruteforce(alpha, beta, p_mod)
  puts "start bruteforce til #{p_mod}"
  
  (0...p_mod).each do |x|
    if alpha.pow(x, p_mod) == beta
      return x
    end
    
  end
  
  nil
end

alpha = 5
beta = 9477
p_mod = 10007

result = nil

time = Benchmark.realtime do
  result = bruteforce(alpha, beta, p_mod)
end

puts "\nresult: x = #{result}"
puts "time: #{time.round(4)} sec"
