class CreateVehiculos < ActiveRecord::Migration[6.0]
  def change
    create_table :vehiculos do |t|
      t.string :matricula
      t.string :marca
      t.string :modelo
      t.integer :ano
      t.boolean :requerido
      t.integer :precio

      t.timestamps
    end
  end
end
