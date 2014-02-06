class FixProjectRepoModel < ActiveRecord::Migration
  def change
    remove_index :repositories, [:project_id, :slug]
    remove_column :repositories, :project_id

    create_table :project_repositories do |t|
      t.references :project
      t.references :repository

      t.index [:project_id]
      t.index [:repository_id]
    end
  end
end
