#!/usr/bin/env ruby

require 'date'
require 'optparse'

# 1. コマンドライン引数の解析（デフォルトは現在の年・月）
options = {
  year: Date.today.year,
  month: Date.today.month
}

opt = OptionParser.new
opt.on('-y YEAR', Integer) { |v| options[:year] = v }
opt.on('-m MONTH', Integer) { |v| options[:month] = v }

begin
  opt.parse!(ARGV)
rescue OptionParser::InvalidArgument, OptionParser::MissingArgument
  puts "引数が不正です。"
  exit
end

year = options[:year]
month = options[:month]

# 2. 月のバリデーション（1〜12月以外はエラーにする）
unless (1..12).include?(month)
  puts "#{month} は無効な月です。1から12の間で指定してください。"
  exit
end

# 3. ヘッダーと曜日を出力
header = "#{month}月 #{year}".center(20)
puts header
puts "日 月 火 水 木 金 土"

# 4. 今月の「初日(1日)」と「月末日」のオブジェクトを作る
first_date = Date.new(year, month, 1)
last_date = Date.new(year, month, -1)

# 5. 最初の空白（インデント）を出力
print "   " * first_date.wday

# 6. ループ処理で数字を出力
(first_date..last_date).each do |date|
  print date.day.to_s.rjust(2) + " "
  puts if date.wday == 6 && date != last_date
end

puts
