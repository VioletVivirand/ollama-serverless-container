# Ollama Serverless Container <!-- omit in toc -->

Tested with [Ollama Official Image `v0.1.27`](https://hub.docker.com/layers/ollama/ollama/0.1.27/images/sha256-04d6cc972388b6c014105fbca10f0c25a17e8c12bd7f528ef0db7f8d114d585a?context=explore).

- [What is this?](#what-is-this)
- [Usage](#usage)
  - [Build Docker Image with pre-downloaded Model Artifact](#build-docker-image-with-pre-downloaded-model-artifact)
  - [Download another model](#download-another-model)


## What is this?

Ollama is a super easy tool to run LLM/GenAI model locally, with [elegant installaion options]([url](https://ollama.com/download)), [huge community ecosystem]([url](https://github.com/ollama/ollama?tab=readme-ov-file#community-integrations)) and [official Docker Images]([url](https://hub.docker.com/r/ollama/ollama)) built.

Regular installation will put a executable binary file into system, but we can also run Ollama as Docker Container. It's a two-step process:

1. Execute `docker run -itd --name ollama ollama/ollama` to launch Ollama backend, the [default Entrypoint is `/bin/ollama` and Command is `serve`](https://github.com/ollama/ollama/blob/ce9f7c467481e4d636de5c5befb0a09da06b3614/Dockerfile#L137-138), which means it executes [`ollama serve`]([url](https://github.com/ollama/ollama?tab=readme-ov-file#start-ollama)) to be ready to accept incoming requests
2. Execute `docker exec -it ollama ollama run <Model Name:Version>` to enter the interactive interface and start to inject prompts

Sounds good, but not enough. If we gonna host with some cloud services and turn Ollama into a serverless, it should

1. Launch the backend at the first moment
2. Accept a prompt argument then output the answer
3. Shutdown

So we can make inference like following pseudo code: `docker run -it --rm --name ollama/ollama ollama run <Model Name:Version> "<Prompt>"`.

If you need the same function, this repository gives you a better way to use Ollama as Docker Container.

## Usage

To build the image with "gemma:2b-instruct-q4_0" model for example:

```bash
./build.sh

# Which actually does this:
docker build -t gemma .
```

This will take some time since one of the building step is download the model artifact.

Inference Example:

```bash
./run.sh

# Which actually does this:
docker run -it --rm --name gemma gemma '/serve.sh "<Prompt>"'
```

The magic is in the [`serve.sh` script]([url](https://github.com/VioletVivirand/ollama-serverless-container/blob/main/serve.sh)) that

1. Launches the Ollama backend in the background: `nohup ollama serve`
2. Sleep 1 second to make sure the backend is awaken: `sleep 1`
3. Make inference with "gemma:2b-instruct-q4_0" model and take the argument as Prompt: `ollama run gemma:2b-instruct-q4_0 "<Prompt>"`

### Build Docker Image with pre-downloaded Model Artifact

Sometimes it's annoying to download the model artifact everytime when building Docker Image. Another approach is pre-downloaded it, and copy into Docker Image during the building process.

1. Create a directory to store the artifacts: `mkdir ollama`
2. Launch Ollama Container and mount the directory: `docker run -it --rm -v $(pwd)/ollama/:/root/.ollama/ --name ollama ollama/ollama`
3. Pull the Model artifact: `docker exec -it ollama ollama pull <Model Name:Version>`
4. Edit the Dockerfile: Remove `RUN /bin/bash -c "/bin/ollama serve & sleep 1 && ollama pull <Model"`, replace it with `COPY ["ollama/", "/root/.ollama/"]`

Example Dockerfile:

```Dockerfile
FROM ollama/ollama:0.1.27

COPY ["ollama/", "/root/.ollama/"]

COPY ["serve.sh", "/serve.sh"]
RUN ["chmod", "+x", "/serve.sh"]

ENTRYPOINT ["/bin/bash", "-c"]
```

### Download another model

Edit Line # of `Dockerfile`, change the name and version of the model. Take `gemma:7b` for example:

```Dockerfile
RUN /bin/bash -c "/bin/ollama serve & sleep 1 && ollama pull gemma:7b"
```

Reference: https://github.com/langchain4j/langchain4j/blob/200522f558509a67e940ae4c82284b85caaebef8/docker/ollama/llama2/Dockerfile
