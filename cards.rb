load 'game3.6.rb'

def get_card (cost = nil)
	case cost
	when 1
		return Minion.new("Murloc Raider", 1, 2, 1)
	when 2
		return Minion.new("River Crocolist", 2, 2, 3)
	when 3
		return Minion.new("Scarlet Crusader", 3, 3, 1, {divine_shield: true})
	when 4
		return Minion.new("Sen'jin Shieldmasta", 4, 3, 5, {taunt: true})
	when 5
		return Minion.new("Fen Creeper", 5, 3, 6, {taunt: true})
	when 6
		return Minion.new("Sunwalker", 6, 4, 5, {divine_shield: true, taunt: true})
	else
		raise "Error creating Minion. cost = #{cost}"
	end
end




=begin
	card1 = {"River Crocolist", 2, 2, 3}
	card2 = {"Sen'jin Shieldmasta", 4, 3, 5, {taunt: true}}
	card3 = {"Murloc Raider", 1, 2, 1}
	card4 = {"Silverback Patriarch", 3, 1, 4, {taunt: true}}
	card5 = {"Scarlet Crusader", 3, 3, 1, {divine_shield: true}}
	card6 = {"Sunwalker", 6, 4, 5, {divine_shield: true, taunt: true}}

=end
class MurlocRaider < Minion
	def initialize(name = "Murloc Raider",cost = 1, damage = 2, life = 1)
		super
	end
end

class RiverCrocolist < Minion
	def initialize(name = "River Crocolist", cost = 2, damage = 2, life = 3)
		super
	end
end

class ScarletCrusader < Minion
	def initialize(name = "Scarlet Crusader", cost = 3, damage = 3, life = 1, options = {taunt: true})
		super
	end
end

class SenjinShieldmasta < Minion
	def initialize(name = "Sen'jin Shieldmasta", cost =  4, damage = 3, life =  5, options = {taunt: true})
		super
	end
end

class FenCreeper < Minion
	def initialize(name = "Fen Creeper", cost =  5, damage = 3, life =  6, options = {taunt: true})
		super
	end
end

class Sunwalker < Minion
	def initialize(name = "Sunwalker", cost =  6, damage = 4, life =  5, options = {taunt: true, divine_shield: true})
		super
	end
end

class Wisp < Minion
	def initialize(name = "Wisp", cost =  0, damage = 1, life =  1)
		super
	end
end

class AbusiveSergeant < Minion
	def initialize(name = "Abusive Sergeant", cost =  1, damage = 2, life =  1)
		super		
	end
	def play(target = @owner.opponent)	
		if !@owner.tableau.empty?
			@owner.tableau.sample.buff << Buff.new(@owner.tableau[0], "damage", 2)  #AI needed in targeting
		end
		super
	end
end

class AngryChicken < Minion  #Need to implement enrage
	def initialize(name = "Angry Chicken", cost =  1, damage = 1, life =  1)
		super
	end
end

class ArgentSquire < Minion
	def initialize(name = "Argent Squire", cost =  1, damage = 1, life =  1, options = {divine_shield: true})
		super
	end
end


def create_minion(minion_name = nil)
	list = {"Murloc Raider" => MurlocRaider}
	return list[minion_name].new
end
