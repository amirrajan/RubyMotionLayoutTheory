module Geometry
  def left
    x
  end

  def right
    x + w
  end

  def top
    y
  end

  def bottom
    y + h
  end

  def cg_rect
    CGRectMake(x, y, w, h)
  end
end

class Hash
  include Geometry

  def x
    self[:x]
  end

  def y
    self[:y]
  end

  def w
    self[:w]
  end

  def h
    self[:h]
  end

  def to_h
    Hash.new.merge self
  end

  def to_tuple
    [x, y, w, h]
  end
end

class Array
  include Geometry

  def x
    self[0]
  end

  def y
    self[1]
  end

  def w
    self[2]
  end

  def h
    self[3]
  end

  def merge opts
    to_h.merge opts
  end

  def to_h
    Hash.new.merge x: x, y: y, w: w, h: h
  end

  def to_tuple
    [x, y, w, h]
  end

  def merge opts
    to_h.merge opts
  end
end

class LayoutTheory
  def self.font_size_ratio
    if iPadEdgeToEdge?
      1.10
    elsif iPad?
      1.10
    elsif iPhoneEdgeToEdge?
      1
    elsif iPhone5?
      0.85
    else # iPhone?
      1
    end
  end

  def self.font_size_xl
    18 * font_size_ratio
  end

  def self.font_size_lg
    16 * font_size_ratio
  end

  def self.font_size_med
    14 * font_size_ratio
  end

  def self.font_size_sm
    13 * font_size_ratio
  end

  def self.font_size
    14 * font_size_ratio
  end

  def self.logical_rect
    [0, 0,
     UIScreen.mainScreen.bounds.size.width,
     UIScreen.mainScreen.bounds.size.height]
  end

  def self.safe_area
    if iPadPro11Inch?
      return [logical_rect.x + 128,
              logical_rect.y + 24,
              logical_rect.w - 256,
              logical_rect.h - 44]
    elsif iPadPro12Inch?
      return [logical_rect.x + 160,
              logical_rect.y + 24,
              logical_rect.w - 320,
              logical_rect.h - 44]
    elsif iPad?
      return [logical_rect.x + 120,
              logical_rect.y + 24,
              logical_rect.w - 240,
              logical_rect.h - 32]
    elsif iPadAir?
      return [logical_rect.x + 128,
              logical_rect.y + 24,
              logical_rect.w - 256,
              logical_rect.h - 32]
    elsif iPadPro?
      return [logical_rect.x + 128,
              logical_rect.y + 24,
              logical_rect.w - 256,
              logical_rect.h - 32]
    elsif iPhoneEdgeToEdge?
      return [logical_rect.x + 16,
              logical_rect.y + 40,
              logical_rect.w - 32,
              logical_rect.h - 64]
    else
      return [logical_rect.x + 8,
              logical_rect.y + 24,
              logical_rect.w - 16,
              logical_rect.h - 32]
    end
  end

  def self.row_count
    24
  end

  def self.col_count
    12
  end

  def self.gutter_height
    4
  end

  def self.gutter_width
    4
  end

  def self.cell_height
    (safe_area.h - (gutter_height * (row_count - 1))) / row_count
  end

  def self.cell_width
    (safe_area.w - (gutter_width * (col_count - 1))) / col_count
  end

  def self.rect_defaults
    {
      row: nil,
      col: nil,
      h: 1,
      w: 1,
      dx: 0,
      dy: 0
    }
  end

  def self.rect opts
    opts = rect_defaults.merge opts
    result = safe_area
    if opts[:row] && opts[:col] && opts[:w] && opts[:h]
      col_rect   = rect col: opts[:col], w: opts[:w]
      row_rect   = rect row: opts[:row], h: opts[:h]
      result = result.merge x: col_rect.x,
                            y: row_rect.y,
                            w: col_rect.w,
                            h: row_rect.h
    elsif opts[:row] && !opts[:col]
      left_col  = rect col: 0
      right_col = rect col: (col_count - 1)
      top_y = safe_area.y +
              gutter_height * opts[:row] +
              (opts[:row] * cell_height)

      h = (gutter_height * (opts[:h] - 1)) +
          (opts[:h] * cell_height)

      result = result.merge y: top_y,
                            h: h

    elsif !opts[:row] && opts[:col]
      left_x = safe_area.x  +
               gutter_width * opts[:col] +
               (opts[:col]  * cell_width)

      w = cell_width * opts[:w] + gutter_width * (opts[:w] - 1)

      result = result.merge x: left_x,
                            w: w
    else
      raise "LayoutTheory::rect unable to process opts #{opts}."
    end

    result[:x] += opts[:dx]
    result[:y] += opts[:dy]

    result
  end

  def self.iPhone11?
    UIScreen.mainScreen.bounds.size.height == 812
  end

  def self.iPhone11Pro?
    UIScreen.mainScreen.bounds.size.height == 896
  end

  def self.iPhoneEdgeToEdge?
    iPhone11Pro? || iPhone11?
  end

  def self.iPad?
    UIScreen.mainScreen.bounds.size.height == 1080
  end

  def self.iPadAir?
    UIScreen.mainScreen.bounds.size.height == 1112
  end

  def self.iPadPro?
    UIScreen.mainScreen.bounds.size.height == 1024
  end

  def self.iPadPro12Inch?
    UIScreen.mainScreen.bounds.size.height == 1366
  end

  def self.iPadPro11Inch?
    UIScreen.mainScreen.bounds.size.height == 1194
  end

  def self.iPhone5?
    UIScreen.mainScreen.bounds.size.height == 568
  end

  def self.iPadEdgeToEdge?
    iPadPro12Inch? || iPadPro11Inch?
  end
end
