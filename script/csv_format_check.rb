require 'csv'

error = false
program_csv_path = "../program.csv"

if !File.exist?(program_csv_path)
  puts "[Error] #{program_csv_path} does not exist."
  exit
end

uids = []
order_nums = []

csv_data = CSV.read(program_csv_path, encoding: 'BOM|utf-8', headers: true)
csv_data.each do |data|
  # 列数の足りているかチェック
  unless data[11]
    error = true
    puts "[Error] csv row has too few columns #{data['id']}:#{data['name']}"
  end
  # 列数が多すぎないかチェック
  if data[12]
    error = true
    puts "[Error] csv row has too many columns #{data['id']}:#{data['name']}"
  end
  # type(企画の種類)の値が正しいかチェック
  unless ['0', '1', '2'].include?(data['type'])
    error = true
    puts "[Error] type column must have 0, 1 or 2 #{data['id']}:#{data['name']}"
  end
  # uidがユニークなIDになっているかチェック
  if uids.include?(data['uid'])
    error = true
    puts "[Error] uid is not unique #{data['id']}:#{data['name']}"
  else
    uids.push data['uid']
  end
  # orderがユニークになっているかチェック
  if order_nums.include?(data['order'].to_i)
    error = true
    puts "[Error] order is not unique #{data['id']}:#{data['name']}"
  else
    order_nums.push data['order'].to_i
  end
end

# orderが連番になっていることをチェック
unless order_nums.all? {|num| num >= 0} && order_nums.length == (order_nums.max + 1)
  error = true
  puts "[Error] order numbers must be serial"
end

if error
  puts "file check ended with error."
else
  puts "file check successfully ended."
end
