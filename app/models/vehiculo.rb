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
	def testMethod
		{type: 'vehiculo', id: self.id, attributes: { matricula:self.matricula, marca: self.marca, modelo: self.modelo ,ano: self.ano, precio: self.precio}, links:{	self: $request.url + "/#{ self.id }"}}
	end
end
