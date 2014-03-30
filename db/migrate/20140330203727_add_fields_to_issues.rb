class AddFieldsToIssues < ActiveRecord::Migration
  def change
    add_reference :issues, :user, index: true
    add_column :issues, :assignee, :string
    add_column :issues, :source, :string
    add_column :issues, :comments_count, :int
    add_column :issues, :title, :string
  end
end
