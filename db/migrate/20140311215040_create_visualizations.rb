class CreateVisualizations < ActiveRecord::Migration
  def change
    create_table :visualizations do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.string :markup_type, null: false, default: 'html'
      t.text :markup
      t.boolean :enabled, default: true
      t.timestamps
    end
  end
end
