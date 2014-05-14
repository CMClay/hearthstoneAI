require './game3.6'

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
