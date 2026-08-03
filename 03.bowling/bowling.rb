# frozen_string_literal: true

scores = ARGV[0].split(',')

shots = []
scores.each do |score|
  shots << if score == 'X'
             10
           else
             score.to_i
           end
end

total_score = 0
shot_index = 0

9.times do
  if shots[shot_index] == 10
    total_score += 10 + shots[shot_index + 1] + shots[shot_index + 2]
    shot_index += 1
  elsif shots[shot_index] + shots[shot_index + 1] == 10
    total_score += 10 + shots[shot_index + 2]
    shot_index += 2
  else
    total_score += shots[shot_index] + shots[shot_index + 1]
    shot_index += 2
  end
end

while shot_index < shots.size
  total_score += shots[shot_index]
  shot_index += 1
end

puts total_score
