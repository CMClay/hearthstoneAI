load 'game3.6.rb'
load 'deck_generator.rb'
require './game'

#Start of executable Code---------------------------------------------------------------------------------------------

n = 1
while n==0
	print "How many games would you like to play?"
	n = gets.chomp.to_i
end

n.to_i.times do
	deck1 = deck_generator(4,6)
	deck2 = deck_generator2(1,6)

	game = Game.new(deck1,deck2)
	game.start
end

puts "\n\n\n#{Game.win_count}"

