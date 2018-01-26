require 'net/https'
require 'json'
require 'OpenSSL'
require_relative 'simulationType'


class SimulationJob
	@@user_key = "";
	@@boundary = "BuildSimHub_boundary_string";
	@@simType = SimulationType.new
	@@folder_key = "";
	@@track_token = "";
	@@track_status = "No simulation is running for this Job"

	def initialize(userKey, folderKey)
		@@user_key = userKey
		@@folder_key = folderKey
	end

	def getTrackStatus
		return @@track_status
	end

	def trackSimulation
		requestContent = 'https://develop.buildsimhub.net/TrackSimulation_API'<<'?user_api_key='<<@@user_key << '&track_token=' << @@track_token
		uri = URI.parse(URI.encode(requestContent))
		request = Net::HTTP::Get.new(uri)
		response = Net::HTTP.start(
			uri.host, uri.port, 
			:use_ssl => uri.scheme == 'https', 
			:verify_mode => OpenSSL::SSL::VERIFY_NONE) do |https|
			https.request(request)
		end

		resp_json = JSON.parse(response.body)
		if(resp_json['has_more'] == true)
			@@track_status = resp_json['doing'] << " " << resp_json['percent'].to_s << "%\r\n"
		else
			@@track_status = "No simulation is running for this Job"
		end

		return resp_json['has_more']
	end

	def getSimulationResult(resultType = nil)
		if(resultType==nil)
			resultType = "html"
		end

		requestContent = 'https://develop.buildsimhub.net/GetSimulationResult_API'<<'?user_api_key='<<@@user_key<<'&track_token='<<@@track_token<<'&result_type='<<resultType
		uri = URI.parse(URI.encode(requestContent))
		request = Net::HTTP::Get.new(uri)
		response = Net::HTTP.start(
			uri.host, uri.port,
			:use_ssl => uri.scheme == 'https',
			:verify_mode => OpenSSL::SSL::VERIFY_NONE) do |https|
			https.request(request)
		end

		return response.body
	end

	def createModel(file_dir, comment = nil, simulationType=nil, agents = 2)
		if(comment == nil)
			comment = "new upload from Ruby API";
		end

		if(simulationType == nil)
			simulationType = @@simType.regular()
		end

		uri = URI.parse('https://develop.buildsimhub.net/CreateModel_API')

		header = {"Content-Type" => "multipart/form-data; boundary=#{@@boundary}"}

		file = file_dir
		fileName = File.basename file

		post_body = []

		post_body << "--#{@@boundary}\r\n"
		post_body << "Content-Disposition: form-data; name=\"user_api_key\"\r\n\r\n"
		post_body << @@user_key
		post_body << "\r\n--#{@@boundary}\r\n"

		post_body << "--#{@@boundary}\r\n"
		post_body << "Content-Disposition: form-data; name=\"folder_api_key\"\r\n\r\n"
		post_body << @@folder_key
		post_body << "\r\n--#{@@boundary}\r\n"

		post_body << "--#{@@boundary}\r\n"
		post_body << "Content-Disposition: form-data; name=\"agents\"\r\n\r\n"
		post_body << agent
		post_body << "\r\n--#{@@boundary}\r\n"

		post_body << "--#{@@boundary}\r\n"
		post_body << "Content-Disposition: form-data; name=\"comment\"\r\n\r\n"
		post_body << comment
		post_body << "\r\n--#{@@boundary}\r\n"

		post_body << "--#{@@boundary}\r\n"
		post_body << "Content-Disposition: form-data; name=\"simulation_type\"\r\n\r\n"
		post_body << simulationType
		post_body << "\r\n--#{@@boundary}\r\n"

		post_body << "Content-Disposition: form-data; name=\"file\"; filename=\"" + fileName + "\"\r\n"
		post_body << "Content-Type: \"application\/octet-stream\"\r\n\r\n"
		post_body << File.read(file)
		post_body << "\r\n\r\n--#{@@boundary}--\r\n"

	
		request = Net::HTTP::Post.new(uri, header)
		request.body = post_body.join
		response = Net::HTTP.start(
			uri.host, uri.port, 
			:use_ssl => uri.scheme == 'https', 
			:verify_mode => OpenSSL::SSL::VERIFY_NONE) do |https|
			https.request(request)
		end

		resp_json = JSON.parse(response.body)

		if(resp_json['status'] == 'success')
			@@track_token = resp_json['tracking']
			return resp_json['status']
		else
			return resp_json['error_msg']
		end
	end
end