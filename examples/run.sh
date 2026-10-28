#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
PYTHONPATH=src python -m gbt_gs_h3 info
PYTHONPATH=src python -m gbt_gs_h3 check --payload '{}'
PYTHONPATH=src python -m gbt_gs_h3 run   --payload '{}'
