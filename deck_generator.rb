load 'game3.6.rb'
load 'cards.rb'
require './deck'

#module DeckGenerator

def deck_generator(min_cost, max_cost, options = nil)
	deck = []
	(0..30).each do |num|
		n = min_cost + rand(max_cost-min_cost+1)

		if num % 3 == 0
			deck << AbusiveSergeant.new
		elsif num % 3 == 1 
			deck << AbusiveSergeant.new
		elsif num % 3 == 2
			deck << AbusiveSergeant.new
		end
				
		#deck << get_card(n)
	end
	if deck.length != deck.uniq.length
		raise "deck creation error!!!"		
	end
	return Deck.new(deck)
end

def deck_generator2(min_cost, max_cost, options = nil)
	deck = []
	(0..30).each do |num|
		n = min_cost + rand(max_cost-min_cost+1)

		if num % 3 == 0
			deck << Sunwalker.new
		elsif num % 3 == 1 
			deck << ArgentSquire.new
		elsif num % 3 == 2
			deck << Sunwalker.new
		end
				
		#deck << get_card(n)
	end
	if deck.length != deck.uniq.length
		raise "deck creation error!!!"		
	end
	return Deck.new(deck)
end

#end

=begin Old version

def deck_generator(min_cost, max_cost, options = nil)
	deck = []
	(0..30).each do
		n = min_cost + rand(max_cost-min_cost+1)
		if rand(0)%2 != 0  # 1 in 2 chance of creating a minion
			if rand(3)%2 == 1
				deck << Minion.new("random",n,n,n,{taunt: true})
			else
				deck << Minion.new("random",n,n,n)
			end
		else
			deck << Spell.new("random",n,n)
		end
	end

	if deck.length != deck.uniq.length
		raise "deck creation error!!!"		
	end
	return Deck.new(deck)
end
	
=end