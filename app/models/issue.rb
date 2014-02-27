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
end
