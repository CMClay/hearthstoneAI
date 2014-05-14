require './card'

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
