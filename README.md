[![MIT licensed](https://img.shields.io/badge/license-MIT-blue.svg)](./LICENSE.txt)
[![Twitter Follow](https://img.shields.io/twitter/follow/sendgrid.svg?style=social&label=Follow)](https://twitter.com/buildsimhub)

**This library allows you to quickly and easily use the BuildSimHub Web API v1 via Python.**
This library represents the beginning of the Cloud Simulation function on BuildSimHub. Please browse the rest of this README for further detail.
We appreciate your continued support, thank you!

# Table of Contents
* [Installation](#installation)
* [Quick Start](#quick-start)
* [Objects and Functions](#functions)
* [Roadmap](#roadmap)
* [About](#about)
* [License](#license)

<a name="installation"></a>

# Installation

## Prerequisites
- The BuildSimHub service, starting at the [free level](https://my.buildsim.io/register.html)
- Python version 2.6, 2.7, 3.4, 3.5 or 3.6

## Install Package
Simply clone this repository and place in any folder you wish to build your application on. Examples:
![picture alt](https://imgur.com/x60rk2O.png)

## Setup environment
After you downloaded the whole package, the first you need to do is to reconfigure your user API in the [info.config](https://github.com/weilix88/buildsimhub_python_api/blob/master/BuildSimHubAPI/info.config) file.
You can find the API key associate with your account under the profile page:

![picture alt](https://imgur.com/gHehDiN.png)

Simple edit the [info.config](https://github.com/weilix88/buildsimhub_python_api/blob/master/BuildSimHubAPI/info.config)
`user_api_key:[YOUR_API_KEY]`

<a name="quick-start"></a>

# Quick Start

## Run simulation
The following is the minimum needed code to initiate a regular simulation with the [helpers/simulationJob](https://github.com/weilix88/buildsimhub_python_api/tree/master/BuildSimHubAPI/helpers)

### With SimulationJob Class
```python
from BuildSimHubAPI import buildsimhub
bsh = buildsimhub.BuildSimHubAPIClient()

#this key can be found under your project folder
folder_key="0ade3a46-4d07-4b99-907f-0cfeece321072"

#absolute directory to the energyplus model
file_dir = "/Users/weilixu/Desktop/5ZoneAirCooled.idf"

newSJ = bsh.newSimulationJob(folder_key)
response = newSj.createModel(file_dir)

#print success means the simulation job has successfully
#started a simulation, if there is an error, then
#you will receive the correspondent error message
print (response)
```
The `BuildSimHubAPIClient` creates a [portal object](https://github.com/weilix88/buildsimhub_python_api/blob/master/BuildSimHubAPI/buildsimhub.py) that manages simulation workflow.
From this object, you can initiate a [simulationJob](https://github.com/weilix88/buildsimhub_python_api/blob/master/BuildSimHubAPI/helpers/simulationJob.py) to conduct a cloud simulation. Call `createModel()` method with parameters can start the cloud simulation.

### Track Cloud simulation progress
```python
from BuildSimHubAPI import buildsimhub
bsh = buildsimhub.BuildSimHubAPIClient()

#this key can be found under your project folder
folder_key="0ade3a46-4d07-4b99-907f-0cfeece321072"

#absolute directory to the energyplus model
file_dir = "/Users/weilixu/Desktop/5ZoneAirCooled.idf"

newSJ = bsh.newSimulationJob(folder_key)
response = newSj.createModel(file_dir)

######BELOW ARE THE CODE TO TRACK SIMULATION#########
if(response == 'success'):
  while newSJ.trackSimulation():
    print (newSJ.trackStatus)
    time.sleep(5)
```
As mentioned previously, [BuildSimHubAPIClient](https://github.com/weilix88/buildsimhub_python_api/blob/master/BuildSimHubAPI/buildsimhub.py) manages the entire workflow of the simulation. So once a cloud simulation is successfully started by the [SimulationJob](https://github.com/weilix88/buildsimhub_python_api/blob/master/BuildSimHubAPI/helpers/simulationJob.py) class, you can simply call `trackSimulation()` function to receive the simulation progress.

### Retrieve Cloud simulation results
```python
from BuildSimHubAPI import buildsimhub
bsh = buildsimhub.BuildSimHubAPIClient()

#this key can be found under your project folder
folder_key="0ade3a46-4d07-4b99-907f-0cfeece321072"

#absolute directory to the energyplus model
file_dir = "/Users/weilixu/Desktop/5ZoneAirCooled.idf"

newSJ = bsh.newSimulationJob(folder_key)
response = newSj.createModel(file_dir)

if(response == 'success'):
  while newSJ.trackSimulation():
    print (newSJ.trackStatus)
    time.sleep(5)
  
  ######BELOW ARE THE CODE TO RETRIEVE SIMULATION RESULTS#########
  response = newSJ.getSimulationResults('html')
  print(response)
```
If the Job is completed, you can get results by calling `getSimulationResults(type)` function.

<a name="functions"></a>

#Object and Functions
## SimulationJob
The easiest way to generate a [SimulationJob](https://github.com/weilix88/buildsimhub_python_api/blob/master/BuildSimHubAPI/helpers/simulationJob.py) class is calling the `newSimulationJob()` method in the [BuildSimHubAPIClient](https://github.com/weilix88/buildsimhub_python_api/blob/master/BuildSimHubAPI/buildsimhub.py).
Nevertheless, you have to provide a `folder_key` in order to create a new [SimulationJob](https://github.com/weilix88/buildsimhub_python_api/blob/master/BuildSimHubAPI/helpers/simulationJob.py) instance.

The `folder_key` can be found under each folder of your project
![picture alt](https://imgur.com/jNrghIZ.png)

## simulationType
[SimulationType](https://github.com/weilix88/buildsimhub_python_api/blob/master/BuildSimHubAPI/helpers/simulationType.py) class helps you configure the cloud simulation. There are two simulation types: `regular` and `fast`. Also, ou can increase the number of agent by calling the `increaseAgents()` function.
```python
simulationType = bsh.getSimulationType()
numOfAgents = simulationType.increaseAgents();
print (numOfAgents)
```
It should be noted that the maximum number of agents working on one simulation job is limited to 12, and the more agents you assigned to one simulation job, the faster your simulation can be. You can also call `resetAgent()` function to reset the number of agent to 2.

## SimulationJob
A simulation job manages one type of cloud simulation. It contains three main functions which are listed below:

### createdModel
The `createModel()` function has in total 4 parameters.
1. `file_dir` (required): the absolute local directory of your EnergyPlus / OpenStudio model (e.g., "/Users/weilixu/Desktop/5ZoneAirCooled.idf")
2. `comment`(optional): The description of the model version that will be uploaded to your folder. The default message is `Upload through Python API`
3. `simulationType` (optional): The simulation Type should be generated from [SimulationType](https://github.com/weilix88/buildsimhub_python_api/blob/master/BuildSimHubAPI/helpers/simulationType.py) class. This class manages the simulation type as well as how many agents you want to assign to this simulation job. Default is `regular` simulation which uses 1 agent to do the cloud simulation.
4. `agent` (optional): The agent number is a property of [SimulationType](https://github.com/weilix88/buildsimhub_python_api/blob/master/BuildSimHubAPI/helpers/simulationType.py) class. If fast simulation is selected, then the default of agent will be 2.

This method returns two types of information:
If sucess: `success`
or error message states what was wrong in your request.

### trackSimulation
The `trackSimulation()` function does not require any parameters. However, it is required that a successful cloud simulation is created and running on the cloud. Otherwise, you will receive this message by calling this function:
`No simulation is running or completed in this Job - please start simulation using createModel method.`
If there is a simulation running on the cloud for this simulationJob, then, this function will return `true` and you can retrieve the simulation status by get the class parameter `trackStatus`. Example code is below:
```python
if(newSimulationJob.trackSimulation()):
  print(newSimulationJob.trackStatus)
```
### getSimulationResults
The `getSimulationResults(type)` function requires 1 parameter, the result type. Currently, you can retrieve three types of results: the error file (`err`), eso file (`eso`) and html file (`html`), generated from EnergyPlus simulation.

```python
response = newSimulationJob.getSimulationResults('err')
print (response)
```
<a name="roadmap"></a>
# Roadmap
1. Certainly, the first thing is to get the project into Pip to enable `pip install` command.
2. We are also working on an HTML compiler, which let users to retrieve any values from the html output
3. If you are interested in the future direction of this project, please take a look at our open [issues](https://github.com/weilix88/buildsimhub_python_api/issues) and [pull requests](https://github.com/weilix88/buildsimhub_python_api/pulls). We would love to hear your feedback.


<a name="about"></a>
# About

buildsimhub-python is guided and supported by the BuildSimHub [Developer Experience Team](mailto:haopeng.wang@buildsimhub.net).

buildsimhub-python is maintained and funded by the BuildSimHub, Inc. The names and logos for buildsimhub-python are trademarks of BuildSimHub, Inc.

<a name="license"></a>
# License
[The MIT License (MIT)](LICENSE.txt)

