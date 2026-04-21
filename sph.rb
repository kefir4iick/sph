require 'prime'
require 'benchmark'

def extended_gcd(a, b)
  return [0, 1] if a == 0
  x, y = extended_gcd(b % a, a)
  [y - (b / a) * x, x]
end

def mod_inverse(a, m)
  x, _ = extended_gcd(a, m)
  (x % m + m) % m
end

def crt(remainders, moduli)
  m_total = moduli.reduce(:*)
  result = 0
  
  moduli.each_with_index do |m, i|
    mi = m_total / m
    y = mod_inverse(mi, m)
    result = (result + remainders[i] * mi * y) % m_total
  end
  result
end

def solve_subgroup(alpha, beta, n, p, l, p_mod)
  group_order = p**l
  m = Math.sqrt(group_order).ceil
  
  alpha_0 = alpha.pow(n / group_order, p_mod)
  beta_0 = beta.pow(n / group_order, p_mod)
  
  table = {}
  current = 1
  (0...m).each do |j|
    table[current] = j
    current = (current * alpha_0) % p_mod
  end
  
  alpha_0_m = alpha_0.pow(m, p_mod)
  giant_step = mod_inverse(alpha_0_m, p_mod)
  
  gamma = beta_0
  
  (0...m).each do |i|
    if table.key?(gamma)
      j = table[gamma]
      return (i * m + j) % group_order
    end
    gamma = (gamma * giant_step) % p_mod
  end
  
end


def sph(alpha, beta, p_mod)
  n = p_mod - 1
  factors = Prime.prime_division(n)
  
  remainders = []
  moduli = []
  
  factors.each do |p, l|
    puts "multiplier processing: #{p}^#{l}"
    r = solve_subgroup(alpha, beta, n, p, l, p_mod)
    remainders << r
    moduli << p**l
  end
  
  crt(remainders, moduli)
end


puts "enter alpha:"
alpha = gets.chomp.to_i

puts "enter beta:"
beta = gets.chomp.to_i

puts "enter p_mod:"
p_mod = gets.chomp.to_i

result = nil

time = Benchmark.realtime do
  result = sph(alpha, beta, p_mod)
end


puts "\n-----------------------------\n"

puts "\nresult: x = #{result}"
puts "time: #{time.round(4)} sec"
