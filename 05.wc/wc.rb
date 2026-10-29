# frozen_string_literal: true

require 'optparse'

def count_elements(text)
  lines_count = text.count("\n")
  words_count = text.split(/[ \t\n]+/).reject(&:empty?).size
  bytes_count = text.bytesize
  [lines_count, words_count, bytes_count]
end

def format_output(lines, words, bytes, options, label = '')
  result = []
  result << lines.to_s.rjust(8) if options[:lines]
  result << words.to_s.rjust(8) if options[:words]
  result << bytes.to_s.rjust(8) if options[:bytes]
  result << " #{label}" unless label.empty?
  result.join
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

def process_standard_input(options)
  input_text = $stdin.read
  lines, words, bytes = count_elements(input_text)
  puts format_output(lines, words, bytes, options)
end

def process_files(files, options)
  total_lines = 0
  total_words = 0
  total_bytes = 0

  files.each do |file|
    unless File.exist?(file)
      warn "wc: #{file}: No such file or directory"
      next
    end

    content = File.read(file)
    lines, words, bytes = count_elements(content)
    puts format_output(lines, words, bytes, options, file)

    total_lines += lines
    total_words += words
    total_bytes += bytes
  end

  puts format_output(total_lines, total_words, total_bytes, options, 'total') if files.size > 1
end

def main
  options = parse_options
  files = ARGV

  if files.empty?
    process_standard_input(options)
  else
    process_files(files, options)
  end
end

main
