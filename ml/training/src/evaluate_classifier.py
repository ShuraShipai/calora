"""Local-only Food-101 classifier evaluation entry point (scaffold)."""

from __future__ import annotations

import argparse
import sys
from pathlib import Path

from train_classifier import load_config, require_training_dependencies
from dataset_checks import PrerequisiteError, resolve_from_config, validate_food101


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--config", type=Path, required=True)
    parser.add_argument("--checkpoint", type=Path, required=True)
    args = parser.parse_args()

    try:
        require_training_dependencies()
        config_path = args.config.resolve()
        config = load_config(config_path)
        root = resolve_from_config(config_path, config["dataset_root"])
        split = config["split"]
        validate_food101(root, split["classes_file"], split["train_list"], split["test_list"])
        if not args.checkpoint.is_file():
            raise PrerequisiteError(f"Checkpoint not found: {args.checkpoint}")
    except PrerequisiteError as error:
        print(f"Prerequisite check failed: {error}", file=sys.stderr)
        return 2

    print(
        "Evaluation is intentionally not implemented in this scaffold. The future loop "
        "must report top-1, top-3, confidence calibration, and rejection metrics.",
        file=sys.stderr,
    )
    return 3


if __name__ == "__main__":
    raise SystemExit(main())
