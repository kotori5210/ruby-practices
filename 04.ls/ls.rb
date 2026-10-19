# frozen_string_literal: true

# メソッド1: ファイル名の一覧を取得する
def fetch_files
  if ARGV.include?('-a')
    Dir.glob('*', File::FNM_DOTMATCH).sort
  else
    Dir.glob('*').sort
  end
end

# メソッド2: 複数列のレイアウトを構築して画面に出力する
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

# メメイン処理の実行
files_list = fetch_files
display_files(files_list)
