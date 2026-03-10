class AddColumnsToVibes < ActiveRecord::Migration[8.1]
  def change
    add_column :current_vibes, :time_available, :integer
    add_column :current_vibes, :energy_level, :string
    add_column :current_vibes, :mood_now, :string
    add_column :current_vibes, :mood_desired, :string
    add_reference :current_vibes, :user, foreign_key: true
  end
end
