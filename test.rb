#Unit tests for my game!!
=begin
load "game3.3.rb"
load 'deck_generator.rb'

deck = []
(1..30).each do |n|
	if n % 2 == 0
		m = Minion.new(2,2,2,{taunt: true})
	else
		m = Minion.new(3,3,3)
	end
	deck << m
end

puts deck
=end
f = "fizz"
b = "buzz"
(1..100).each do |n|
	if n % 3 == 0 && n % 5 == 0
		puts f+b
	elsif n % 3 == 0
		puts f
	elsif n % 5 == 0
		puts b
	else
		puts n
	end
end
		
		