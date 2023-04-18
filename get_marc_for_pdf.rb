require 'fileutils'

# get the source directory and target directory from the command-line arguments
target_directory = ARGV[0]
source_directory = ARGV[1]


# create an array to store the PDF filenames
isbns = []

# loop through each file in the source directory
Dir.foreach(target_directory) do |filename|
  # check if the file is a PDF
  if filename =~ /\.pdf$/i
    # grab the isbn13 from the filename
    isbns << filename[0,13]
  end
end

# loop through each PDF filename in the array
isbns.each do |isbn|

  # construct the source and target file paths
  marc_ext = '.mrc'
  source_file_path = File.join(source_directory, isbn + marc_ext)
  target_file_path = File.join(target_directory, isbn + marc_ext)

  alt_ext = '.xml'
  alt_source_file_path = File.join(source_directory, isbn + alt_ext)
  alt_target_file_path = File.join(target_directory, isbn + alt_ext)


  # check if the source file exists
  if File.exist?(source_file_path)
    # copy the file to the target directory
    FileUtils.copy_file(source_file_path, target_file_path)
    #puts "Copied #{isbn}#{marc_ext} to #{target_directory}"
  elsif File.exist?(alt_source_file_path)
    FileUtils.copy_file(alt_source_file_path, alt_target_file_path)
    #puts "Copied #{isbn}${alt_ext} to #{target_directory}"
  else
    puts "#{isbn} has no match in #{source_directory}"
  end
end
