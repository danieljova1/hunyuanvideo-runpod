#!/usr/bin/env bash
set -e
echo "Launching HunyuanVideo with profile ${HUNYUAN_PROFILE}"
python gradio_server.py --profile "${HUNYUAN_PROFILE}"
