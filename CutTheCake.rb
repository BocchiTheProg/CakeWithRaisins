cake = ".o.\n..o\n...\n.oo\nooo\no.o" #You can put your own example here
puts "cake =\n#{cake}"
raisins = cake.count("o")
puts "Amount of raisins:#{raisins}"
array_cake = cake.split("\n")
is_rectangle = true
cake_height = array_cake.size
cake_width = array_cake[0].size
array_cake.each do |i|
  unless i.size == cake_width
    is_rectangle = false
    break
  end
end
if !is_rectangle or raisins <=1 or raisins >= 10
  puts "Sorry, your cake doesn't have rectangle form or amount of raisins is out of range (1;10)"
  exit
end
puts "You have a really nice cake ^._.^"
