class Issue < ActiveRecord::Base
  belongs_to :project
  belongs_to :repository

  def width
    w = super
    return 1 if w == 0 or w.nil?
    w
  end

  def height
    h = super
    return 1 if h == 0 or h.nil?
    h
  end

  def row
    r = super
    return 1 if r == 0 or r.nil?
    r
  end

  def col
    c = super
    return 1 if c == 0 or c.nil?
    c
  end

end
