#!/usr/bin/env ruby

require 'date'
require 'optparse'

options = {}
opt = OptionParser.new
opt.on('-y YEAR', Integer) { |v| options[:year] = v }
opt.on('-m MONTH', Integer) { |v| options[:month] = v }
opt.parse!(ARGV)

year = options[:year] || Date.today.year
month = options[:month] || Date.today.month

header = "#{month}月 #{year}".center(20)
puts header
puts '日 月 火 水 木 金 土'

first_date = Date.new(year, month, 1)
last_date = Date.new(year, month, -1)

print '   ' * first_date.wday

(first_date..last_date).each do |date|
  print date.day.to_s.rjust(2) + ' '
  puts if date.saturday? && date != last_date
end
puts
