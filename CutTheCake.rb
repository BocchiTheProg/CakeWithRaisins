def cut(ar_cake, x, y, width, height)
  (y...(y + height)).each do |i|
    (x...(x + width)).each { |j| ar_cake[i][j] = " "}
  end
  ar_cake
end

def arr_to_string(rectangle_form)
  result = ""
  rectangle_form.each do |i|
    i.each { |j| result += j}
    result += "\n"
  end
  result
end

def find_first_not_cut_spot(ar_cake)
  (0...ar_cake.size).each do |i|
    (0...ar_cake[i].size).each {|j| return {y:i, x:j} if ar_cake[i][j] != " "}
  end
  nil
end

def slice_valid(ar_cake, x, y, width, height)
  return nil if (x + width) > ar_cake[0].size or (y + height) > ar_cake.size
  slice = ar_cake.slice(y, height)
  slice = slice.map { |i| i.slice(x, width)}
  str_slice = arr_to_string(slice)
  return nil if str_slice.include? " "
  raisins = str_slice.count("o")
  return nil if raisins != 1
  str_slice
end

def searching(ar_cake, slices, size)
  position = find_first_not_cut_spot(ar_cake)
  return slices if position == nil
  slice_width = size
  loop do
    break if slice_width == 0
    slice_height = 0
    loop do
      break if slice_height == size
      slice_height += 1
      next unless slice_width * slice_height == size
      slice = slice_valid(ar_cake, position[:x], position[:y], slice_width, slice_height)
      next if slice == nil
      new_slices = slices.dup
      new_slices.push(slice)
      new_ar_cake = []
      i=0
      loop do
        break if i == ar_cake.size
        new_ar_cake[i] = ar_cake[i].dup
        i += 1
      end
      new_ar_cake = cut(new_ar_cake, position[:x], position[:y], slice_width, slice_height)
      res = searching(new_ar_cake, new_slices, size)
      return res if res.size > 0
    end
    slice_width -= 1
  end
  []
end

def cake_valid?(cake)
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

# You can put your own example here
#cake = ".o.\n..o\n..o"
#cake = "........\n..o.....\n...o....\n........"
#cake = ".o......\n......o.\n....o...\n..o....."
cake = ".o.o....\n........\n....o...\n........\n.....o..\n........"
puts "cake =\n#{cake}"
raisins = cake.count("o")
puts "Amount of raisins:#{raisins}"
unless cake_valid?(cake)
  puts "Sorry, your cake doesn't have rectangle form or amount of raisins is out of range (1;10)"
  exit
end
puts "Trying to cut the cake..."
array_cake = cake.split("\n")
array_cake = array_cake.map { |i| i.split("")}
slice_size = (array_cake.size * array_cake[0].size) / raisins
puts "Wanted size of slices: #{slice_size}"
slices = []
slices = searching(array_cake, slices, slice_size)
if slices.size == 0
  puts "Can`t cut the cake properly"
else
  puts "Result:"
  slices.each do |i|
    puts "\n" + i
  end
  puts "Your slices: #{slices}"
end
