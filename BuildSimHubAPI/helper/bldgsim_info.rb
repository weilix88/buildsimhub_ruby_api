class MetaInfo
	#read and write all the information about the user and the project
	@@user_api_key = "";

	def initialize()
		#dir = File.dirname(File.absolute_path(__FILE__));
		binpath = File.dirname(__FILE__)
		dir = File.expand_path(File.join(binpath,".."))
		File.open(dir + "/info.config","r") do |lines|
			lines.each_line do |line|
				identifier = line.split(":")
				@@user_api_key = identifier.last
			end
		end
	end

	def getUserAPIKey()
		return @@user_api_key;
	end

	def saveChanges()
		#dir = File.dirname(File.absolute_path(__FILE__));
		binpath = File.dirname(__FILE__)
		dir = File.expand_path(File.join(binpath,".."))
		File.open(dir + "/info.config","w") do |f|
			f.puts "user_api_key:" << @@user_api_key
		end
	end
end


