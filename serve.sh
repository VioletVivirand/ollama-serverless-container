/bin/bash -c "nohup ollama serve &> ollama_log.txt &" && \
  sleep 1 && \
  ollama run gemma:2b-instruct-q4_0 $1
