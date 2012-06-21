#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

# "ruby 20120612.rb" makes all the images (PNG format) in the article:
# http://d.hatena.ne.jp/takehikom/20120612/1339436326

require "./add.rb"

def my_system(command)
  puts command
  system command
end

dot_margin = 3
set_margin = 6
dot_side = 30

## BEGIN TEST CODE
# exit
## END TEST CODE

a = [[3, 4], [3, 2], [2, 3], [3, 8], [3, 5], [3, 6], [3, 11]]
a.each do |row, col|
  h = Add::Parameter.default
  h[:row] = row
  h[:col] = col
  h[:dot_side] = dot_side
  h[:dot_fill] = "blue"
  h[:dot_shape] = :circle
  h[:dot_margin] = dot_margin
  h[:set_margin] = set_margin
  h[:output_filename] = "#{row}by#{col}.png"
  Add::Manager.new(h).start
end

x1 = y1 = set_margin + dot_side + dot_margin
x2 = x1 + 2 * dot_side + dot_margin + 1
y2 = y1 + dot_side + 1
command = "convert 3by4.png -draw \"fill white rectangle #{x1},#{y1} #{x2},#{y2}\" 3by4-girth.png"
# convert 3by4.png -draw "fill white rectangle 39,39 103,70" 3by4-girth.png
my_system command

x1 = y1 = set_margin + dot_side + dot_margin
x2 = x1 + 3 * dot_side + 2 * dot_margin + 1
y2 = y1 + 2 * dot_side + dot_margin + 1
command = "convert 3by4.png -draw \"fill white rectangle #{x1},#{y1} #{x2},#{y2}\" 3by4-dogleg.png"
my_system command
# convert 3by4.png -draw "fill white rectangle 39,39 136,103" 3by4-dogleg.png

x1 = set_margin + 4 * dot_side + 3 * dot_margin + 2
y1 = set_margin
x2 = x1 + dot_side + 1
y2 = y1 + 3 * dot_side + 2 * dot_margin + 1
command = "convert 3by6.png -draw \"fill white rectangle #{x1},#{y1} #{x2},#{y2}\" 3by4+3.png"
# convert 3by6.png -draw "fill white rectangle 137,6 168,103" 3by4+3.png
my_system command

x1 = set_margin + 3 * dot_side + 2 * dot_margin + 2
y1 = set_margin
x2 = x1 + dot_side + 1
y2 = y1 + 3 * dot_side + 2 * dot_margin + 1
command = "convert 3by6.png -draw \"fill white rectangle #{x1},#{y1} #{x2},#{y2}\" 3by3+3by2.png"
# convert 3by6.png -draw "fill white rectangle 104,6 135,103" 3by3+3by2.png
my_system command

rect = ""
[2, 5, 8].each do |i|
  x1 = set_margin + i * dot_side + (i - 1) * dot_margin + 2
  y1 = set_margin
  x2 = x1 + dot_side + 1
  y2 = y1 + 3 * dot_side + 2 * dot_margin + 1
  rect += " rectangle #{x1},#{y1} #{x2},#{y2}"
end
command = "convert 3by11.png -draw \"fill white #{rect}\" four3by2.png"
# convert 3by11.png -draw "fill white  rectangle 71,6 102,103 rectangle 170,6 201,103 rectangle 269,6 300,103" four3by2.png
my_system command

line = ""
1.upto(2) do |i|
  x1 = 0
  y1 = set_margin + i * dot_side + (i - 0.5) * dot_margin
  x2 = 2 * set_margin + 4 * dot_side + 3 * dot_margin
  y2 = y1
  line += " line #{x1},#{y1} #{x2},#{y2}"
end
line.strip!
command = "convert 3by4.png -stroke black -strokewidth 1 -draw \"#{line}\" 3by4-splitby4.png"
# convert 3by4.png -stroke black -strokewidth 1 -draw "line 0,37.5 141,37.5 line 0,70.5 141,70.5" 3by4-splitby4.png
my_system command

line = ""
1.upto(3) do |i|
  x1 = set_margin + i * dot_side + (i - 0.5) * dot_margin
  y1 = 0
  x2 = x1
  y2 = 2 * set_margin + 3 * dot_side + 2 * dot_margin
  line += " line #{x1},#{y1} #{x2},#{y2}"
