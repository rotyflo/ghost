require "set"
require_relative "player"
require_relative "aiplayer"

class Game
  attr_reader :dictionary,
              :players,
              :fragment

  def initialize(players)
    @players = players.map { |name| Player.new(name) }
    @index = 0
    @current_player = @players[@index]
    @previous_player = @players[@index - 1]
    @fragment = ""
    @dictionary = Set.new	# faster lookup than array
    f = File.open("dictionary.txt", "r")
    f.each_line { |word| @dictionary.add(word.chomp) }
  end

  def run
    while no_winners?
      play_round
      losers?
      print_results

      @fragment = ""
    end
  end

  def play_round
    while !over?
      letter = nil

      while !valid_play?(letter)
        letter = take_turn(@current_player)
      end

      @fragment += letter
      puts @fragment
      
      if over?
        @previous_player.losses += 1
      else
        next_player!
      end
    end
  end

  def next_player!
    @index = (@index + 1) % @players.length
    @current_player = @players[@index]
    @previous_player = @players[@index - 1]
  end

  def take_turn(player)
    puts "\nEnter one letter, " + player.name.to_s

    player.guess
  end

  def valid_play?(string)
    alpha = ("a".."z").to_a

    alpha.include?(string) && string.length == 1
  end

  def over?
    dictionary.include?(@fragment)
  end

  def print_results
    puts "\n\t" + @current_player.name + " wins with " + @fragment.upcase
    puts "\n\tScore:"
    
    @players.each do |player|
      puts "\t" + player.name + ": " + "GHOST"[0...player.losses]
    end
  end

  def losers?
    @players.each do |player|
      if player.losses >= 5
        puts "\n\t" + player.name + " has been eliminated\n"
        @players.delete(player)
      end
    end
  end

  def no_winners?
    @players.length > 1
  end
end