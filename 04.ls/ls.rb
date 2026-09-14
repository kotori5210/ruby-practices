# frozen_string_literal: true

files = Dir.glob('*').sort
max_length = files.map(&:length).max

columns = [files.size, 3].min
columns = 1 if columns.zero?

rows = (files.size.to_f / columns).ceil

rows.times do |r|
  columns.times do |c|
    index = r + (c * rows)
    file = files[index]
    print file.ljust(max_length + 2) if file
  end
  puts
end

