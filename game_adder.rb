puts "Up to game ##{Game.maximum(:number)}"
puts "Enter scores for game ##{Game.maximum(:number)+1}"
puts "Type 'stop' after all players have been entered"

g = Game.new
g.number = Game.maximum('number')+1
gp_array = []
pl_array = []
6.times do |i|
  print "Player #{i}: "
  player = gets.chomp
  if player == "stop"
    break
  end
  print "#{player}'s score: "
  score = gets.chomp
  pl = Player.where(name: player).first_or_initialize
  pl_array << pl
  gp = Gameplay.new(game: g, player: pl, score: score, position: i+1)
  gp_array << gp
end
puts "This look good?: (y/n)"
puts "Game #{g.number}"
gp_array.each do |gp|
  puts "#{gp.player.name}: #{gp.score}"
end
answer = gets.chomp
if answer == "y"
  pl_array.each(&:save!)
  gp_array.each(&:save!)
  g.save
else
  gp_array.each(&:destroy!)
  g.destroy
  puts "Game and gameplays removed -- will probably still need to manually remove new players"
end