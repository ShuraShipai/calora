"""Local-only Food-101 classifier training entry point (scaffold)."""

from __future__ import annotations

import argparse
import sys
from pathlib import Path

import yaml

from dataset_checks import PrerequisiteError, resolve_from_config, validate_food101


def require_training_dependencies() -> None:
    try:
        import torch  # noqa: F401
        import torchvision  # noqa: F401
        from PIL import Image  # noqa: F401
    except ImportError as error:
        raise PrerequisiteError(
            "Missing local Python dependency. Create a local environment and install "
            "ml/training/requirements.txt manually. Original error: " + str(error)
        ) from error


def load_config(path: Path) -> dict:
    if not path.is_file():
        raise PrerequisiteError(f"Configuration file not found: {path}")
    return yaml.safe_load(path.read_text(encoding="utf-8"))


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--config", type=Path, required=True)
    parser.add_argument("--dry-run", action="store_true", help="Validate only; never train.")
    args = parser.parse_args()

    try:
        require_training_dependencies()
        config_path = args.config.resolve()
        config = load_config(config_path)
        root = resolve_from_config(config_path, config["dataset_root"])
        split = config["split"]
        classes = validate_food101(root, split["classes_file"], split["train_list"], split["test_list"])
    except (PrerequisiteError, KeyError, yaml.YAMLError) as error:
        print(f"Prerequisite check failed: {error}", file=sys.stderr)
        return 2

    print(f"Validated Food-101: {classes} classes at {root}")
    print(f"Configured architecture: {config['model']['architecture']}")
    if args.dry_run:
        print("Dry run complete. No files were written and no training was started.")
        return 0
    print(
        "Training is intentionally not implemented in this scaffold. Review the dataset, "
        "taxonomy, metrics, and experiment plan before adding a training loop.",
        file=sys.stderr,
    )
    return 3


if __name__ == "__main__":
    raise SystemExit(main())
