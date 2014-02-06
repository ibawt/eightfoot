class CreateRepositories < ActiveRecord::Migration
  def up
    create_table :repositories do |t|
      t.references :project
      t.string :slug
      t.timestamps
      t.index [:project_id, :slug]
    end
  end

  def down
    drop_table :repositories
  end
end
