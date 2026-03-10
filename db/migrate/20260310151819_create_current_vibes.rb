class CreateCurrentVibes < ActiveRecord::Migration[8.1]
  def change
    create_table :current_vibes do |t|
      t.timestamps
    end
  end
end
