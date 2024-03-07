# Launch Ollama Backend and sleep 1 second to make sure the backend is launched
echo "[INFO] Launching Ollama"
bash -c "nohup ollama serve > /ollama_log.txt 2>&1 &"
sleep 1

# Make inference with model "gemma:2b-instruct-q4_0", and accept a argument as prompt
echo "[INFO] Make inference"
ollama run gemma:2b-instruct-q4_0 $1

# Kill Ollama backend process
echo "[INFO] Kill Ollama Process"
kill -9 $(pgrep -f "ollama serve")

echo "[INFO] Done."
