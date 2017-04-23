class Game < ApplicationRecord
  has_many :gameplays
  
  def winner
    self.gameplays.where(score: 10).player.name
  end
  
  def player_count
    self.gameplays.count
  end
  
  # Recalculates ratings for ALL games
  def self.recalculate_ratings
    puts "Starting recalculations...."
    # byebug
    # Reset everyone's ratings
    Gameplay.all.each do |gp|
      # puts "Setting gameplays............."
      gp.before = nil
      gp.after = nil
      gp.save
    end
    puts "Gameplay ratings reset (0)"
    
    Player.all.each do |pl|
      # puts "Resetting scores and games <<<<<<<<<<<<<<<"
      gp = pl.gameplays.first
      gp.before = 1000
      gp.save
      # puts pl.gameplays.first.before
      pl.reset_games
      # byebug
      puts "#{pl.name} GP = #{pl.games_played}"
    end
    puts "First gameplay ratings (.before) set (1000); game_played set to 0"
    
    # byebug
    
    # games = Game.all.sort_by(&:number)
    games = Game.first(12)
    games.each do |game|
      puts "Starting calcs for game ##{game.number}"
      
      # Sets all .afters to the before values, ready to be changed
      game.gameplays.each do |gp|
        puts "Game ##{game.number}, Player: #{gp.player.name}"
        arr = gp.player.games
        # puts arr.join(' ')
        i = arr.index(gp.game.number)
        # puts i
        
        if !(gp.game.number == arr[0])
          # puts "NOT SKIPPED"
          # Will skip if it's the first game
          # puts gp.player.gameplays.find_by(game: arr[i-1]).after
          gp.before = gp.player.gameplays.find_by(game: arr[i-1]).after
          
          gp.save
          puts ".before saved? #{gp.player.gameplays.find_by(game: arr[i-1]).after}"
        end
        
        gp.after = gp.before
        gp.save
        # puts "#{gp.player.name} gp.before = #{gp.before}"
        # puts "#{gp.player.name} gp.after = #{gp.after}"
        # byebug
      end
      puts "All afters in gameplays for game #{game.number} set"
      
      game.gameplays.sort_by(&:position).each do |gp|
        puts "Starting h2h's for #{gp.player.name}"
        if gp.player.provisional?
          puts "#{gp.player.name} is provisional"
          gp.calc_prov_win
          gp.save
          next
        else
          # unless gp.position == game.player_count
          
          # gp.game.gameplays.where("position > ?", gp.position).each do |opp|
          #   gp.h2h(opp)
          # end
          
          # TODO: MAKE SURE EVERONE IS COMPARED, PROVISIONAL OR OTHERWISE
          gp.game.gameplays.each do |opp|
            if opp.position > gp.position
              if opp.player.provisional?
                gp.h2h(opp, true)
              else
                gp.h2h(opp, false)
              end
            end
          end
          
          
          # end
        end
        
      end
      
      game.gameplays.each do |gp|
        puts "#{gp.player.name}: #{gp.before} -> #{gp.after}"
        pl = gp.player
        pl.games_played += 1
        pl.save
      end
    end
  end
  
end
