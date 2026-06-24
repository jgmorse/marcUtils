# get the identifiers file and source directory from the command-line arguments
identifiers_file = ARGV[0]
source_directory = ARGV[1]

# Read identifiers from file, one per line, stripping whitespace and blank lines
identifiers = File.readlines(identifiers_file)
                  .map(&:strip)
                  .reject(&:empty?)

# Loop through each identifier
identifiers.each do |isbn|
  marc_ext = '.mrc'
  source_file_path = File.join(source_directory, isbn + marc_ext)

  alt_ext = '.xml'
  alt_source_file_path = File.join(source_directory, isbn + alt_ext)

  if File.exist?(source_file_path)
    puts source_file_path
  elsif File.exist?(alt_source_file_path)
    puts alt_source_file_path
  else
    # Search contents of ALL .mrc or .xml files in source_directory for the identifier
    matched = false
    Dir.glob(File.join(source_directory, '*')).each do |file|
      next unless File.file?(file)
      ext = File.extname(file).downcase
      next unless ext == '.mrc' || ext == '.xml'
      if File.read(file).include?(isbn)
        puts file
        matched = true
        break # stop after first match
      end
    end
    puts "NO MATCH: #{isbn}" unless matched
  end
end