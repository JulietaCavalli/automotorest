# == Schema Information
#
# Table name: venta
#
#  id         :bigint           not null, primary key
#  matricula  :string
#  ci         :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Venta < ApplicationRecord
	validates :matricula, :ci, presence: true
end
