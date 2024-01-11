BIN=/home/aditya/memtis/memtis-userspace/scripts/memtis_comparison
HEMEM=/home/aditya/hemem-ucm
OUTPUT=/home/aditya/memtis/comparison_results
MODEL=/mnt/sda1/models/Llama-2-70b-chat-hf/ggml-model-f16.gguf

BIN_FOLDER=${HEMEM}/microbenchmarks
APP_FOLDER=${HEMEM}/apps


mkdir -p ${OUTPUT}