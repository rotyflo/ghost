require_relative "game"


puts "Who all is playing?"
puts "(enter 'done' when finished)"

players = []
player = ""

while player != "DONE"
  player = gets.chomp.upcase
  players << player
end

players.pop

game = Game.new(players)

game.run