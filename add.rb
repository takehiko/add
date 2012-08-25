#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

# Array & Decanomial Drawer
#   by takehikom (http://d.hatena.ne.jp/takehikom/)

module Add
  class Manager
    # http://www.imagemagick.org/Usage/color_basics/#color_conflicts
    # http://en.wikipedia.org/wiki/X11_color_names
    COLOR_TABLE = ["Red", "Green", "Pink", "Gold", "Blue",
                   "Purple", "#CCC", "Brown", "Navy", "Goldenrod"]
    COLOR_TABLE.unshift(COLOR_TABLE[-1])

    def initialize(h)
      @h = h
      @command = []
      @box_a = []
    end

    def colorname(n)
      COLOR_TABLE[n % 10]
    end

    def num_to_array(n)
      # num_to_array(3) #=> 3
      # num_to_array("1-10") #=> [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
      # num_to_array("10-1") #=> [10, 9, 8, 7, 6, 5, 4, 3, 2, 1]
      a = []
      if /(\d+)-(\d+)/ =~ n.to_s
        num_from, num_to = $1.to_i, $2.to_i
        if num_from > num_to
          return ((num_to)..(num_from)).to_a.reverse
        else
          return ((num_from)..(num_to)).to_a
        end
      end
      [n.to_i]
    end

    def initialize_image
      row_a = num_to_array(@h[:row])
      col_a = num_to_array(@h[:col])
      @h[:dot_period] = @h[:dot_side] + @h[:dot_margin] +
        (@h[:grp_strokewidth] + @h[:grp_padding]) * 2

      x = 0  # do not delete
      y = @h[:set_margin]
      row_a.each do |row|
        if row <= 0
          die "#{row}: invalid number for row"
        end
        x = @h[:set_margin]
        col_a.each do |col|
          if col <= 0
            die "#{col}: invalid number for column"
          end
          param = {
            :row => row,
            :col => col,
            :trans_x => x,
            :trans_y => y
          }
          [:dot_fill, :dot_stroke].each do |k|
            case @h[k]
            when :default, :by_longer
              param[k] = colorname([row, col].max)
            when :by_row
              param[k] = colorname(row)
            when :by_col, :by_column
              param[k] = colorname(col)
            end
          end
          if @h[:dot_shape] == :ring || @h[:dot_shape] == :box
            if !param.key?(:dot_stroke) && (!@h.key?(:dot_stroke) || @h[:dot_stroke] == :none)
              param[:dot_stroke] = param[:dot_fill] || @h[:dot_fill]
            end
            param[:dot_fill] = :none
            param[:dot_strokewidth] = @h[:dot_side] * 0.1 unless @h.key?(:dot_strokewidth)
            param[:dot_shape] = (@h[:dot_shape] == :ring) ? :circle : :square
          elsif @h[:dot_shape] == :rectangle
            @h[:dot_shape] = :square
          end
          @box_a << param
          x += @h[:dot_period] * col - @h[:dot_margin] + @h[:geo_margin]
          x += @h[:grp_margin] * 2
        end
        y += @h[:dot_period] * row - @h[:dot_margin] + @h[:geo_margin]
        y += @h[:grp_margin] * 2
      end
      image_width = x - @h[:geo_margin] + @h[:set_margin]
      image_height = y - @h[:geo_margin] + @h[:set_margin]

      " -size #{image_width}x#{image_height} xc:#{@h[:image_bg]}"
    end

    def create
      file1 = @h[:output_filename] || "add.png"
      file2 = file1.sub(/\./, "_temp.")
      @command.each_with_index do |com, i|
        sys_com = "convert #{i == 0 ? '' : file1} #{com} #{@h[:convert_parameter]} #{file2}"
        puts sys_com
        system sys_com
        if !test(?f, file2)
          puts "#{file2} not found"
          exit
        end
        sys_com = "mv #{file2} #{file1}"
        puts sys_com
        system sys_com
      end
    end

    def start
      @command << initialize_image
      @box_a.each do |box|
        box.each_key do |key|
          @h[key] = box[key]
        end
        @command << Add::Drawer::Geo.new(@h).to_command
      end
      create
    end
  end

  module Drawer
    class Geo
      def initialize(h)
        @h = h
      end

      def to_command
        command = ""

        if @h[:dot_stroke] != :none
          command += " -strokewidth #{@h[:dot_strokewidth]}"
        end

        # http://www.imagemagick.org/Usage/draw/
        command += " -draw \""

        trans_x = @h[:trans_x] || @h[:set_margin] || 0
        trans_y = @h[:trans_y] || @h[:set_margin] || 0
        command += "translate #{trans_x} #{trans_y}"
        command += " fill #{@h[:dot_fill]} stroke #{@h[:dot_stroke]}"

        if @h[:dot_shape] == :circle
          @h[:col].times do |j|
            @h[:row].times do |i|
              x_o = @h[:dot_side] * 0.5 + @h[:dot_period] * j
              x_o += @h[:grp_margin] + @h[:grp_strokewidth] + @h[:grp_padding]
              y_o = @h[:dot_side] * 0.5 + @h[:dot_period] * i
              y_o += @h[:grp_margin] + @h[:grp_strokewidth] + @h[:grp_padding]
              r = @h[:dot_side] * 0.5
              if @h[:dot_stroke] != :none && !@h[:dot_stroke_unite]
                r -= @h[:dot_strokewidth] * 0.5
              end
              x_to = x_o + r
              y_to = y_o
              command += " circle #{x_o},#{y_o} #{x_to},#{y_to}"
            end
          end
        elsif @h[:dot_shape] == :square
          @h[:col].times do |j|
            @h[:row].times do |i|
              x_1 = @h[:dot_margin] * 0.5 + @h[:dot_period] * j
              x_1 += @h[:grp_margin] + @h[:grp_strokewidth] + @h[:grp_padding]
              y_1 = @h[:dot_margin] * 0.5 + @h[:dot_period] * i
              y_1 += @h[:grp_margin] + @h[:grp_strokewidth] + @h[:grp_padding]
              x_2 = x_1 + @h[:dot_side]
              y_2 = y_1 + @h[:dot_side]
              if @h[:dot_stroke] != :none && !@h[:dot_stroke_unite]
                swh = @h[:dot_strokewidth] * 0.5
                x_1 += swh
                y_1 += swh
                x_2 -= swh
                y_2 -= swh
              end
              command += " rectangle #{x_1},#{y_1} #{x_2},#{y_2}"
            end
          end
        end

        if !@h[:grp_area].empty?
          command += " fill none stroke #{@h[:grp_stroke]}"

          col_a = []
          case @h[:grp_area]
          when /left/
            col_a << 0
          when /right/
            col_a << @h[:col] - 1
          when /col/
            col_a += (0...@h[:col]).to_a
          end
          col_a.each do |c|
            x_1 = @h[:grp_strokewidth] * 0.5 + @h[:dot_period] * c + @h[:grp_margin]
            y_1 = @h[:grp_strokewidth] * 0.5
            x_2 = x_1 + @h[:dot_side] + @h[:grp_strokewidth]  + @h[:grp_padding] * 2
            y_2 = y_1 + @h[:dot_period] * @h[:row] + @h[:grp_strokewidth] - @h[:grp_padding] * 2 - @h[:dot_margin] + @h[:grp_margin] * 2
            command += " rectangle #{x_1},#{y_1} #{x_2},#{y_2}"
          end

          row_a = []
          case @h[:grp_area]
          when /top/
            row_a << 0
          when /bot/
            row_a << @h[:row] - 1
          when /row/
            row_a += (0...@h[:row]).to_a
          end
          row_a.each do |r|
            x_1 = @h[:grp_strokewidth] * 0.5
            y_1 = @h[:grp_strokewidth] * 0.5 + @h[:dot_period] * r + @h[:grp_margin]
            x_2 = x_1 + @h[:dot_period] * @h[:col] + @h[:grp_strokewidth] - @h[:grp_padding] * 2 - @h[:dot_margin] + @h[:grp_margin] * 2
            y_2 = y_1 + @h[:dot_side] + @h[:grp_strokewidth] + @h[:grp_padding] * 2
            command += " rectangle #{x_1},#{y_1} #{x_2},#{y_2}"
          end
        end

        command += "\""

        command
      end
    end
  end

  module Parameter
    def default
      {
        :row => "1-10",            # 行数
        :col => "1-10",            # 列数
        :dot_side => 20,           # 「1個」の1辺の長さ
        :dot_shape => :circle,     # 「1個」の形状
                                   #   :circle（塗りつぶす円）
                                   #   :ring（塗りつぶさない円）
                                   #   :square（塗りつぶす正方形）
                                   #   :box（塗りつぶさない正方形）
                                   #   :rectangle（:squareと同じ; 廃止予定）
        :dot_fill => :default,     # 「1個」の塗りつぶし色
                                   #   文字列（色名）
                                   #   :none（塗りつぶさない）
                                   #   :default（長辺+テーブル）
                                   #   :by_longer（長辺+テーブル）
                                   #   :by_row（行数+テーブル）
                                   #   :by_col（列数+テーブル）
        :dot_stroke => :none,      # 「1個」のストローク色．値は:dot_fillと同じ
        # :dot_strokewidth => 1,   # 「1個」のストローク太さ
        :dot_stroke_unite => true, # 隣接する各ストロークを合体させるならtrue
        :dot_margin => 0,          # 「1個」の間の余白(幅・高さ共通)
        :geo_margin => 5,          # 「一つのアレイ図」の間の余白(幅・高さ共通)
        :set_margin => 2,          # 全体図の余白(幅・高さ共通)
#        :unit_draw => false,       # 「一つ分の大きさ」描画の有無
#        :unit_color => :black,     # 「一つ分の大きさ」のストローク色
#        :unit_strokewidth => 0,    # 「一つ分の大きさ」のストローク幅
        :image_bg => :white,       # 画像の背景色
        :convert_parameter => "",  # convertコマンド実行時のパラメータ
                                   # 出力ファイル名の前に置かれる
        :output_filename => "add.png", # 出力ファイル名
        :grp_area => "",           # 「グルーピング」の描画対象
                                   #   "row"（各行）
                                   #   "col"（各列）
                                   #   "row+col"（各行各列）
                                   #   "top"（最上段）
                                   #   "bot"（最下段）
                                   #   "left"（最左列）
                                   #   "right"（最右列）
        :grp_stroke => :none,      # 「グルーピング」のストローク色．値は:dot_fillと同じ
        :grp_strokewidth => 0,     # 「グルーピング」のストローク太さ
        :grp_padding => 0,         # 「グルーピング」の内部余白(幅・高さ共通)
        :grp_margin => 0,          # 「グルーピング」の外部余白(幅・高さ共通)
      }
    end

    module_function :default
  end
