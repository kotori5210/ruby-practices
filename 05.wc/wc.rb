# frozen_string_literal: true

def parse_options
  option_args = ARGV.select { |arg| arg.start_with?('-') && arg != '-' }
  chars = option_args.join.chars
  { l: chars.include?('l'), w: chars.include?('w'), c: chars.include?('c') }
end

def count_data(text)
  {
    l: text.count("\n"),
    w: text.split(/[ \t\n\r]+/).reject(&:empty?).size,
    c: text.bytesize
  }
end

def build_output_array(counts, opts)
  show_all = !opts[:l] && !opts[:w] && !opts[:c]
  %i[l w c].map do |key|
    counts[key].to_s.rjust(8) if opts[key] || show_all
  end.compact
end

def format_output(counts, opts, label = nil)
  result = build_output_array(counts, opts)
  result << " #{label}" if label
  result.join
end

def process_file(file, opts)
  text = File.read(file)
  counts = count_data(text)
  puts format_output(counts, opts, file)
  counts
rescue Errno::ENOENT
  warn "wc: #{file}: No such file or directory"
  nil
end

def process_stdin(opts)
  text = $stdin.read
  counts = count_data(text)
  puts format_output(counts, opts)
end

def update_totals!(totals, counts)
  totals[:l] += counts[:l]
  totals[:w] += counts[:w]
  totals[:c] += counts[:c]
end

def aggregate_counts(files, opts)
  totals = { l: 0, w: 0, c: 0 }
  processed_count = 0

  files.each do |file|
    counts = process_file(file, opts)
    next unless counts

    update_totals!(totals, counts)
    processed_count += 1
  end

  puts format_output(totals, opts, 'total') if processed_count > 1
end

def main
  opts = parse_options
  files = ARGV.reject { |arg| arg.start_with?('-') && arg != '-' }

  if files.empty?
    process_stdin(opts)
  else
    aggregate_counts(files, opts)
  end
end

main
