class Player < ApplicationRecord
  has_many :gameplays
  
  def wins
    self.gameplays.where(score:10).count
  end
  
  def win_percentage
    self.gameplays.where(score:10).count.to_f / self.gameplays.count.to_f
  end
  
  def close_games
    self.gameplays.where(score:9).count
  end
  
  def average_score
    Gameplay.where(player: self).average(:score).to_f.round(2)
  end
  
  # def average_score_against
  # TODO: see blow TODO
  #   in_games = Gameplay.where
  #   Gameplay.where.not(player: self).average(:score).to_f.round(2)
  # end
  
  def blownouts
    self.gameplays.where("score < ?", 4).count
  end
  
  # def blowouts
  #   # TODO: select games that player is in, then select gameplays from there
  #   Gameplay.where.not(player: self).average(:score)
  # end
end
