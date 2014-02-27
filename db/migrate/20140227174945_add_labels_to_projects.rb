class AddLabelsToProjects < ActiveRecord::Migration
  def change
    create_table :labels do |t|
      t.string :name
      t.timestamps
    end

    create_table :project_labels do |t|
      t.references :label
      t.references :project
      t.timestamps
    end
  end
end
