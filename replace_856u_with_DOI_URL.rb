require 'rexml/document'
require 'rexml/xpath'
include REXML

DOI_BASE_URL = 'https://doi.org/'
NAMESPACE = { "marc" => "http://www.loc.gov/MARC21/slim" }

def get_doi_url(record)
  XPath.each(record, "marc:datafield[@tag='024']", NAMESPACE) do |df|
    code2 = XPath.first(df, "marc:subfield[@code='2']", NAMESPACE)&.text&.strip&.downcase
    codea = XPath.first(df, "marc:subfield[@code='a']", NAMESPACE)&.text&.strip
    if code2 == "doi" && codea
      return DOI_BASE_URL + codea
    end
  end
  nil
end

def update_856u(record, doi_url)
  XPath.each(record, "marc:datafield[@tag='856']", NAMESPACE) do |df|
    XPath.each(df, "marc:subfield[@code='u']", NAMESPACE) do |sf|
      sf.children.clear    # Remove any existing text/whitespace
      sf.text = doi_url    # Set DOI URL cleanly
    end
  end
end

# Remove whitespace-only text nodes recursively (for pretty output)
def remove_whitespace_nodes(node)
  node.each do |child|
    if child.is_a?(REXML::Text) && child.to_s =~ /\A\s*\Z/
      node.delete(child)
    elsif child.respond_to?(:each)
      remove_whitespace_nodes(child)
    end
  end
end

folder = ARGV[0]
unless folder && Dir.exist?(folder)
  puts "Usage: ruby replace_doi.rb /path/to/folder"
  exit(1)
end

Dir.glob("#{folder}/*.xml").each do |filepath|
  file = File.read(filepath)
  doc = Document.new(file)
  record = XPath.first(doc, "//marc:record", NAMESPACE)
  next unless record

  if (doi_url = get_doi_url(record))
    update_856u(record, doi_url)
    remove_whitespace_nodes(doc)
    File.open(filepath, "w") { |f| doc.write(f, -1) }  # -1 means compact, no indent
    puts "Updated: #{filepath}"
  else
    puts "No DOI found in: #{filepath}"
  end
end