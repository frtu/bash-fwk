# Guidelines

* All about LLM scripts


# Tech libraries

## Library 'ai-vllm'

Starting [vLLM](https://docs.vllm.ai/en/stable/) : efficient LLM serve

* Usage ```import lib-ai-vllm```
* Enable using ```enableaivllm```
* Prefix ```av```

### Base commands

* Run service : ```avrun "[MODEL_NAME:TinyLlama/TinyLlama-1.1B-Chat-v1.0]"```
* Install vLLM (fix python version, torch & vllm) : ```avcreate```
* Install to local project : ```ppinst_vllm```

### Client commands

* List all models from server : ```avls```
* Chat using service : ```avchat "CHAT" "[MODEL_NAME:TinyLlama/TinyLlama-1.1B-Chat-v1.0]" "[MAX_TOKEN:7]" "[TEMPERATURE:0]"```

### Model commands

* Going to Huggingface model folder : ```avmcd```
* List all models : ```avmls```
* Remove specific model : ```avmrm "MODEL_NAME"```

## Library 'ai-ollama' & 'ai-openai'

* Usage ```import lib-ai-ollama```
* Enable using ```enableai```
* Prefix ```ol```

## Library 'ai-autogen'

* Usage ```import lib-ai-autogen```
* Enable using ```enableautogen```
* Prefix ```ag```

### Base commands

* (Re)create and install an `autogen` env : ```agcreate```
* Activate `autogen` env : ```agactivate```
* Install `autogenstudio` : ```aginst```
* Upgrade `autogenstudio` : ```agupg```
* Start `autogenstudio ` at port : ```agstart "[SERVER_PORT:9999]"```
