# frozen_string_literal: true

# 1. 引数から投球ごとのスコア配列（文字列）を作成
param_scores = ARGV[0].split(',')

# 2. メンター指摘①: mapを使ってスコア文字列を扱いやすい形式（投球ごとの文字・数値）の配列に一発変換
# ストライクは "X"、それ以外は整数(to_i)に変換
scores = param_scores.map { |score| score == 'X' ? 'X' : score.to_i }

# 3. 投球ごとのスコアをフレームごとに割り振るための配列
frames = []
current_frame = []

# 各投球をフレームに配分するループ
scores.each do |score|
  current_frame << score

  # 第1〜9フレームの終了条件（ストライク、または2投終えたとき）
  if frames.size < 9
    if score == 'X' || current_frame.size == 2
      frames << current_frame
      current_frame = []
    end
  elsif scores.last == score
    # 第10フレームは最後にまとめて追加
    frames << current_frame
  end
end

total_score = 0

# 4. スコアの集計処理
frames.each_with_index do |frame, index|
  if index < 9
    if frame.include?('X') # ストライクの場合
      # 次の2投分のスコアを足す（"X"は10点として計算）
      next_two_shots = scores[(scores.index(frame.first) + 1)..(scores.index(frame.first) + 2)]
      bonus = next_two_shots.map { |s| s == 'X' ? 10 : s }.sum
      total_score += 10 + bonus
    elsif frame.sum == 10 # スペアの場合
      # 次の1投分のスコアを足す
      next_shot = scores[scores.index(frame.last) + 1]
      bonus = next_shot == 'X' ? 10 : next_shot
      total_score += 10 + bonus
    else # 通常フレームの場合
      total_score += frame.sum
    end
  else
    # メンター指摘②: 最終フレームの合計は while ループを使わず sum メソッドでスマートに計算！
    final_shots = frame.map { |s| s == 'X' ? 10 : s }
    total_score += final_shots.sum
  end
end

puts total_score
