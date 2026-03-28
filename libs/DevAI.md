# Guidelines

* All about LLM scripts


# Tech libraries

## Library 'ai-llm'

* Usage ```import lib-ai-llm```
* Prefix ```lm```

### Claude

#### Base commands

* Run claude with optional `MODEL_NAME` (can set var env to define model) : ```lmc "[MODEL_NAME]"```
* Run `/config` command for claude : `lmconfclaude`
* Install Claude in native mode : `inst_claudenative`

#### Configuration commands

* Print all Anthropic config `ANTHROPIC_*` : ```lmconfanthropic```
* Create an env config file at path `$ANTHROPIC_SCRIPT_PATH` : ```lmconfanthropiccreate "ANTHROPIC_AUTH_TOKEN" "[ANTHROPIC_BASE_URL]"```
* Create an env config file for Ollama ```lmconfanthropicollamacreate "[ANTHROPIC_BASE_URL:http://localhost:11434]"```
* Remove config file at `$ANTHROPIC_SCRIPT_PATH` :  ```lmconfanthropicrm```

#### Troubleshooting

Attention when starting with a model & get this error :
```
Unable to connect to API (ConnectionRefused)
```

Verify the server is started and accept connection.

### Google AI Studio

#### Base commands

* List all models available for your Google AI Studio : ```lmgls ```

#### Install & configuration commands

* Install [google-genai](https://pypi.org/project/google-genai/) & image lib : ```ppinst_ggenai```
* Create an env config file `env-google.bash` : ```lmconfgooglecreate "GOOGLE_API_KEY"```

### [LiteLLM](https://docs.litellm.ai/docs/tutorials/claude_non_anthropic_models)

* Prefix `lmlitellm`

#### Base commands

* Run service : ```lmlitellmstart```
* Test service is running : `lmlitellmping`

#### Install & configuration commands

* Install [litellm](https://docs.litellm.ai/docs/tutorials/claude_non_anthropic_models) : ```inst_litellm "LITELLM_MASTER_KEY"```
* Re/Create an env config file `env-litellm.bash` : ```lmconflitellmcreate "LITELLM_MASTER_KEY"```

#### Extension

* Configure Claude to use LiteLLM : `lmconflitellmclaude`

### [Brave](https://api-dashboard.search.brave.com/app/dashboard)

#### Base commands

* Configure BRAVE_SEARCH_API_KEY into sys env : ```lmconfbravecreate "BRAVE_SEARCH_API_KEY"```

## Library 'ai-openclaw'

* Usage ```import lib-ai-openclaw```
* Prefix ```lmo```

### Cron Job commands

* List all cron jobs : ```lmoj```
* List cron job execution by ID : ```lmoj "JOB_ID"```

### Base commands

* Open dashboard : ```lmo```
* Display Openclaw log : ```lmolog```
* Stop Openclaw : ```lmostop```
* Restart Openclaw : ```lmorestart```

### Admin commands

* Configure & onboard OpenClaw : ```lmoconf```
* Fix config : ```lmofix```

#### Admin version & upgrade

* Display Openclaw version : ```lmov```
* Upgrade current version : ```lmoupd```

#### Admin UI - Gateway commands

* Gateway status : ```lmog```
* Gateway start : ```lmogstart```
* Gateway stop : ```lmogstop```
* Gateway restart : ```lmogrestart```

#### Security commands

* Run Security audit : ```lmosec```
* Run Security audit in JSON : ```lmosecjson```
* Run Security fixes : ```lmosecfix```

### Configuration commands

#### Model usage

* List all models : ```lmomodel```
* Use model : ```lmomodelset "MODEL"```
* Display model status : ```lmomodelstatus```

#### Introspection

* Describe OpenClaw public persona IDENTITY & USER : ```lmodesc```
* Describe OpenClaw's SOUL (inner philosophy) : ```lmodescfull```

## Library 'ai-ollama' & 'ai-openai'

* Usage ```import lib-ai-ollama```
* Enable using ```enableai``` OR `inst_ollama`
* Prefix ```ol```

### Base commands

* Start OpenClaw with Ollama : ```olclaw "MODEL"```
* Check logs : `ollog`
* Start Ollama : `olstart`
* Stop Ollama : `olstop`

### Admin commands

* Uninstall : `oluninst`

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
