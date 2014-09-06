class CreateDynamicSettings < ActiveRecord::Migration
  def change
    create_table :dynamic_settings do |t|
      t.string :ns, null: false
      t.string :name, null: false
      t.string :value

      t.timestamps
    end

    add_index :dynamic_settings, [:ns, :name], unique: true
  end
end