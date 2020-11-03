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
require 'test_helper'

class PropietarioTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
