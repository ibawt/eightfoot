class AddColNamesToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :headers, :text
  end
end
