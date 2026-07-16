# Calora local food-model training scaffold

This directory is deliberately separate from the Flutter application. It is a
local, open-source training scaffold; it does not call cloud services, upload
images, create a billing resource, or contain credentials.

## Scope

The first experiment is a **single dominant-food classifier** fine-tuned from
a pretrained image model using Food-101. It establishes data loading,
evaluation, and confidence-threshold behaviour. It is not the production
multi-food scanner.

The later production experiment is a **multi-food object detector**. Its data
schema is documented in `configs/multifood_detection_schema.yaml`. Detector
training must wait until Calora meal photos have reviewed per-item annotations.

## Local-only prerequisites

Create a local Python environment outside this repository if desired, then
install the open-source dependencies listed in `requirements.txt`. Neither
environment creation nor installation is performed by this scaffold.

Food-101 is expected at the path in `configs/food101_classifier.yaml` by
default:

```text
data/raw/food101/food-101/
  images/<class_name>/*.jpg
  meta/classes.txt
  meta/train.txt
  meta/test.txt
```

`train.txt` and `test.txt` contain paths such as `apple_pie/1005649`, without
the `.jpg` extension. Do not randomly reshuffle these official split files.
Derive validation from training data with a fixed seed, while grouping related
captures together for any future Calora-owned data.

## Commands (not run automatically)

```bash
python src/train_classifier.py --config configs/food101_classifier.yaml --dry-run
python src/evaluate_classifier.py --config configs/food101_classifier.yaml --checkpoint path/to/model.pt
```

Both scripts first validate imports and the configured dataset. They exit with
actionable errors if prerequisites are missing. Actual training and evaluation
loops are intentionally not implemented in this initial scaffold so that no
model is accidentally trained or exported before the data and success criteria
are reviewed.

## Safety and privacy

- Keep raw user meal images out of version control.
- Store training data under `data/`, which is ignored by `ml/.gitignore`.
- Train only on locally available, licensed data with documented consent.
- Never put API keys, cloud endpoints, or billing credentials in this folder.

## Expected classifier contract

Input is an orientation-corrected RGB image, resized to `224 x 224` and
normalized with ImageNet statistics. Output is a vector of 101 class logits;
the serving layer later converts logits to top candidates and rejects a result
below the configured confidence threshold. Nutrition remains a separate,
user-confirmed USDA lookup based on the selected food and grams.

## Readiness gates

1. Validate Food-101 structure and class mapping.
2. Establish a baseline with top-1, top-3, calibration, and rejection metrics.
3. Define the smaller, reviewed Calora food taxonomy and USDA mappings.
4. Collect and annotate representative multi-food images.
5. Train and evaluate a detector using the documented schema.
6. Only after review, export a versioned model for a local or backend serving
   experiment.
