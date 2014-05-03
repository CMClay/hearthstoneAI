
=begin
Version notes:
Many AI bugs fixed!!!! Previous version have big AI problems
Refactored Game class

Trying to implement taunt

=end

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
#Cards =========================================================================================================================================
class Card
	attr_reader :cost, :name
	attr_accessor :owner, :damage
	@cost
	@damage
	@owner  #the deck the card belongs to OR the tableau it belongs to
	@target
	def attack(target)
		puts "#{self} attacks #{target}:"
		target.gets_hit(damage)
		hit_back = target.damage || 0
		self.gets_hit(hit_back)
	end
	def gets_hit(damage = 0) #No effect for spells
	end
end

class Buff
	attr_accessor :owner
	def initialize(card, attribute, change)
		@owner = card
		@attribute = attribute
		@change = change
		puts "#{card} has #{attribute} changed by #{change} "
		buff(change)
	end
	def buff(change)
		case @attribute
		when "damage"
			@owner.damage += change
		when "life"
			@owner.life += change
			@owner.max_life += change
			if @owner.life > @owner.max_life 
				 @owner.life = @owner.max_life
			end
		when "cost"
			@owner.cost += change
		end
	end
	def remove
		puts "#{card} has #{@attribute} changed by #{0-change}"
		buff(-change)		
	end
end

class Minion < Card
	attr_accessor :life, :damage, :fresh, :taunt, :divine_shield, :cost, :max_life, :buff

	def initialize(name, cost, damage, life, options = {})
		@name = name
		@cost = cost
		@damage = damage
		@max_life = life
		@life = life
		@fresh = true
		@taunt = options[:taunt] || false
		@divine_shield = options[:divine_shield] || false
		@turn_buff = []
		@buff = []
	end
	def play(target = @owner.opponent)
		puts "Summons #{self}"
		#super		
		@owner.tableau << self  
	end
	def to_s
		"#{@name}"
	end
	def gets_hit(damage, attacker = nil)
		if damage == 0 then return end
		print "  "
		if @divine_shield
			puts "#{@name} loses divine shield"
			@divine_shield = false
			return
		end		
		death = ""
		@life -= damage
		if @life <= 0
			@owner.tableau.delete(self)
			death = "it DIES!"
		end
		puts "#{self} gets hit for #{damage}! #{death}"
	end
end

class Spell < Card
	attr_reader :damage, :name
	def initialize(name, cost, damage)
		@name = name
		@cost = cost
		@damage = damage
	end
	def play(target = @owner.opponent)
		puts "Casts #{self}"
		attack(@target)
	end
	def to_s #DEBUG override to_s method
		"Spell: cost:#{@cost}->damage:#{@damage}"
	end
end

class Deck < Array #needs work!
	def initialize(cards)
		super
		cards.each do |c|
			c.owner = self
		end
	end
	def to_s
		"a deck with #{self.length} cards."
	end
end
#End Cards. Start Game=========================================================================================================================================
class Game
	attr_accessor :p1, :p2, :p1_win_count, :p2_win_count  #FOR DEBUG
	attr_reader :active_player, :turn_count
		@@p1_win_count = 0
		@@p2_win_count = 0
	def initialize(deck1, deck2)
		puts "NEW GAME!"
		@turn_count = 1
		@p1 = Player.new(deck1, :p1, self)
		@p2 = Player.new(deck2, :p2, self)
		@p1.opponent = @p2
		@p2.opponent = @p1
		@active_player = @p1
		"P1 draws:"
		3.times {@p1.draw}
		"P2 draws:"
		4.times {@p2.draw}
		puts "\n\n"
		#puts "\n\np1 init complete= #{@p1}, p2 init complete= #{@p2}"
	end
	def self.win_count
		"Player 1 won:#{@@p1_win_count} games\nPlayer 2 won:#{@@p2_win_count} games"
	end

	def start
		puts "start of turn #{@turn_count}" #DEBUG
		puts "#{@active_player}'s turn" #DEBUG	
		@active_player.begin_turn		
	end
	def self.opponent
		@active_player == @p1 ? @@p2 : @p1
	end
	def end_turn
		@active_player = @active_player == @p1 ? @p2 : @p1			
		puts "End of turn #{@turn_count}.\n#{@p1}: life=#{@p1.life}, Creatures=#{@p1.tableau.length}, Hand size=#{p1.hand.length}"
		#puts "tableau: #{@p1.tableau}"
		puts "#{@p2}: life=#{@p2.life}, Creatures=#{@p2.tableau.length}, Hand size=#{p2.hand.length}" #DEBUG
		#puts "tableau: #{@p2.tableau}"
		puts "\n\n"

		@turn_count += 1
		game_over? ? "the end": start
	end
	def game_over?
		if @turn_count > 100 then puts "turn count exceeded" end
		if @p1.life <= 0 || @p2.life <= 0
			winner = @p1.life >@p2.life ? "Player 1" : "Player 2"
			puts "The winner is #{winner}!!!"
			winner == "Player 1" ? @@p1_win_count+=1 : @@p2_win_count+=1
			return true
		else
			false
		end
	end
	def game_over(loser)
		puts "Game over. #{loser}"
	end
end

class Turn
end

