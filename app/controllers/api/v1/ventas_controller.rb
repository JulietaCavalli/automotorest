class Api::V1::VentasController < ApplicationController
	def create
			datos = { data: {
									type: 'venta',
									relationship: {
										vehiculo: {
											type: 'vehiculo',
											id: '1'
										}
									},
									propietario: {
											type: 'persona',
											data: {
												attributes: {
													nombre: 'Juan 2',
													apellido: 'Pérez 2',
													cedula: '12345678'
												},
											}
									}
								}
							}
		# tengo que ver como me llegan los parametros
		# por ahora tengo el datos ese para ir probando
		j = JSON.parse(datos.to_json)
		ci = j['data']['propietario']['data']['attributes']['cedula']
		id = j['data']['relationship']['vehiculo']['id']
		vehiculo = Vehiculo.find(id)
		@venta = Venta.new(matricula: vehiculo.matricula, ci: ci )
		if @venta.save
			# @result = HTTParty.patch("https://.../api/rest/v1/vehiculos/:#{id}")
			#  hacer el destroy del vehiculo
			if @vehiculo.destroy
				render json: {data: {
												type:'venta',
												attributes: @venta,
												links: {
													self: "http://.../api/ventas/#{id}"
												}
											}
										}
			else
				render json: {
					error: {
						status: 404,
						title: 'No se pudo eliminar el vehiculo.'
				}
			}
			end
		else
			render json: {
									error: {
										status: 404,
										title: 'No se pudo completar la venta.'
								}
							}
		end
	end

	def index
	end

	private

	def ventas_params
		params.require(:venta).permit(:ci, :matricula)
	end
end