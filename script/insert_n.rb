
while true
  puts "Enter string"
  input = gets

  input.strip!
  input.sub!(/ー/, '|')
  input.each_char { |c| print c, '\n' }
  puts ""
end