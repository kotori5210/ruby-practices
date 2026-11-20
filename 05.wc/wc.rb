# frozen_string_literal: true

require 'optparse'

def main
  options = parse_options
  files = ARGV

  if files.empty?
    count_standard_input(options)
  else
    count_files(files, options)
  end
end

def parse_options
  options = {}
  opt = OptionParser.new
  opt.on('-l') { options[:lines] = true }
  opt.on('-w') { options[:words] = true }
  opt.on('-c') { options[:bytes] = true }
  opt.parse!(ARGV)

  if options.empty?
    options[:lines] = true
    options[:words] = true
    options[:bytes] = true
  end
  options
end

def count_standard_input(options)
  input_text = $stdin.read
  print_counted_data(input_text, options)
end

def count_files(files, options)
  total_lines = 0
  total_words = 0
  total_bytes = 0

  files.each do |file|
    unless File.exist?(file)
      warn "wc: #{file}: No such file or directory"
      next
    end

    content = File.read(file)
    lines, words, bytes = print_counted_data(content, options, file)

    total_lines += lines
    total_words += words
    total_bytes += bytes
  end

  puts format_output(total_lines, total_words, total_bytes, options, 'total') if files.size > 1
end

def print_counted_data(text, options, label = '')
  lines, words, bytes = count_elements(text)
  puts format_output(lines, words, bytes, options, label)
  [lines, words, bytes]
end

def count_elements(text)
  lines_count = text.count("\n")
  words_count = text.split(/[ \t\n]+/).reject(&:empty?).size
  bytes_count = text.bytesize
  [lines_count, words_count, bytes_count]
end

def format_output(lines, words, bytes, options, label = '')
  result = []
  result << format_column(lines) if options[:lines]
  result << format_column(words) if options[:words]
  result << format_column(bytes) if options[:bytes]
  result << " #{label}" unless label.empty?
  result.join
end

def format_column(value)
  value.to_s.rjust(8)
end

main
