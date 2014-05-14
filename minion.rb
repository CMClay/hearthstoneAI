require './card'
require './game3.6'

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
