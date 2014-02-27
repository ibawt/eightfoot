class CreateLastEdits < ActiveRecord::Migration
  def change
    create_table :last_edits do |t|
      t.references :user
      t.timestamps
    end
  end
end
