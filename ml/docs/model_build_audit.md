# Model Build Audit

## Build status

**Status: scaffolded; training blocked by an explicit data-licensing gate.**

This repository now contains a local-first model-development foundation, not a
trained model. No Python packages were installed, no data was extracted or
copied, no model weights were downloaded, no training/evaluation process was
started, and no cloud or paid API was created.

## What was built

| Area | Asset | Purpose |
| --- | --- | --- |
| Dataset audit | `food101_dataset_audit.md` | Verifies the local archive and documents suitability, annotation requirements, governance, and licensing gates. |
| Classifier plan | `training/configs/food101_classifier.yaml` | Declares a reproducible ResNet-18 transfer-learning baseline for one dominant food. |
| Detection-data plan | `training/configs/multifood_detection_schema.yaml` | Defines the required COCO fields and meal-level split rules for a future multi-food detector. |
| Training scaffold | `training/` | Keeps manual, open-source local dependencies and scripts apart from Flutter. |
| Serving contract | `serving/openapi.yaml` and response schema | Defines typed, authenticated local API results for multiple food suggestions. |

## Architecture decision

The baseline is a pretrained image classifier for a **single dominant food**.
It accepts a corrected RGB image and produces 101 class scores, top-k
suggestions, and a low-confidence/manual-entry decision. It cannot return
multiple foods, location boxes, portion mass, calories, or macros.

The intended product model is a later transfer-learned multi-food detector.
For each visible food it will return a canonical label, display name,
confidence, normalized bounding box, and alternatives. The API contract
reserves `portion_grams` but requires it to be `null` in v1.

Nutrition is deliberately not learned from Food-101. The user confirms the
food and grams; Calora then scales a reviewed nutrition-database record.

## Audit findings

- Food-101 is structurally valid for a classifier baseline, but lacks boxes,
  masks, food weights, nutrition, and multi-food meal labels.
- Its licence requires a documented legal review before the selected training
  and deployment use proceeds. This is a hard gate, not a future cleanup item.
- Calora currently offers generic ML Kit image labels, not food-specific
  object detection. The serving contract bridges that gap without changing the
  Flutter code.
- The model endpoint is intentionally local-only in this scaffold. There is no
  vendor billing integration, object storage, server deployment, or paid
  vision/nutrition service.

## Next approval gate

Before any training command is run, approve all of the following:

1. Food-101 licence suitability for the intended use, or replacement with
   appropriately licensed training data.
2. A reviewed v1 food taxonomy and nutrition mapping policy.
3. The source, consent, and annotation process for Calora multi-food images.
4. Accuracy and low-confidence acceptance thresholds.
5. Developer-machine compute limits for the local, no-cloud training run.
