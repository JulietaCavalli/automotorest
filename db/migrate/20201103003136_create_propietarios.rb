class CreatePropietarios < ActiveRecord::Migration[6.0]
  def change
    create_table :propietarios do |t|
      t.string :nombre
      t.string :apellido
      t.string :ci

      t.timestamps
    end
  end
end
