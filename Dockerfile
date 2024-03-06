FROM ollama/ollama:0.1.27

RUN /bin/bash -c "/bin/ollama serve & sleep 1 && ollama pull gemma:2b-instruct-q4_0"

COPY ["serve.sh", "/serve.sh"]
RUN ["chmod", "+x", "/serve.sh"]

ENTRYPOINT ["/bin/bash", "-c"]
