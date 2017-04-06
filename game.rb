require "pry"
require_relative "player.rb"

$player_list = []
$game_list = []

$BETA =     -550
$REGK =     25
$PROVK =    25
$WINLOSS =  5
$OPPPROV =  1

al = Player.new("Al")
bob = Player.new("Bob")
carl = Player.new("Carl")
dan = Player.new("Dan")

class Game
    
    attr_accessor :id, :date, :players, :scores, :old_ratings, :new_ratings, :dice_rolls, :layout
    
    def initialize(id, date, *players)

        raise ArgumentError, "Less than 3 players given." if players.length < 3
        raise ArgumentError, "More than 6 players given." if players.length > 6

        # Adds self to global list of Game objects
        $game_list.push(self)
        
        @id = id
        @date = date
        @players = players # Array of Player objects given during instantiation
        
        # Creates hash of players and their scores
        @scores = {}
        for player in players
            print "Score for #{player.name}? "
            @scores[player] = gets.chomp.to_i
        end
        
        # Creates hash of player ratings at beginning of game (for storage reasons, mostly)
        @old_ratings = {}
        for player in players
            @old_ratings[player] = player.old_rating
        end
        
        # Creates hash of player ratings at end of game, to be filled in during calc_ratings
        @new_ratings = {}
        
        
        @dice_rolls = []
        @layout = []
        
        # Increments each player's game_played attribute and changes provisional status if necessary
        for player in players do
            
            player.games_played += 1
            
            # The 5th game is still judged as provisional
            if player.games_played > 5
                player.provisional = false
            end
        end
    end
    
    def sum_scores
        # Sum is set to -10 since we'd be taking out the winner's score (10) anyways
        sum = 0
        @scores.each { |(k, v)| sum += v}
        return sum
    end
    
    ######TODO: MAKE SURE OLD/UPDATED RATINGS ARE GETTING TO THE RIGHT PLACES
    def calc_ratings
        # Changes players' ratings
        x = 1
        @players.each do |player|
            puts "Starting calcs for #{player.name}"
            player.scores[self.id] = @scores[player]
            puts "#{player.name}'s score added to personal score list"
            
            if player.provisional == true
                if @scores[player] == 10
                    puts "#{player.name} won this provisional game."
                    rating_change = $PROVK * (players.length - 1)
                    player.rating += rating_change
                else
                    puts "#{player.name} lost this provisional game."
                    proportion = @scores[player].to_f / (self.sum_scores - 10)
                    puts "Proportion: #{proportion}"
                    # The (-2 * $PROVK) part essentially inverses a player's
                    # rating_change. Higher proportion -> lower rating loss.
                    rating_change = (-2 * $PROVK) + (proportion * ($PROVK * (players.length - 1)))
                    puts "Rating change: #{rating_change}"
                    player.rating += rating_change
                end
            else
                if player == @players[-1]
                    break
                end
                @players[x..-1].each do |opponent| # Compares to each following player in array
                    puts "versus #{opponent.name}"
                    expected_score = [((@old_ratings[player] + $BETA) / (@old_ratings[opponent] + $BETA) * @scores[opponent]), 2].max
                    
                    rating_change = [(@scores[player]/expected_score), (expected_score/@scores[player])].min - 1
                    
                    if @scores[player] > expected_score
                        rating_change = -rating_change
                    end
                    
                    rating_change = rating_change * $REGK
                    
                    if @scores[player] > @scores[opponent]
                        rating_change += $WINLOSS
                        
                    player.rating += rating_change
                    opponent.rating -= rating_change
                    
                    end
                end
            end
            x += 1
            

        end
        
        for player in players
            @new_ratings[player] = player.rating
            puts "Added #{player.name} to @new_ratings"
            player.old_rating = player.rating
            puts "old_rating set equal to rating in preparation for future games"
        end
        return @new_ratings
    end
    
end

game1 = Game.new(1, "1/1/16", al, bob, carl, dan)

binding.pry


