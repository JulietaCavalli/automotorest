class Api::V1::VentasController < ApplicationController
	def create
		# los parametros que llegan son del estilo
		# { data: {
		# 						type: "venta",
		# 						relationship: {
		# 							vehiculo: {
		# 								type: "vehiculo",
		# 								id: "1"
		# 							}
		# 						},
		# 						propietario: {
		# 							type: "persona",
		# 							data:{
		# 								attributes: {
		# 									nombre: "Juan2",
		# 									apellido: "Perez2",
		# 									cedula: "123456-0"
		# 								}
		# 							}
		# 						}
		# 					}
		# }

		j = JSON.parse(params.to_json)
		# nota: puede que al integrar con eli tenga que poner j['data'][0]['propietario']['data']['attributes']['cedula']
		ci = j['data']['propietario']['data']['attributes']['cedula']
		id = j['data']['relationship']['vehiculo']['id'].to_i
		nombre = j['data']['propietario']['data']['attributes']['nombre']
		apellido = j['data']['propietario']['data']['attributes']['apellido']
		vehiculo = Vehiculo.find(id)
		@venta = Venta.new(matricula: vehiculo.matricula, ci: ci )

		body_propietario = { data:{ type:'persona', attributes: {nombre: nombre, apellido: apellido, cedula: ci } } }
		propietario = HTTParty.post("https://tagsi-2020-sucive.herokuapp.com/personas", { headers: { 'Content-Type' => 'application/vnd.api+json'}, body: body_propietario.to_json })
		propJson = JSON.parse(propietario.to_json)

		response = HTTParty.get("https://tagsi-2020-sucive.herokuapp.com/vehiculos?filter[matricula]=#{vehiculo.matricula}")
		r = JSON.parse(response.to_json)
		id_sucive = r["data"][0]["id"]
		body = { data:{ type:'vehiculo', id: id_sucive, attributes: {propietario_id: propJson['data']['id'] } } }
		if @venta.save
			patch_sucive = HTTParty.patch("https://tagsi-2020-sucive.herokuapp.com/vehiculos/#{id_sucive}", { headers: { 'Content-Type' => 'application/vnd.api+json'}, body: body.to_json })
			d = JSON.parse(patch_sucive.to_json)
			if d["data"].blank?
				@venta.destroy
				render json: { error: { status: 404, title: 'No se pudo actualizar los datos en Sucive. Por Favor, inténtelo de nuevo' } }
			else
				if vehiculo.destroy
					render json: {data: {
													type:'venta',
													attributes: @venta,
													links: {
														self: request.url + "/#{id}"
													}
												}
											}
				else
					render json: { error: { status: 404, title: 'No se pudo eliminar el vehiculo pero si se creó la venta.' } }
				end
			end
		else
			render json: { error: { status: 404, title: 'No se pudo completar la venta.' } }
		end
	end

	def index
	end

	private

	def ventas_params
		# params.require(:venta).permit(:ci, :matricula)
	end
end