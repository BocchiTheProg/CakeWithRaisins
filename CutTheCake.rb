def cake_valid? (cake)
  false if cake.count("o") <=1 or cake.count("o") >= 10
  array_cake = cake.split("\n")
  cake_width = array_cake[0].size
  array_cake.each do |i|
    unless i.size == cake_width
      return false
    end
  end
  true
end

cake = ".o.\n..o\n..o" #You can put your own example here
puts "cake =\n#{cake}"
raisins = cake.count("o")
puts "Amount of raisins:#{raisins}"
unless cake_valid?(cake)
  puts "Sorry, your cake doesn't have rectangle form or amount of raisins is out of range (1;10)"
  exit
end
puts "You have a really nice cake ^._.^"
