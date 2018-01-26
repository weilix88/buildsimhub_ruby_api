require_relative 'BuildSimHubAPI/BuildSimHubAPI'

api = BuildSimHubAPI.new

#to upload a model and run the simulation

#1. set your folder key
folder_key="0dde5a46-4d07-4b99-907f-0cfedf301072"
#2. define the absolute directory of your energy model
file_dir = "/Users/weilixu/Desktop/5ZoneAirCooled.idf"
#3. this is optional
comment = "new upload 2"
#4. simulation Type. this is optional
st = api.getSimulationType
type = st.regular

newSj = api.newSimulationJob(folder_key)
#5. start the API call
response = newSj.createModel(file_dir, comment, type)
if(response == 'success')
    while newSj.trackSimulation do
        print newSj.getTrackStatus
        sleep 10
    end

    response = newSj.getSimulationResult("err")
else
    print response
end