class CreateIssuesLabels < ActiveRecord::Migration
  def change
    create_table :issue_labels do |t|
      t.references :issue, index: true
      t.references :label, index: true
    end
  end
end
