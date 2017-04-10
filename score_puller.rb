require 'google_drive'
require 'json'

session = GoogleDrive::Session.from_config("config.json")

ws = session.spreadsheet_by_key("1-DiELUuBBxmamA6zo-d-RrUlWssqDyWXCrQPkEw7dOY").worksheets[0]

print ws[2,1]

scores = []
game = {}
(2..123).each do |y|
  game = {
    "number" => y-1,
    "players" => {
      "player1" => {
        "name" => ws[y,6],
        "score" => ws[y,7].to_i
      },
      "player2" => {
        "name" => ws[y,8],
        "score" => ws[y,9].to_i
      },
      "player3" => {
        "name" => ws[y,10],
        "score" => ws[y,11].to_i
      },
      "player4" => {
        "name" => ws[y,12],
        "score" => ws[y,13].to_i
      },
      "player5" => {
        "name" => ws[y,14],
        "score" => ws[y,15].to_i
      },
      "player6" => {
        "name" => ws[y,16],
        "score" => ws[y,17].to_i
      }
    }
  }
  
  scores << game
end

File.open("scores.json", "w") do |f|
  f.write(scores.to_json)
end
