class CreateRecommendations < ActiveRecord::Migration[8.1]
  def change
    create_table :recommendations do |t|
      t.timestamps
      t.integer :r_rating
      t.string :r_reasoning
      t.string :title
      t.string :description
      t.integer :year
      t.references  :current_vibe, foreign_key: true
    end
  end
end
