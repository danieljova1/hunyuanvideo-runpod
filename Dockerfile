# CUDA 12.4.0 runtime, Ubuntu 22.04
FROM nvidia/cuda:12.4.0-runtime-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Etc/UTC \
    PYTHONUNBUFFERED=1

# ---- system dependencies ----------------------------------------------------
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    python3 python3-pip python3-venv \
    git wget ffmpeg libgl1 && \
    rm -rf /var/lib/apt/lists/*

# ---- fresh pip --------------------------------------------------------------
RUN python3 -m pip install --upgrade pip wheel

# ---- PyTorch (CUDA 12.4 wheels) --------------------------------------------
RUN pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu124

# ---- Wan2GP code ------------------------------------------------------------
WORKDIR /workspace
RUN git clone --depth 1 https://github.com/deepbeepmeep/Wan2GP.git app
WORKDIR /workspace/app
RUN pip install -r requirements.txt

# Optional: pre-download the big Avatar checkpoint (~6 GB)
# RUN bash scripts/get_hunyuan_avatar_ckpt.sh

ENV SERVER_NAME=0.0.0.0 \
    SERVER_PORT=7860 \
    HUNYUAN_PROFILE=1    

EXPOSE 7860
ENTRYPOINT ["bash", "/workspace/app/launch.sh"]
