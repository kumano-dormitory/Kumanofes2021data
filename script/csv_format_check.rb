require 'csv'

error = false
program_csv_path = "../program.csv"

if !File.exist?(program_csv_path)
  puts "[Error] #{program_csv_path} does not exist."
  exit
end

csv_data = CSV.read(program_csv_path, encoding: 'utf-8', headers: true)
csv_data.each do |data|
  unless data[4]
    error = true
    puts "[Error] csv row has too few columns #{data['id']}:#{data['name']}"
  end
  if data[5]
    error = true
    puts "[Error] csv row has too many columns #{data['id']}:#{data['name']}"
  end
end

if error
  puts "file check ended with error."
else
  puts "file check successfully ended."
end
