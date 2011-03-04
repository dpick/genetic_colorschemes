require 'genetic_colors'

describe 'hex_distance tests' do
  [

   ["123456", "654321", 0],
   ["123456", "654326", 1],
   ["123456", "654356", 2],
   ["123456", "654456", 3],
   ["123456", "653456", 4],
   ["123456", "623456", 5],
   ["123456", "123456", 6],

  ].each do |value_1, value_2, amount_the_same|
    it "should return #{amount_the_same} for #{value_1} and #{value_2}" do
      hex_distance(value_1, value_2).should == amount_the_same
    end
  end
end
