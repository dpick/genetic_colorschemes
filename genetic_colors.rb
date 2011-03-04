require 'pp'

HEX_VALUES = { 10 => 'A', 11 => 'B', 12 => 'C', 13 => 'D', 14 => 'E', 15 => 'F' }

VALUES = ["Boolean", "Character"]

GOAL = { "Boolean" => "AE81FF",
         "Character" => "E6DB74"}

def random_hex_digit
  rand_num = rand(15) + 1
  hex_val = rand_num if rand_num < 10
  hex_val = HEX_VALUES[rand_num] if rand_num >= 10

  return hex_val.to_s
end

def random_hex_value
  hex_string = ""

  1.upto(6).each do |i|
    hex_string << random_hex_digit
  end

  hex_string
end

def hex_distance(value_1, value_2)
  sum = 0
  value_1.split("").each_index do |i|
    sum += i if value_1[i] == value_2[i]
  end

  sum
end

def initialize_pop(pop_size, p_crossover, p_mutation)
  population = Array.new(pop_size) do |i|
    VALUES.inject({}) { |hash, value| hash[value] = random_hex_value; hash }
  end
end

def binary_tournament(pop)
  i, j = rand(pop.size), rand(pop.size)
  j = rand(pop.size) while j == i
  return (pop[i][:fitness] > pop[j][:fitness]) ? pop[i] : pop[j]
end


def fitness(population)
  sum = 0
  population.each do |key, value|
    sum += hex_distance(value, GOAL[key]) if key != :fitness
  end

  sum
end

def mutate(colorscheme, rate = 1.0 / colorscheme.size)
  colorscheme.each do |key, value|
    colorscheme[key] = mutate_hex(value, rate) if rand < rate && key != :fitness
  end

  return colorscheme
end

def mutate_hex(hex_value, rate)
  array = hex_value.split("")

  array.each_index do |i|
    array[i] = random_hex_digit if rand < rate
  end

  return array.join("")
end

def crossover(parent_1, parent_2, rate)
  return parent_1 if rand > rate

  point = rand(parent_1.size)
  crossover_keys = parent_1.keys[0...point]

  parent_1.keys.each do |key|
    parent_1[key] = parent_2[key]
  end

  return parent_1
end

def reproduce(selected, pop_size, p_cross, p_mutation)
  children = []
  selected.each_with_index do |p1, i|
    p2 = (i % 2 == 0) ? selected[i+1] : selected[i-1]
    p2 = selected[0] if i == selected.size-1
    child = {}
    child = crossover(p1, p2, p_cross)
    child = mutate(child, p_mutation)
    children << child
    break if children.size >= pop_size
  end

  return children
end

def search(pop_size, p_crossover, p_mutation)
  population = initialize_pop(pop_size, p_crossover, p_mutation)
  population.each { |pop| pop[:fitness] = fitness(pop) }
  population.sort! { |x, y| y[:fitness] <=> x[:fitness] }
  best = population.first

  10000.times do
    selected = Array.new(pop_size) { |i| binary_tournament(population) }
    children = reproduce(selected, pop_size, p_crossover, p_mutation)
    children.each { |child| child[:fitness] = fitness(child) }
    children.sort! { |x, y| y[:fitness] <=> x[:fitness] }
    best = children.first.clone if children.first[:fitness] >= best[:fitness]
    population = children
  end

  return best
end
