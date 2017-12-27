class CreateBooks < ActiveRecord::Migration[5.1]
  def change
    create_table :books do |t|
      t.string :name
      t.string :description
      t.string :cover_url
      t.integer :author_id
      t.integer :user_id
      t.integer :rating
    end
  end
end
