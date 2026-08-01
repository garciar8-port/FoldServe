# FoldServe

Distributed protein-model deployment on a GPU cluster — fine-tune ESM-2, serve multi-GPU, orchestrate across clouds, deploy into a customer VPC with data staying in-region.

The downstream task is **subcellular localization** (DeepLoc, 10-class) via a mean-pool + MLP head on the ESM-2 backbone. The distinguishing artifact is a cross-silicon cost/throughput benchmark (eager | TensorRT | Neuron) plus a tradeoffs writeup.

> Project brief, architecture, and decision log (thinking/context) live in the Obsidian vault: `Personal Projects/FoldServe/`.

## Repository layout

```
src/foldserve/
  data/        # DeepLoc load, ESM-2 tokenize, length-bucketing
  models/      # ESM-2 backbone + masked mean-pool + MLP head
  training/    # distributed fine-tuning (DDP -> FSDP)
  serving/     # FastAPI inference (replica- & tensor-parallel, batching)
configs/       # run/experiment configs
scripts/       # entrypoints and one-off utilities
infra/         # Docker, SkyPilot, VPC/ECR deploy assets
benchmarks/    # scaling curves, throughput, cross-silicon cost tables
tests/         # smoke + unit tests
```

## Setup

Requires Python >= 3.10.

```bash
python -m venv .venv && source .venv/bin/activate
make install          # pip install -e ".[dev]" + pre-commit install
cp .env.example .env  # then fill in AWS / Hugging Face / NGC credentials
```

`torch` installs the default CPU/CUDA wheel for your platform; on a GPU node install the CUDA-matched build from pytorch.org if needed.

## Common tasks

```bash
make lint     # ruff check + black --check (no writes)
make format   # ruff --fix + black
make test     # pytest
make help     # list all targets
```

## Build phases

Walking-skeleton first (thin slice end-to-end), then deepen. Tickets live in Linear (Crestline / FoldServe), grouped by milestone.

| Phase | Focus |
|-------|-------|
| 0 | Foundation — accounts, billing guardrails, repo scaffold, data module |
| 1 | Walking skeleton — tiny ESM-2: fine-tune -> serve -> container |
| 2 | Training depth — FSDP on the 3B variant; scaling + Nsight |
| 3 | Serving depth — replica/tensor-parallel, batching, Triton, TensorRT |
| 4 | Silicon arms — BioNeMo (NVIDIA-native) + AWS Neuron (inf2/trn1) |
| 5 | Orchestration — one-command SkyPilot launch + auto-teardown |
| 6 | Customer VPC — deploy with data residency (private S3/ECR, VPC endpoints) |
| 7 | Artifacts & story — benchmarks, diagrams, tradeoffs writeup |
