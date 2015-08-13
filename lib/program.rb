require_relative '../config/environment'
# require 'pry'

class AsciiGif
  attr_accessor :gif

  def initialize(url, loops=2, color=true)
    @gif = MiniMagick::Image.open(url)
    @loops = loops
    @color = color
  end

  def to_ascii
    @gif.frames.each_with_index do |frame, idx|
      frame.write("images/frame#{idx}.jpg")
    end
    print_gif
  end

  def print_gif
    num_frames = gif.frames.count
    frames = num_frames.times.map {|f| "images/frame#{f}.jpg"}

    frames.cycle.first(num_frames * @loops).each do |frame|
       a = AsciiArt.new(frame)
       puts "\e[H\e[2J"
       puts a.to_ascii_art(color: @color, width: 70)
       sleep 0.03
    end
    delete_frames
  end

  def delete_frames
    FileUtils.rm_rf(Dir.glob('images/*'))
  end
end

gif = AsciiGif.new('http://media.giphy.com/media/26BkN2Uh9wImWDXLa/giphy.gif',2)
gif.to_ascii
#
# num_frames = gif.frames.count
# frames = num_frames.times.map {|f| "images/frame#{f}.jpg"}
#
# frames.cycle.first(num_frames * 3).each do |frame|
#    a = AsciiArt.new(frame)
#    puts a.to_ascii_art(color: true)
#   #  (color: true)
#
#   #  exit false if gets.chomp.empty?
# end
# #
# #  AsciiArt.new('images/frame1.jpg')
# #  puts (arr.to_ascii_art)
# #
# # gif.frames.each_with_index do |frame, idx|
# #   frame.write("images/frame#{idx}.jpg")
# # end
#
# # gif.frames[0].write("images/frame1.jpg")
# # file.write(gif.frames[0].write("images/frame1.jpg"))
