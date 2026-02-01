# Guidelines

* All about LLM scripts


# Tech libraries

## Library 'ai-llm'

* Usage ```import lib-ai-llm```
* Prefix ```lm```

### Claude

#### Base commands

* Run claude with optional `MODEL_NAME` : ```lmc "[MODEL_NAME]"```

#### Configuration commands

* Print all Anthropic config `ANTHROPIC_*` : ```lmconfanthropic```
* Create an env config file at path `$ANTHROPIC_SCRIPT_PATH` : ```lmconfanthropiccreate "ANTHROPIC_AUTH_TOKEN" "[ANTHROPIC_BASE_URL]"```
* Create an env config file for Ollama ```lmconfanthropicollamacreate "[ANTHROPIC_BASE_URL:http://localhost:11434]"```
* Remove config file at `$ANTHROPIC_SCRIPT_PATH` :  ```lmconfanthropicrm```

### Google PaLM

* Create an env config file `env-google.bash` : ```lmconfgooglecreate "GOOGLE_API_KEY"```


## Library 'ai-ollama' & 'ai-openai'

* Usage ```import lib-ai-ollama```
* Enable using ```enableai```
* Prefix ```ol```

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
