require 'csv'

error = false
program_csv_path = "../program.csv"

if !File.exist?(program_csv_path)
  puts "[Error] #{program_csv_path} does not exist."
  exit
end

csv_data = CSV.read(program_csv_path, encoding: 'utf-8', headers: true)
csv_data.each do |data|
  if data['path'] != ""
    if data['type'] == "1"
      if !File.exist?("../images/permanent/#{data['path']}.#{data['ext']}")
        error = true
        puts "[Error] image file does not exits in p. Title: #{data['title']} (#{data['path']}.#{data['ext']})"
      end
    elsif data['type'] == "2"
      if !File.exist?("../images/guerrilla/#{data['path']}.#{data['ext']}")
        error = true
        puts "[Error] image file does not exits in g. Title: #{data['title']} (#{data['path']}.#{data['ext']})"
      end
    else
      if !File.exist?("../images/#{data['start_day']}/#{data['path']}.#{data['ext']}")
        error = true
        puts "[Error] image file does not exits in m. Title: #{data['title']} (#{data['start_day']}/#{data['path']}.#{data['ext']})"
      end
    end
    if !File.exist?("../images/0000/#{data['path']}.#{data['ext']}")
      error = true
      puts "[Error] image file does not exits. Title: #{data['title']} (#{data['path']}.#{data['ext']})"
    end
  end
end

if error
  puts "file check ended with error."
else
  puts "file check successfully ended."
end
