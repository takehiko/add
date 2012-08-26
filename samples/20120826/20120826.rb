#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

def require_ancestor(s)
  d = File.dirname(File.expand_path(__FILE__))
  3.times do |i|
    f = "#{d}/#{s}"
    if test(?f, f)
      puts "require \"#{f}\"" if $DEBUG
      require f
      return true
    end
    d = File.dirname(d)
  end
  return false
end
require_ancestor "add.rb"
# require "./add.rb"

["none", "row", "row+col"].each do |grp_area|
  h = Add::Parameter.default
  h[:row] = 3
  h[:col] = 4
  h[:dot_fill] = "white"
  h[:dot_stroke] = "black"
  h[:dot_shape] = :ring
  h[:dot_side] = 30
  h[:dot_strokewidth] = 2.5
  h[:dot_stroke_unite] = false
  h[:grp_area] = grp_area
  h[:grp_stroke] = "grey35"
  h[:grp_strokewidth] = h[:grp_padding] = 2
  h[:dot_margin] = h[:grp_padding] * 2
  h[:grp_margin] = h[:grp_padding] * 4
  h[:output_filename] = "array-#{h[:row]}x#{h[:col]}-#{grp_area}.png"
  Add::Manager.new(h).start
end
