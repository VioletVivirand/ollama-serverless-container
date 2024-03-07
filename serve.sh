echo "[INFO] Launching Ollama"
bash -c "nohup ollama serve > /ollama_log.txt 2>&1 &"
sleep 1

echo "[INFO] Make inference"
ollama run gemma:2b-instruct-q4_0 $1

echo "[INFO] Kill Ollama Process"
kill -9 $(pgrep -f "ollama serve")

echo "[INFO] Done."
