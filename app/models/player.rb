class Player < ApplicationRecord
  has_many :gameplays
  after_initialize :init
  
  def init
    self.rating ||= 1000.00
  end
  
  def wins
    self.gameplays.where(score:10).count
  end
  
  def win_percentage
    self.gameplays.where(score:10).count.to_f / self.gameplays.count.to_f
  end
  
  def provisional?
    self.gameplays.count < 4
  end
  
  def close_games
    self.gameplays.where(score:9).count
  end
  
  def average_score
    Gameplay.where(player: self).average(:score).to_f.round(2)
  end
  
  def average_score_against
    in_games = Game.joins(:gameplays).where(gameplays: {player: self})
    # in_games = Gameplay.joins(:game).where(gameplays: {player: self})
    return Gameplay.where(game: in_games).where.not(player: self).average(:score).to_f.round(2)
  end
  
  def blownouts
    self.gameplays.where("score < ?", 4).count
  end
  
  def blowouts
    # TODO: fix this
    in_games = Game.joins(:gameplays).where(gameplays: {player: self})
    # in_games = Gameplay.joins(:game).where(gameplays: {player: self})
    other_scores = Gameplay.where(game: in_games).where.not(player: self).average(:score)
  end
end
