require 'nokogiri'

# Check if the file name is provided
if ARGV.empty?
  puts "Usage: ruby script.rb <file_name>"
  exit 1
end

file_name = ARGV[0]  # Get the file name from the command-line arguments

# Load the XML file
xml_doc = Nokogiri::XML(File.read(file_name))

# Define namespaces (needed because of the default namespaces in the XML document)
namespaces = { 
  'marc' => 'http://www.loc.gov/MARC21/slim' 
}

# Iterate over each record
xml_doc.xpath('//marc:record', namespaces).each do |record|
  # Grab the 035$a value
  datafield_035 = record.at_xpath('marc:datafield[@tag="035"]/marc:subfield[@code="a"]', namespaces)
  if datafield_035
    # Extract the portion after '(dli)'
    identifier = datafield_035.content[/\(dli\)(.*)/, 1]

    # Grab the 856$u subfield
    datafield_856 = record.at_xpath('marc:datafield[@tag="856"]/marc:subfield[@code="u"]', namespaces)
    if datafield_856 && identifier
      # Modify the URL as per requirement
      datafield_856.content = "https://hdl.handle.net/2027/#{identifier}"
    end
  end
end

# Output the modified XML to a file or stdout
puts xml_doc.to_xml
