"""Validation helpers shared by local training entry points."""

from __future__ import annotations

from pathlib import Path


class PrerequisiteError(RuntimeError):
    """Raised when a local experiment cannot be safely started."""


def resolve_from_config(config_path: Path, configured_path: str) -> Path:
    return (config_path.parent / configured_path).resolve()


def require_file(path: Path, description: str) -> None:
    if not path.is_file():
        raise PrerequisiteError(f"Missing {description}: {path}")


def validate_food101(root: Path, classes_file: str, train_list: str, test_list: str) -> int:
    """Check Food-101's official layout without reading all image pixels."""
    images = root / "images"
    require_file(root / classes_file, "Food-101 class list")
    require_file(root / train_list, "Food-101 official training split")
    require_file(root / test_list, "Food-101 official test split")
    if not images.is_dir():
        raise PrerequisiteError(f"Missing Food-101 images directory: {images}")

    classes = (root / classes_file).read_text(encoding="utf-8").splitlines()
    if len(classes) != 101:
        raise PrerequisiteError(
            f"Expected 101 Food-101 classes, found {len(classes)} in {root / classes_file}."
        )
    missing = [name for name in classes if not (images / name).is_dir()]
    if missing:
        raise PrerequisiteError(
            "Missing image folders for Food-101 classes: " + ", ".join(missing[:5])
        )
    return len(classes)
