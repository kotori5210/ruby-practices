# frozen_string_literal: true

require 'etc'
require 'optparse'

def fetch_files(options)
  # -a オプションがあればドットファイルを含め、なければ除外する
  flags = options[:a] ? File::FNM_DOTMATCH : 0
  files = Dir.glob('*', flags).sort

  # -r オプションがあれば配列を逆順（降順）にする
  files.reverse! if options[:r]
  files
end

def convert_mode_to_permissions(stat)
  type = stat.directory? ? 'd' : '-'
  chars = { '7' => 'rwx', '6' => 'rw-', '5' => 'r-x', '4' => 'r--', '3' => '-wx', '2' => '-w-', '1' => '--x', '0' => '---' }
  mode_octal = stat.mode.to_s(8)[-3..]
  permissions = mode_octal.chars.map { |digit| chars[digit] }.join
  "#{type}#{permissions}"
end

def display_long_files(files)
  return if files.empty?

  stats = files.map { |file| [file, File.stat(file)] }.to_h

  display_total_blocks(stats)
  max_lengths = calculate_max_lengths(stats)
  files.each { |file| puts build_long_format_row(file, stats[file], max_lengths) }
end

def display_total_blocks(stats)
  total_blocks = stats.values.map(&:blocks).sum / 2
  puts "total #{total_blocks}"
end

def calculate_max_lengths(stats)
  {
    nlink: stats.values.map { |s| s.nlink.to_s.length }.max,
    owner: stats.values.map { |s| Etc.getpwuid(s.uid).name.length }.max,
    group: stats.values.map { |s| Etc.getgrgid(s.gid).name.length }.max,
    size: stats.values.map { |s| s.size.to_s.length }.max
  }
end

def build_long_format_row(file, stat, max_lengths)
  [
    convert_mode_to_permissions(stat),
    stat.nlink.to_s.rjust(max_lengths[:nlink]),
    Etc.getpwuid(stat.uid).name.ljust(max_lengths[:owner]),
    Etc.getgrgid(stat.gid).name.ljust(max_lengths[:group]),
    stat.size.to_s.rjust(max_lengths[:size]),
    stat.mtime.strftime('%b %e %R'),
    file
  ].join(' ')
end

def display_files(files)
  return if files.empty?

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
end

options = {}
OptionParser.new do |opts|
  opts.on('-a') { |v| options[:a] = v }
  opts.on('-r') { |v| options[:r] = v }
  opts.on('-l') { |v| options[:l] = v }
end.parse!

files_list = fetch_files(options)

if options[:l]
  display_long_files(files_list)
else
  display_files(files_list)
end
