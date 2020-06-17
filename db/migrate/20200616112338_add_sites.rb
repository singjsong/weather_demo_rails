class AddSites < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      dir.up do
        create_table(:sites) do |t|
          t.string :name, null: false, index: true
          t.string :billing_status, null: false, default: :unpaid, index: true
          t.boolean :weather_station_installed, null: false, default: false, index: true
          t.timestamps
        end
      end
      dir.down do
        drop_table(:sites)
      end
    end
  end
end
