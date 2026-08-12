# frozen_string_literal: true

# 1. 引数をパース
score_strings = ARGV[0].split(',')

# メンター指摘①: eachによる配列追加ではなく、mapを使ってスマートに配列を生成
scores = score_strings.map { |s| s == 'X' ? 10 : s.to_i }

frames = []
frame = []

# 2. スコアをフレームに分割
scores.each do |score|
  if frames.size < 9
    frame << score
    if frame.size == 2 || frame[0] == 10
      frames << frame
      frame = []
    end
  else
    frame << score
  end
end
frames << frame unless frame.empty?

total_score = 0
shot_index = 0

# 3. 各フレームのスコアを計算
frames.each_with_index do |current_frame, index|
  if index < 9
    if current_frame[0] == 10 # ストライク
      total_score += 10 + scores[shot_index + 1] + scores[shot_index + 2]
      shot_index += 1
    elsif current_frame.sum == 10 # スペア
      total_score += 10 + scores[shot_index + 2]
      shot_index += 2
    else # オープンフレーム
      total_score += current_frame.sum
      shot_index += 2
    end
  else
    # メンター指摘②: 第10フレームの合計を while ループではなく sum メソッドでスマートに一発計算！
    total_score += current_frame.sum
  end
end

puts total_score
