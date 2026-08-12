#!/usr/bin/env ruby

# 💡 デバッガ（debug.gem）を読み込む宣言を付け足します
require 'debug'

# ここに binding.break を書くと、プログラムがここで一時停止します！
binding.break

def fizzbuzz(num)
  if num % 15 == 0
    "FizzBuzz"
  elsif num % 3 == 0
    "Fizz"
  elsif num % 5 == 0
    "Buzz"
  else
    num.to_s
  end
end

(1..20).each do |i|
  puts fizzbuzz(i)
end
