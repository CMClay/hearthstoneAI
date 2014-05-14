
=begin
Version notes:
Many AI bugs fixed!!!! Previous version have big AI problems
Refactored Game class

Trying to implement taunt
testing git changes
=end

require './minion'
require './card'
require './game'

class Player
	attr_reader :name, :hand
	attr_accessor :tableau, :opponent, :damage, :life

	def initialize(deck, name, game)

		@game = game
		@temp_mana = 0
		@total_mana = 0
		@hand = []
		@deck = deck
		@life = 30
		@tableau = []
		@name = name
		@opponent = name == :p1 ? game.p2 : game.p1
		@damage = 0
	end

	def to_s
		"#{@name}"
	end

	def draw
		if !@deck.empty?
			card = @deck.pop
			card.owner = self
			puts "Card drawn: #{card}" #DEBUG
			@hand << card
			@hand.sort_by! {|c| c.cost}
		else
			nil
		end
	end

	def gets_hit(damage)
		if damage == 0 then return end
		@life -= damage
		puts "  #{self} gets hit for #{damage}. Now has #{@life} life" 
	end
	def end_turn
		tableau.each do |m|
			m.fresh = false
		end
		if @tableau.length != @tableau.uniq.length then raise "error in turn end #{@tableau.length},#{@tableau.uniq.length}"end #=============================================================================
	end

	def begin_turn
		num_ready = @tableau.select {|c| !c.fresh}
		# puts "#{num_ready.length} Creatures ready to attack."
		if draw == nil #If the deck is empty... game over.
			puts "Out of cards"
			return @game.game_over(self)
		end
		@total_mana += 1 unless @total_mana >=10
		@temp_mana = @total_mana
		ai_turn
		end_turn
		@game.end_turn
	end
	private #PRIVATE methods========

  #Original method!!!!!!!
	def ai_turn
		playable = @hand.select {|c| c.cost <= @temp_mana}
		while !playable.empty? do
			play_card(playable[-1])
			playable = @hand.select {|c| c.cost <= @temp_mana}
		end
		ai_attack
	end

	def ai_attack
		attack_times = 0
		temp = Array.new(@tableau)
		temp.each do |c|
			attack_times += 1 unless c.fresh
			c.attack(select_target) unless c.fresh
		end

		#puts "Attacked #{attack_times} times"
	end
	def play_card(card)
		@temp_mana -= card.cost
		#card.play
		card.play(select_target)
		@hand.delete(card)			
	end
	def select_target

		if @opponent.tableau.empty?
			return @opponent
		else
			minions_with_taunt = @opponent.tableau.select {|m| m.taunt}
			if !minions_with_taunt.empty?
				return minions_with_taunt.sample
			else
				targets = Array.new(@opponent.tableau) << @opponent
				return targets.sample
				#return @opponent.tableau.sample
			end
		end
	end
	#end of PRIVATE methods=========
end

