class Api::V1::VehiculosController < ApplicationController
	require 'json'

	def index
		@vehiculos = Vehiculo.all
		@vehiculosJson = @vehiculos.each_with_object([]) {|cal, array| array << cal.testMethod }
		render json: { data: @vehiculosJson }
	end

	def reporte_vehiculo
		if params[:matricula].present?
			matricula = JSON.parse(params[:matricula])
			#primer get al ministerio para obtener si es un vechiculo requerido
			respuesta_requerido = HTTParty.get("https://tagsi-2020-ministerio-interior.herokuapp.com/vehiculos?matricula=#{matricula}")
			j = JSON.parse(respuesta_requerido.to_json)

			#segundoo get, al sucive para obtener las deudas
			respuesta_deudas = HTTParty.get("https://tagsi-2020-sucive.herokuapp.com/vehiculos?filter[matricula]=#{matricula}&include=deudas")
			d = JSON.parse(respuesta_deudas.to_json)

			if j["data"].blank?
				render json: {
					data: {
						type: "reporte-vehiculo",
						id_sucive: d["data"][0]["id"],
						attributes: d["data"][0]["attributes"],
						relationships: d["included"],
						requerido: false,
						links: {
							self: request.url,
						}
					}
			}
			else
				render json: {
						data: {
							type: "reporte-vehiculo",
							id_sucive: d["data"][0]["id"],
							attributes: j["data"][0]["attributes"],
							relationships: d["included"],
							requerido: true,
							links: {
								self: request.url
							}
						}
				}
			end
		else
			render json: { error: { status: 404, title: 'Falta matricula.' }}
		end
	end

	def create
		# json es de tipo { data: {
		# 							attributes: {
		# 								matricula: "ahora5678",
		# 								marca: "toyota",
		# 								modelo: "corolla",
		# 								ano: 2016,
		#									precio:800  }
		# 						}
		# 				}
		matricula = vehiculo_params[:matricula]
		@vehiculo = Vehiculo.new(vehiculo_params)
		if @vehiculo.save
			response = HTTParty.get("https://tagsi-2020-sucive.herokuapp.com/vehiculos?filter[matricula]=#{ matricula }")
			r = JSON.parse(response.to_json)
			id_sucive = r["data"][0]["id"]
			body = { data:{ type:'vehiculo', id: id, attributes: { propietario_id: 1 } } } # el propietario con id 1 es la automotora en la base del sucive
			patch_sucive = HTTParty.patch("https://tagsi-2020-sucive.herokuapp.com/vehiculos/#{id_sucive}", { headers: { 'Content-Type' => 'application/vnd.api+json'}, body: body.to_json })
			d = JSON.parse(patch_sucive.to_json)
			if d["data"].blank?
				@vehiculo.destroy
				render json: { error: { status: 404, title: 'No se pudo actualizar los datos en Sucive. Por Favor, inténtelo de nuevo' } }
			else
				render json: {
					data: {
						type:'vehiculo',
						attributes: @vehiculo,
						links: {
							self: request.url
						}
					}
				}
		else
			render json: { error: { status: 404, title: 'Oops! No se pudo crear el vehiculo.' } }
		end
	end

	def show
		vehiculo = Vehiculo.find(params[:id])
		if vehiculo.present?
			render json:{ data:{ type:'vehiculo', id: vehiculo.id, attributes:{ matricula: vehiculo.matricula, marca: vehiculo.marca, modelo: vehiculo.modelo, ano: vehiculo.ano, precio: vehiculo.precio }, links:{self: request.url } } }
		else
			render json: { error: { status: 404, title: 'No se encontró vehiculo con ese id.' }}
		end
	end

	def destroy
		@vehiculo = Vehiculo.find(params[:id])
		@vehiculo.destroy
		render json: { success: { status: 200 }}
	end

	private

	def vehiculo_params
		params.require(:data).require(:attributes).permit(:matricula, :marca, :modelo, :ano, :precio)
	end
end