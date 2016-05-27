class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :description
      t.references :user, index: true
      t.boolean :done

      t.timestamps null: false
    end
  end
end
