require 'pp'

HEX_VALUES = { 10 => 'A', 11 => 'B', 12 => 'C', 13 => 'D', 14 => 'E', 15 => 'F' }

VALUES = ["Boolean", "Character"]

GOAL = { "Boolean" => "AE81FF",
         "Character" => "E6DB74"}

def random_hex_value
  hex_string = ""

  0.upto(6).each do |i|
    rand_num = rand(15) + 1

    if rand_num < 10
      hex_val = rand_num 
    else
      hex_val = HEX_VALUES[rand_num]
    end

    hex_string << hex_val.to_s
  end

  hex_string
end

def hex_distance(value_1, value_2)
  sum = 0
  value_1.to_a.each_index do |i|
    sum += 1 if value_1[i] == value_2[i]
  end

  sum
end

def initialize_pop(pop_size, p_crossover, p_mutation)
  population = Array.new(pop_size) do |i|
    VALUES.inject({}) { |hash, value| hash[value] = random_hex_value; hash }
  end
end

def fitness(population)
  sum = 0
  population.each do |key, value|
    sum += hex_distance(value, GOAL[key])
  end

  sum
end

def search(pop_size, p_crossover, p_mutation)
  population = initialize_pop(pop_size, p_crossover, p_mutation)
  population.each { |pop| pop[:fitness] = fitness(pop) }
end

pp search(10, 10, 10)
