require "pry"


class Player
    attr_accessor :pref_color, :old_rating, :rating, :games_played, :provisional, :scores
    
    attr_reader :name
    
    def initialize(name)
        @name = name
        @old_rating = 1000.0
        @rating = 1000.0
        @games_played = 0
        @provisional = true
        # Hash of scores from games played
        @scores = {}
        
        # Adds self to global list of Player objects
        $player_list.push(self)
    end
    
    
    # def compare(opponent)
    #     opponent.old_rating
        
    # end
    
    
    
end

# binding.pry

