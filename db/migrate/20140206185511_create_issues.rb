class CreateIssues < ActiveRecord::Migration
  def change
    create_table :issues do |t|
      t.references :repository
      t.references :project
      t.string :url
      t.string :html_url
      t.integer :number
      t.string :state
      t.string :title
      t.text :body
      t.integer :comments
      t.timestamp :closed_at
      t.integer :position

      t.index [:repository_id]
      t.index [:project_id, :state, :position]

    end
  end
end
