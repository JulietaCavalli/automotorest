class Api::V1::VehiculosController < ApplicationController
	require 'json'

	def index
		@vehiculos = Vehiculo.all
		render json: {
							data: {
								type:'vehiculos',
								links: {
									self: 'http://.../api/vehiculos'
								},
								attributes: @vehiculos
							}}
	end

	def reporte_vehiculo
		# tengo que ver como agarrar la matricula aca
		matricula = 'fgv3242'
		#promer get al ministerio para obtener si es un vechiculo requerido
		respuesta_requerido = HTTParty.get("http://.../v1/vehiculos-requeridos?matricula=#{matricula}")
		j = JSON.parse(response)
		#hay que ver si es requerido
		#...

		#segundoo get, al sucive para obtener las deudas
		respuesta_deudas = HTTParty.get("http://.../api/rest/v1/vehiculos?matricula=#{matricula}")

	end

	def create
		# json es de tipo { data: {
		# 							attributes: {
		# 								matricula: "ahora5678",
		# 								marca: "toyota",
		# 								modelo: "corolla",
		# 								ano: 2016   }
		# 						}
		# 				}

		# que hago con el precio?
		@vehiculo = Vehiculo.new(ventas_params)
		@vehiculo.precio = 9000
		@vehiculo.requerido = true
		if @vehiculo.save
			render json: {
				data: {
					type:'vehiculo',
					attributes: @vehiculo,
					links: {
						self: 'http://localhost:3000/api/vehiculos'
					}
				}}
		else
			render json: {
				error: {
					status: 404,
					title: 'Oops! No se pudo crear el vehiculo.'
				}
			}
		end
	end


	def destroy

	end

	private

	def ventas_params
		params.require(:data).require(:attributes).permit(:matricula, :marca, :modelo, :ano, :precio)
	end
end