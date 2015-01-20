Digits = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]

def is_time?(text)
  if text.include?("-->")
    return true
  end
  return false
end

def first_is_numeric?(text)
  if Digits.include?(text[0])
    return true
  end
  return false
end

def padded(number)
  if number / 10 == 0
    return "0#{number}"
  end
  return "#{number}"
end

def get_hours(text, iteration=2)
  if iteration == 1
    return text.slice(0..1).to_i
  end
  return text.slice(17..18).to_i
end
def get_minutes(text, iteration=2)
  if iteration == 1
    return text.slice(3..4).to_i
  end
  return text.slice(20..21).to_i
end
def get_seconds(text, iteration=2)
  if iteration == 1
    return text.slice(6..7).to_i
  end
  return text.slice(23..24).to_i
end
def get_ms(text, iteration=2)
  if iteration == 1
    return text.slice(9..11)
  end
  return text.slice(26..28)
end
def get_middle(text)
  return text.slice(12..16)
end

def get_final_time(line, seconds)
  hrs1 = get_hours(line, 1)
  mins1 = get_minutes(line, 1)
  secs1 = get_seconds(line, 1)
  ms1 = get_ms(line, 1)
  middle = get_middle(line)
  hrs2 = get_hours(line)
  mins2 = get_minutes(line)
  secs2 = get_seconds(line)
  ms2 = get_ms(line)

  #adds seconds
  secs1 += seconds
  secs2 += seconds

  #checks to see if times are accurate
  mins_to_add1 = 0
  mins_to_add2 = 0
  #logic flow could be better
  if secs1 == 60
    mins_to_add1 = 1
    secs1 = 0
  elsif secs1 > 60
    mins_to_add1 = 1
    secs1 = secs1 % 60
  end
  if secs2 == 60
    mins_to_add2 = 1
    secs2 = 0
  elsif secs2 > 60
    mins_to_add2 = 1
    secs2 = secs2 % 60
  end

  #takes care of possible minutes to add
  mins1 += mins_to_add1
  mins2 += mins_to_add2

  #takes care of possible hours to add
  hours_to_add1 = 0
  hours_to_add2 = 0
  if mins1 == 60
    hours_to_add1 = 1
    mins1 = 0
  end
  if mins2 == 60
    hours_to_add2 = 1
    mins2 = 0
  end

  hrs1 += hours_to_add1
  hrs2 += hours_to_add2

  #formats the times
  secs1 = padded(secs1)
  secs2 = padded(secs2)
  mins1 = padded(mins1)
  mins2 = padded(mins2)
  hrs1 = padded(hrs1)
  hrs2 = padded(hrs2)

  final_time =  "#{hrs1}:#{mins1}:#{secs1},#{ms1}#{middle}#{hrs2}:#{mins2}:#{secs2},#{ms2}"
  return final_time
end

puts("Subtitle Shifter Initialized!\n ")

#Enter name of subtitle file
puts("Please enter name of file: ")
file_name = gets.chomp
if !File.exist?(file_name)
   puts ("ERROR! File Not Found!")
   puts("Exiting Program...")
   exit
end
puts("File found!\n ")

#Enter how many seconds to shift
puts("How many seconds would you like to shift?")
#only from 1 to 59, doesn't shift backwards and shifts whole file. only a portion in the future
seconds = gets.chomp.to_i

#better functionality in future?
target = open("shifted.srt", 'w')
lines = File.readlines(file_name)
lines.each do |line|
  if is_time?(line)
    target.write(get_final_time(line, seconds))
    target.write("\n")
  elsif first_is_numeric?(line)
    target.write(line)
  else
    target.write(line)
  end
end
target.close
puts("Shifting Complete!\n ")
