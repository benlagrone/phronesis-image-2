FROM python:3.10-slim

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    TORCH_COMMAND="pip install torch==2.1.2 torchvision==0.16.2 --index-url https://download.pytorch.org/whl/cpu" \
    COMMANDLINE_ARGS="--listen --port 7861 --skip-torch-cuda-test --outdir /data/pictures/outputs --ckpt-dir /data/models --api"

RUN apt-get update \
 && apt-get install -y --no-install-recommends git ffmpeg libgl1 libglib2.0-0 \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Pre-copy requirement files for better build caching.
COPY stable-diffusion-webui/requirements_versions.txt stable-diffusion-webui/requirements_versions.txt
COPY stable-diffusion-webui/requirements.txt stable-diffusion-webui/requirements.txt

RUN pip install --upgrade pip \
 && pip install --no-cache-dir -r stable-diffusion-webui/requirements_versions.txt

# Copy project sources.
COPY . /app

RUN pip install --no-cache-dir -r /app/stable-diffusion-webui/requirements.txt

# Use a non-root user for running the web UI.
RUN useradd --create-home --shell /bin/bash webui \
 && chown -R webui:webui /app

USER webui
WORKDIR /app/stable-diffusion-webui

ENV PATH="/home/webui/.local/bin:${PATH}"

RUN chmod +x /app/docker-entrypoint.sh

ENTRYPOINT ["/app/docker-entrypoint.sh"]
CMD ["python", "launch.py"]

EXPOSE 7861
