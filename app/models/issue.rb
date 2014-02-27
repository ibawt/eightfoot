class Issue < ActiveRecord::Base
  belongs_to :project
  belongs_to :repository

  def width
    w = super
    w.nil? ? 1 : w
  end

  def height
    h = super
    h.nil? ? 1 : h
  end

  def row
    r = super
    return 1 if r == 0
    r.nil? ? 1 : r
  end

  def col
    c = super
    return 1 if c == 0
    c.nil? ? 1 : c
  end

end
