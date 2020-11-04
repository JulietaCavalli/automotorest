class RemoveRequeridoFromVehiculos < ActiveRecord::Migration[6.0]
  def change
    remove_column :vehiculos, :requerido, :boolean
  end
end
