# == Schema Information
#
# Table name: vehiculos
#
#  id         :bigint           not null, primary key
#  matricula  :string
#  marca      :string
#  modelo     :string
#  ano        :integer
#  requerido  :boolean
#  precio     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Vehiculo < ApplicationRecord
	validates :matricula, presence: true,  uniqueness: true
end
