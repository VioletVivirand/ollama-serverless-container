# Inference with Gemma via Ollama

## Usage

To build the image with "gemma:2b-instruct-q4_0" model:

```bash
./build.sh
```

Inference Example:

```bash
./run.sh
```

## Download another model

Edit Line # of `Dockerfile`, change the name and version of the model. Take `gemma:7b` for example:

```Dockerfile
RUN /bin/bash -c "/bin/ollama serve & sleep 1 && ollama pull gemma:7b"
```

Reference: https://github.com/langchain4j/langchain4j/blob/200522f558509a67e940ae4c82284b85caaebef8/docker/ollama/llama2/Dockerfile

## What is this?

| [TODO]

