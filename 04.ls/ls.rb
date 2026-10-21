# frozen_string_literal: true

require 'etc'

# メソッド1: ファイル名の一覧を取得する
def fetch_files
  Dir.glob('*').sort
end

# メソッド2: 権限の数字を `-rw-r--r--` のような文字列に変換する
def convert_mode_to_permissions(stat)
  type = stat.directory? ? 'd' : '-'
  chars = { '7' => 'rwx', '6' => 'rw-', '5' => 'r-x', '4' => 'r--', '3' => '-wx', '2' => '-w-', '1' => '--x', '0' => '---' }
  mode_octal = stat.mode.to_s(8)[-3..]
  permissions = mode_octal.chars.map { |digit| chars[digit] }.join
  "#{type}#{permissions}"
end

# メソッド3: 詳細情報を縦に並べて表示する（完全一致版）
def display_long_files(files)
  stats = files.map { |file| [file, File.stat(file)] }.to_h

  # Linuxの1024バイト単位に合わせるため、512バイト単位のブロック数の合計を2で割る
  total_blocks = stats.values.map(&:blocks).sum / 2
  puts "total #{total_blocks}"

  max_nlink = stats.values.map { |s| s.nlink.to_s.length }.max
  max_owner = stats.values.map { |s| Etc.getpwuid(s.uid).name.length }.max
  max_group = stats.values.map { |s| Etc.getgrgid(s.gid).name.length }.max
  max_size  = stats.values.map { |s| s.size.to_s.length }.max

  files.each do |file|
    stat = stats[file]
    perms = convert_mode_to_permissions(stat)
    nlink = stat.nlink.to_s.rjust(max_nlink)
    owner = Etc.getpwuid(stat.uid).name.ljust(max_owner)
    group = Etc.getgrgid(stat.gid).name.ljust(max_group)
    size  = stat.size.to_s.rjust(max_size)
    mtime = stat.mtime.strftime('%b %e %R')

    # 本物とスペースの数を完全に一致させるフォーマット
    puts "#{perms} #{nlink} #{owner} #{group} #{size} #{mtime} #{file}"
  end
end

# メソッド4: 複数列 of レイアウトを構築して画面に出力する（通常の横並び）
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

# メイン処理の実行
files_list = fetch_files

# オプションの条件分岐
if ARGV.include?('-l')
  display_long_files(files_list)
else
  display_files(files_list)
end
