# frozen_string_literal: true

score_strings = ARGV[0].split(',')
scores = score_strings.map { |s| s == 'X' ? 10 : s.to_i }

frames = []
frame = []

scores.each do |score|
  if frames.size >= 9
    frame << score
    next
  end

  frame << score
  if frame.size == 2 || frame[0] == 10
    frames << frame
    frame = []
  end
end

frames << frame unless frame.empty?

total_score = 0
shot_index = 0

frames.each_with_index do |current_frame, index|
  if index >= 9
    total_score += current_frame.sum
    next
  end

  if current_frame[0] == 10
    total_score += 10 + scores[shot_index + 1] + scores[shot_index + 2]
    shot_index += 1
  elsif current_frame.sum == 10
    total_score += 10 + scores[shot_index + 2]
    shot_index += 2
  else
    total_score += current_frame.sum
    shot_index += 2
  end
end

puts total_score
