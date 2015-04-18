class AddOwnerToRapidfireQuestionGroups < ActiveRecord::Migration
  def change
    add_column :rapidfire_question_groups, :owner, :integer
  end
end
