   conda create -n stable-diffusion python=3.10
   conda activate stable-diffusion

python launch.py --port 7861 --skip-torch-cuda-test --upcast-sampling --use-cpu interrogate --api --no-half --precision full --use-cpu all --disable-nan-check --medvram 2>&1 | tee webui7861.log


   python launch.py --ckpt ~/sd-models/Juggernaut-XL_v9_RunDiffusionPhoto_v2.safetensors --port 7861 --skip-torch-cuda-test --upcast-sampling --no-half-vae --use-cpu interrogate --api --no-half --precision full --use-cpu all --disable-nan-check --medvram --device mps 2>&1 | tee webui7861.log

   

      python launch.py --ckpt ~/sd-models/Realistic_Vision_V6.0_NV_B1.safetensors --port 7861 --skip-torch-cuda-test --upcast-sampling --no-half-vae --use-cpu interrogate --api --no-half --precision full --use-cpu all --disable-nan-check --medvram --device mps 2>&1 --reinstall-torch | tee webui7861.log

      python launch.py --ckpt ~/sd-models/Realistic_Vision_V6.0_NV_B1.safetensors --port 7861 --skip-torch-cuda-test --upcast-sampling --no-half-vae --use-cpu interrogate --api --no-half --precision full --use-cpu all --disable-nan-check --medvram --device mps --reinstall-torch

      Here's a clear, concise, and markdown-formatted set of instructions you can save to a `.md` file for future reference:

---

# Resolving `sqlite3.OperationalError: no such column: "size"` Error in Stable Diffusion WebUI

This error typically occurs due to a corrupted or outdated cache database schema used by `diskcache`. Switching models can trigger this issue by accessing or updating cached metadata.

Follow these steps to completely resolve the issue:

## Step 1: Remove the Cache Directory

Delete the entire cache directory to ensure no corrupted cache files remain:

```bash
rm -rf /Users/benjaminlagrone/Documents/projects/stable-diffusion-webui2/stable-diffusion-webui/cache
```

## Step 2: Recreate Your Conda Environment

Your Python environment might be corrupted or incompatible. Recreate it cleanly:

**Deactivate your current environment:**

```bash
conda deactivate
```

**Remove the existing environment completely:**

```bash
conda remove -n stable-diffusion --all -y
```

**Create a fresh environment:**

```bash
conda create -n stable-diffusion python=3.10 -y
```

**Activate the new environment:**

```bash
conda activate stable-diffusion
```

## Step 3: Reinstall Dependencies

Navigate to your project directory:

```bash
cd /Users/benjaminlagrone/Documents/projects/stable-diffusion-webui2/stable-diffusion-webui
```

Reinstall all dependencies freshly:

```bash
pip install -r requirements.txt
```

(If you have a specific installation script or command, run that instead.)

Place any downloaded `.safetensors` checkpoints in `~/sd-models` so they can be shared across projects and referenced by the launch commands below.

## Step 4: Launch Your Application

Use your usual launch command to start the application, pointing `--ckpt` at your model in `~/sd-models`:

```bash
python launch.py --ckpt ~/sd-models/Reliberate_v3.safetensors --port 7861 --skip-torch-cuda-test --upcast-sampling --no-half-vae --use-cpu interrogate --api --no-half --precision full --use-cpu all --disable-nan-check --medvram --device mps --reinstall-torch
```

## Step 5: Run Inside Docker (Optional)

1. Copy the sample environment file and configure host paths for your shared directories:

   ```bash
   cp .env.example .env
   # edit .env so SD_MODELS_DIR and SD_OUTPUTS_DIR point at your host folders
   # (e.g., leave the default ${HOME}/... values or replace with any absolute path)
   # use `echo $HOME` on Ubuntu if you need to confirm your home directory path
   ```

2. Build and start the container on the shared `fortress-phronesis-net` bridge:

   ```bash
   docker compose up --build -d
   ```

   The compose file mounts your model and picture folders into the container at `/data/models` and `/data/pictures`, publishes the UI on port 7861, and attaches to `fortress-phronesis-net` for intra-service communication.

3. Watch the logs or follow the startup interactively if needed:

   ```bash
   docker compose logs -f
   ```

4. Stop or restart the service when required:

   ```bash
   docker compose down      # stop and remove the container
   docker compose restart   # restart after configuration edits
   ```

The container keeps writing generated images to `SD_OUTPUTS_DIR/outputs` on the host and loads checkpoints from `SD_MODELS_DIR`.

---

## Why This Works:

- **Removing the cache directory** ensures no corrupted database files remain.
- **Recreating your Conda environment** ensures a clean Python environment without corrupted packages.
- **Reinstalling dependencies** ensures compatibility and correct schema creation.

Following these steps carefully will resolve the persistent `sqlite3.OperationalError`.

python launch.py \
  --ckpt ~/sd-models/Reliberate_v3.safetensors \
  --port 7861 \
  --skip-torch-cuda-test \
  --upcast-sampling \
  --no-half \
  --no-half-vae \
  --use-cpu all \
  --precision full \
  --disable-nan-check \
  --medvram \
  --device mps \
  --api \
  --reinstall-torch
