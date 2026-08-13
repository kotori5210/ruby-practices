#!/usr/bin/env ruby

require 'date'
require 'optparse'

options = {}
opt = OptionParser.new
opt.on('-m VAL') { |v| options[:month] = v.to_i }
opt.on('-y VAL') { |v| options[:year] = v.to_i }
opt.parse!(ARGV)

year = options[:year] || Date.today.year
month = options[:month] || Date.today.month

puts "#{month}月 #{year}".center(20)
puts '日 月 火 水 木 金 土'

first_date = Date.new(year, month, 1)
last_date = Date.new(year, month, -1)

print ' ' * 3 * first_date.wday

(first_date..last_date).each do |date|
  print date.day.to_s.rjust(2) + ' '
  
  if date.saturday? || date == last_date
    puts
  end
end
