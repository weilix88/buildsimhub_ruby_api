require_relative 'helper/simulationType'
require_relative 'helper/bldgsim_info'
require_relative 'helper/simulationJob'

class BuildSimHubAPI

    @@user_key = "";

    def initialize()
        info = MetaInfo.new

        @@user_key = info.getUserAPIKey
    end

    def getUserKey()
        return @@user_key
    end

    def newSimulationJob(folder_key)
        sj = SimulationJob.new(@@user_key, folder_key)
        return sj
    end

    def getSimulationType()
        st = SimulationType.new()
        return st
    end

end