require 'csv'
require 'uri'
require 'open-uri'

error = false
program_csv_path = "../program.csv"

if !File.exist?(program_csv_path)
  puts "[Error] #{program_csv_path} does not exist."
  exit
end

csv_data = CSV.read(program_csv_path, encoding: 'BOM|utf-8', headers: true)
csv_data.each do |data|
  if !data['image'].nil? && data['image'] != ""
    puts "Downloading... #{data['uid']}"
    uri = URI.encode("https://ryosai2021.kumano-ryo.com/#{data['image']}")
    begin
      open(uri) do |file|
        img_filename = "../images/#{data['uid']}#{File.extname data['image']}"
        open(img_filename, "w+b") do |out|
          out.write(file.read)
        end
      end
    rescue => e
      error = true
      puts "[Error] image file could not download. Title: #{data['name']} (#{data['image']}}): #{e}"
    end
  end
end

if error
  puts "file check ended with error."
else
  puts "file check successfully ended."
end
