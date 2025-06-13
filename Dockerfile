# CUDA 12.4 runtime image with Python 3.10
FROM nvidia/cuda:12.4.1-cudnn9-runtime-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Etc/UTC \
    PYTHONUNBUFFERED=1

RUN apt-get update && \
    apt-get install -y --no-install-recommends git wget ffmpeg libgl1 && \
    rm -rf /var/lib/apt/lists/*

RUN python3 -m pip install --upgrade pip wheel

# PyTorch wheel that matches CUDA 12.4
RUN pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu124

WORKDIR /workspace
RUN git clone --depth 1 https://github.com/deepbeepmeep/Wan2GP.git app
WORKDIR /workspace/app
RUN pip install -r requirements.txt

# optional speed-up: pull the Hunyuan Avatar checkpoint now, not at runtime
# RUN bash scripts/get_hunyuan_avatar_ckpt.sh

ENV SERVER_NAME=0.0.0.0 \
    SERVER_PORT=7860 \
    HUNYUAN_PROFILE=1   # profile 2 = 12-16 GB VRAM

EXPOSE 7860
ENTRYPOINT ["bash", "/workspace/app/launch.sh"]
