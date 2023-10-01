# Method for marking sliced pieces of cake
def cut(ar_cake, x, y, width, height)
  (y...(y + height)).each do |i|
    (x...(x + width)).each { |j| ar_cake[i][j] = "*"}
  end
  ar_cake
end

# Transform array(which contains strings) into string form
def arr_to_string(rectangle_form)
  result = ""
  rectangle_form.each do |i|
    i.each { |j| result += j}
    result += "\n"
  end
  result
end

# This method return hash with indexes of top left available spot(piece) in cake
def find_first_not_cut_spot(ar_cake)
  (0...ar_cake.size).each do |i|
    (0...ar_cake[i].size).each { |j| return {y:i, x:j} if ar_cake[i][j] != "*"} # '*' in cake means this peaces is already cut
  end
  nil
end

# This method check if cutting some slice is possible
def slice_valid(ar_cake, x, y, width, height)
  return nil if (x + width) > ar_cake[0].size or (y + height) > ar_cake.size # check if slice is not out of cake ranges(form)
  # Literally `slicing` the cake array to get slice array
  slice = ar_cake.slice(y, height) # rows
  slice = slice.map { |i| i.slice(x, width)} # columns
  str_slice = arr_to_string(slice)
  # You can uncomment code section below to see process of finding solution in console
  # puts "Trying to cut the slice:"
  # puts str_slice
  if str_slice.include? "*" or str_slice.count("o") != 1
    # puts "Invalid slice (have already cut pieces or amount of raisins is not equal to 1)"
    return nil
  end
  str_slice
end

# Recursive method which do all the main work
def searching(ar_cake, slices, size)
  # You can uncomment code section below to see process of finding solution in console
  # puts "Current slices:\n#{slices}"
  # puts "Current state(form) of cake:"
  # puts arr_to_string(ar_cake)
  position = find_first_not_cut_spot(ar_cake)
  # puts "Position of top left available spot:#{position}"
  return slices if position == nil # If its impossible to find that position, the solution already found (it is saved in slices array)
  # According to the task requirements, wee need to cut the widest slice first,
  # so we start with maximum possible slice width
  # and minimum slice height
  slice_width = size
  loop do
    break if slice_width == 0
    slice_height = 0
    loop do
      break if slice_height == size
      slice_height += 1
      next unless slice_width * slice_height == size # all slices must have equal sizes
      slice = slice_valid(ar_cake, position[:x], position[:y], slice_width, slice_height)
      next if slice == nil
      # Important, because we will be using recursion, even if some slices is valid, the other iterations may not lead to solution
      # so, we must to COPY (CLONE) our slices array and cake array, and not just create a reference (like new_arr = arr)
      # This way, it will be possible to track back and find other possible ways of cutting the cake
      new_slices = slices.dup # copying the slice array
      new_slices.push(slice)
      # Copying the 2d array cake (it's form)
      new_ar_cake = []
      i=0
      loop do
        break if i == ar_cake.size
        new_ar_cake[i] = ar_cake[i].dup
        i += 1
      end
      # It is possible to copy multi-dimensional arrays without loops (commented line below)
      # new_ar_cake = Marshal.load(Marshal.dump(ar_cake)) more universal way
      new_ar_cake = cut(new_ar_cake, position[:x], position[:y], slice_width, slice_height)
      res = searching(new_ar_cake, new_slices, size) # using recursion
      return res if res.size > 0 # returning slice array
    end
    slice_width -= 1
  end
  # You can uncomment line below to see process of finding solution in console
  # puts "Impossible to continue cutting, returning back to previous state(form) of cake"
  [] # returning empty array if solution wasn't found
end

# Checking if cake have the form if rectangle and the amount of raisins is correct
def cake_valid?(cake)
  return false if cake.count("o") <=1 or cake.count("o") >= 10
  array_cake = cake.split("\n")
  cake_width = array_cake[0].size
  array_cake.each do |i|
    unless i.size == cake_width
      return false
    end
  end
  true
end

# If user didn't write anything in input, program will take cake from code
# You can put your own example here
#cake = ".o.\n..o\n..o"
#cake = "........\n..o.....\n...o....\n........"
#cake = ".o......\n......o.\n....o...\n..o....."
cake = ".o.o....\n........\n....o...\n........\n.....o..\n........"
unless ARGV.empty?
  puts "Taking cake from input."
  cake.clear
  ARGV.each { |i| cake += i + "\n"}
end
puts "cake =\n#{cake}"
puts "P.S. If your cake not looking like you wanted, remember to use spacebars between cake \"layers(levels)\""
raisins = cake.count("o")
puts "Amount of raisins:#{raisins}"
unless cake_valid?(cake)
  puts "Sorry, your cake doesn't have rectangle form or amount of raisins is out of range (1;10)"
  exit
end
puts "Trying to cut the cake..."
# We transform the cake from String to 2d Array because it will give us more convenient way to 'go through' cake
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