end
line.strip!
command = "convert 3by4.png -stroke black -strokewidth 1 -draw \"#{line}\" 3by4-splitby3.png"
# convert 3by4.png -stroke black -strokewidth 1 -draw "line 37.5,0 37.5,108 line 70.5,0 70.5,108 line 103.5,0 103.5,108" 3by4-splitby3.png
my_system command

row = 4
col = 6
dot_margin = 0
h = Add::Parameter.default
h[:row] = row
h[:col] = col
h[:dot_side] = dot_side
h[:dot_fill] = :none
h[:dot_stroke] = "blue"
h[:dot_strokewidth] = 2
h[:dot_shape] = :box
h[:dot_margin] = dot_margin
h[:set_margin] = set_margin
h[:output_filename] = "#{row}by#{col}.png"
Add::Manager.new(h).start

rect = ""
x1 = set_margin + dot_side + 2
y1 = set_margin - 1
x2 = x1 + dot_side - 4
y2 = y1 + 4 * dot_side + 3 * dot_margin + 1
rect += " rectangle #{x1},#{y1} #{x2},#{y2}"
x1 = set_margin - 1
y1 = set_margin + 3 * dot_side + 2 * dot_margin + 2
x2 = x1 + 6 * dot_side + 5 * dot_margin + 2
y2 = y1 + dot_side
rect += " rectangle #{x1},#{y1} #{x2},#{y2}"
line = ""
x2 = set_margin - 0.5 * dot_margin
y2 = set_margin + 4 * dot_side + 3 * dot_margin 
x1 = x2
y1 = y2 - dot_side / 3
x3 = x2 + dot_side + 0.5 * dot_margin
y3 = y2
x4 = x3
y4 = y1
0.upto(5) do |i|
  if i != 1
    line += " polyline #{x1},#{y1} #{x2},#{y2} #{x3},#{y3} #{x4},#{y4}"
  end
  x1 += dot_side + dot_margin
  x2 += dot_side + dot_margin
  x3 += dot_side + dot_margin
  x4 += dot_side + dot_margin
end
line.strip!
command = "convert 4by6.png -draw \"fill white #{rect}\" -stroke blue -strokewidth 2 -fill none -draw \"#{line}\" 3by4-kakewari.png"
# convert 4by6.png -draw "fill white  rectangle 38,5 64,126 rectangle 5,98 187,128" -stroke blue -strokewidth 2 -fill none -draw "polyline 6.0,116 6.0,126 36.0,126 36.0,116 polyline 66.0,116 66.0,126 96.0,126 96.0,116 polyline 96.0,116 96.0,126 126.0,126 126.0,116 polyline 126.0,116 126.0,126 156.0,126 156.0,116 polyline 156.0,116 156.0,126 186.0,126 186.0,116" 3by4-kakewari.png
my_system command

dot_margin = 0
geo_margin = 2
set_margin = 6
dot_side = 4
h = Add::Parameter.default
h[:row] = "1-10"
h[:col] = "1-10"
h[:dot_shape] = :square
h[:dot_side] = dot_side
h[:dot_margin] = dot_margin
h[:geo_margin] = geo_margin
h[:set_margin] = set_margin
h[:output_filename] = "55by55.png"
Add::Manager.new(h).start

=begin
- 3by4
>||
●●●●
●●●●
●●●●
||<

- 3by4-girth
>||
●●●●
●　　●
●●●●
||<

-  3by4-dogleg
>||
●●●●
●
●
||<

- 3by4-splitby3
>||
●｜●｜●｜●
●｜●｜●｜●
●｜●｜●｜●
||<

- 3by4-splitby4
>||
●●●●
――――
●●●●
――――
●●●●
||<

- 3by2
>||
●●
●●
●●
||<

- 2by3
>||
●●●
●●●
||<

- four3by2
>||
●●　●●　●●　●●
●●　●●　●●　●●
●●　●●　●●　●●
||<

- 3by8
>||
●●●●●●●●
●●●●●●●●
●●●●●●●●
||<

- 3by5
>||
●●●●●
●●●●●
●●●●●
||<

- 3by4+3
>||
●●●●　●
●●●●　●
●●●●　●
||<

- 3by3+3by2
>||
●●●　●●
●●●　●●
●●●　●●
||<

- 3by4-kakewari
●　●●●●
●　●●●●
●　●●●●
＿　＿＿＿＿

- 55by55
=end
