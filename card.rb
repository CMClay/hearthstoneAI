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
