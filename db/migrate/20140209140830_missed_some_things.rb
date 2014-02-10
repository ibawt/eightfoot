class MissedSomeThings < ActiveRecord::Migration
  def change
    change_table :issues do |t|
      t.remove :url
      t.remove :html_url
    end
  end
end
