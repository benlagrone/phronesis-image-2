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

# Copy project sources.
COPY docker-entrypoint.sh /app/docker-entrypoint.sh
COPY requirements.txt /app/requirements.txt
COPY requirements_versions.txt /app/requirements_versions.txt
COPY scripts /app/scripts
COPY stable-diffusion-webui /app/stable-diffusion-webui

RUN pip install --upgrade pip \
 && pip install --no-cache-dir -r /app/requirements_versions.txt \
 && pip install --no-cache-dir -r /app/requirements.txt \
 && if [ ! -f /app/stable-diffusion-webui/launch.py ]; then \
      git clone --depth 1 https://github.com/AUTOMATIC1111/stable-diffusion-webui.git /app/stable-diffusion-webui; \
    fi

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
