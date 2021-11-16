require 'csv'

error = false

program_csv_path = "../program.csv"
output_file_path = "./for_android.txt"

if !File.exist?(program_csv_path)
  puts "[Error] #{program_csv_path} does not exist."
  exit
end

current_day = "1127"
tmp_str = ""
tmp_str_write_f = false

tmp_permanent = ""
tmp_gerira = ""

path_hash = {}
id_hash = {}
url_hash = {}

i = 0
File.open(output_file_path, "w+") do |f|
  f.write("\nlistOf(\n")
  csv_data = CSV.read(program_csv_path, encoding: 'utf-8', headers: true)
  csv_data.each_with_index do |data, id|

    if (data['type'] == "0") then
      if (current_day != data['start_day']) then
        f.write(tmp_str)
        # f.write("\n-------------------------------------------\n\n-----------------------------------------------")
        f.write("\n),\nlistOf(\n")
        current_day = data['start_day']
        tmp_str = ""
      end
      if tmp_str == "" then
        tmp_str = "listOf(\"#{data['id']}\",\"#{data['type']}\",\"#{data['title']}\",\"#{data['details']}\",\"#{data['start_day'][0..1]}/#{data['start_day'][2..3]} #{data['start_at']}\",\"#{data['end_day'][0..1]}/#{data['end_day'][2..3]} #{data['end_at']}\",\"#{data['place']}\",\"#{data['path']}\",\"#{data['order']}\")"
      else
        tmp_str = "#{tmp_str},\nlistOf(\"#{data['id']}\",\"#{data['type']}\",\"#{data['title']}\",\"#{data['details']}\",\"#{data['start_day'][0..1]}/#{data['start_day'][2..3]} #{data['start_at']}\",\"#{data['end_day'][0..1]}/#{data['end_day'][2..3]} #{data['end_at']}\",\"#{data['place']}\",\"#{data['path']}\",\"#{data['order']}\")"
      end
      tmp_str_write_f = true
      url_hash["#{data['path']}"] = "https://kumano-dormitory.github.io/ryosai2020/events/#{data['id']}.html"
      i = i + 1
    elsif (data['type'] == "1") then
      if tmp_str_write_f then
          tmp_str_write_f = false
          f.write(tmp_str)
      end
      if tmp_permanent == ""
        tmp_permanent = "listOf(\"#{data['id']}\",\"#{data['type']}\",\"#{data['title']}\",\"#{data['details']}\",\"\",\"\",\"#{data['place']}\",\"#{data['path']}\",\"#{data['order']}\")"
      else
        tmp_permanent = "#{tmp_permanent},\nlistOf(\"#{data['id']}\",\"#{data['type']}\",\"#{data['title']}\",\"#{data['details']}\",\"\",\"\",\"#{data['place']}\",\"#{data['path']}\",\"#{data['order']}\")"
      end
      url_hash["#{data['path']}"] = "https://kumano-dormitory.github.io/ryosai2020/events/#{data['id']}.html"
      i = i + 1
    elsif (data['type'] == "2") then
      if tmp_gerira == ""
        tmp_gerira = "listOf(\"#{data['id']}\",\"#{data['type']}\",\"#{data['title']}\",\"#{data['details']}\",\"\",\"\",\"#{data['place']}\",\"#{data['path']}\",\"#{data['order']}\")"
      else
        tmp_gerira = "#{tmp_gerira},\nlistOf(\"#{data['id']}\",\"#{data['type']}\",\"#{data['title']}\",\"#{data['details']}\",\"\",\"\",\"#{data['place']}\",\"#{data['path']}\",\"#{data['order']}\")"
      end
      url_hash["#{data['path']}"] = "https://kumano-dormitory.github.io/ryosai2020/events/#{data['id']}.html"
      i = i + 1
    end

    # パスの集合に追加する
    if (!data['path'].nil? && data['path'].strip != "") then
      path_hash[data['path']] = "    \"#{data['path']}\" -> R.drawable.#{data['path']}\n"
    end
    # viewIdの集合に追加する
    id_hash[data['id']] = "       R.id.#{data['id']} -> \"#{data['id']}\"\n"
  end
  f.write("\n),\nlistOf(\n")
  f.write(tmp_permanent)
  f.write("\n),\nlistOf(\n")
  f.write(tmp_gerira)
  f.write("\n)")
  f.write("\n\n-----------------------------------------------------\n\n-------------------------------------------\n\n")


  f.write("\nfor Resource Id match function\n")
  f.write("return when(path) {\n")
  path_hash.each do |path, code|
    f.write(code)
  end
  f.write("    else -> R.drawable.ic_launcher_background\n}\n")

  f.write("\n\n\nfor View Id match function\n")
  f.write("return when(id) {\n")
  id_hash.each do |id, code|
    f.write(code)
  end
  f.write("    else -> 1\n}\n")

  f.write("\n\n\n For URL Path match function\n")
  f.write("return when (path) {\n")
  url_hash.each do |path, url|
    f.write("    \"#{path}\" -> \"#{url}\"\n")
  end
  f.write("    else -> \"https://kumano-dormitory.github.io/ryosai2020/\"\n}\n")

  if error then
    puts "Creating json file ended with error."
  else
    puts "Creating json file successfully ended."
  end

end
