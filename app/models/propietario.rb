# == Schema Information
#
# Table name: propietarios
#
#  id         :bigint           not null, primary key
#  nombre     :string
#  apellido   :string
#  ci         :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Propietario < ApplicationRecord
end