end

if __FILE__ == $0
  h = Add::Parameter.default
  h[:row] = 3
  h[:col] = 4
  h[:dot_fill] = "blue"
  h[:dot_shape] = :ring
  Add::Manager.new(h).start

  if false # trueにすれば実行する
    [:ring, :box].each do |shape|
      [true, false].each do |opt_unite|
        h = Add::Parameter.default
        h[:row] = 3
        h[:col] = 4
        h[:dot_fill] = "blue"
        h[:dot_shape] = shape
        h[:dot_stroke_unite] = opt_unite
        h[:output_filename] = "array-#{h[:row]}x#{h[:col]}-#{shape}-#{opt_unite ? '' : 'un'}united.png"
        Add::Manager.new(h).start
      end
    end
  end

  if false # trueにすれば実行する
    shape = :ring
    ["none", "top", "bot", "left", "right", "row", "col", "row+col"].each do |grp_area|
      h = Add::Parameter.default
      h[:row] = 3
      h[:col] = 4
      h[:dot_fill] = "blue"
      h[:dot_shape] = shape
      h[:dot_stroke_unite] = false
      h[:grp_area] = grp_area
      h[:grp_stroke] = "black"
      h[:grp_strokewidth] = h[:grp_padding] = h[:dot_side] * 0.1
      h[:dot_margin] = h[:grp_padding] * 2
      h[:grp_margin] = h[:grp_padding] * 3
      h[:output_filename] = "array-#{h[:row]}x#{h[:col]}-#{shape}-#{grp_area}.png"
      Add::Manager.new(h).start
    end
  end

  if false # trueにすれば実行する（時間がかかる）
    [:ring, :box, :circle, :square].each do |shape|
      h = Add::Parameter.default
      h[:row] = "1-10"
      h[:col] = "1-10"
      h[:dot_shape] = shape
      h[:output_filename] = "decanomial-#{shape}.png"
      Add::Manager.new(h).start
    end
  end
end
