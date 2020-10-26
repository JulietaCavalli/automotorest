class CreateVenta < ActiveRecord::Migration[6.0]
  def change
    create_table :venta do |t|
      t.string :matricula
      t.string :ci

      t.timestamps
    end
  end
end
