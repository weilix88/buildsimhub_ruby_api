class SimulationType
	#read and write all the information about the user and the project
	@@fast= "fast"
	@@regular = "regular"
    @@agents = 2

	def fast()
		return @@fast
	end

	def regular()
		return @@regular
	end

    def increaseAgents()
        if(@@agent<6)
            @@agent +=2
            return @@agent
        elsif(@@agent ==6)
            @@agent =12
            return @@agent
        else
            return @@agent
        end
    end

    def resetAgent()
        @@agent = 2
        return @@agent
    end

end

