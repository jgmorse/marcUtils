require 'fileutils'

# get the source directory and target directory from the command-line arguments
target_directory = ARGV[0]
source_directory = ARGV[1]

# create an array to store the PDF filenames
isbns = []

# loop through each PDF in the target directory
Dir.foreach(target_directory) do |filename|
  # check if the file is a PDF
  if filename =~ /\.pdf$/i
    # grab the isbn13 from the filename (assumes first 13 chars are ISBN)
    isbns << filename[0,13]
  end
end

# loop through each PDF filename in the array
isbns.each do |isbn|
  marc_ext = '.mrc'
  source_file_path = File.join(source_directory, isbn + marc_ext)
  target_file_path = File.join(target_directory, isbn + marc_ext)

  alt_ext = '.xml'
  alt_source_file_path = File.join(source_directory, isbn + alt_ext)
  alt_target_file_path = File.join(target_directory, isbn + alt_ext)

  if File.exist?(source_file_path)
    FileUtils.copy_file(source_file_path, target_file_path)
    # puts "Copied #{isbn}#{marc_ext} to #{target_directory}"
  elsif File.exist?(alt_source_file_path)
    FileUtils.copy_file(alt_source_file_path, alt_target_file_path)
    # puts "Copied #{isbn}#{alt_ext} to #{target_directory}"
  else
    # Search contents of ALL files in source_directory for ISBN
    matched = false
    Dir.glob(File.join(source_directory, '*')).each do |file|
      next unless File.file?(file)
      ext = File.extname(file).downcase
      # Only consider .mrc or .xml files for content search
      next unless ext == '.mrc' || ext == '.xml'
      if File.read(file).include?(isbn)
        # Found a file containing the ISBN, copy and rename:
        # Keep the original extension (.mrc or .xml)
        new_target = File.join(target_directory, "#{isbn}#{ext}")
        FileUtils.copy_file(file, new_target)
        puts "Copied and renamed file containing ISBN to #{new_target}"
        matched = true
        break # stop after first match
      end
    end
    puts "#{isbn} has no match in #{source_directory}" unless matched
  end
end