class AddColumnsToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :age, :integer
    add_column :users, :genres_preferred, :string
    add_column :users, :ratings_preferred, :integer
    add_column :users, :era_preferred, :string
    add_column :users, :language_preferred, :string
  end
end
