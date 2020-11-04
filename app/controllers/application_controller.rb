class ApplicationController < ActionController::API
	before_action :beforeRequest

	def beforeRequest
    $request = request
  end
end
