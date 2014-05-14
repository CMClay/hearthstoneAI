require './cards'

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