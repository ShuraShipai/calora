# Food-101 Dataset Audit

**Scope:** Read-only assessment of the locally downloaded Food-101 archive for
Calora food-recognition research. No archive contents were extracted, no model
was trained, and no services were used.

## Local archive verification

| Check | Result |
| --- | --- |
| Archive path | `/Users/shurashipai/Downloads/food101/food-101.tar.gz` |
| Observed size | 4.7 GB (filesystem display) |
| Readability check | `tar -tzf` completed successfully |
| Archive entries listed | 101,112 |
| Extracted to repository | No |

The successful full archive listing is a practical gzip/tar integrity check.
It confirms that the archive can be read end-to-end, but it does not validate
every decoded image. Image-level validation belongs in the later, explicitly
approved data-preparation stage.

## Expected archive structure

The archive root is `food-101/` and includes:

```text
food-101/
  images/
    <class_name>/
      <image_id>.jpg
  meta/
    classes.txt
    labels.txt
    train.txt
    test.txt
    train.json
    test.json
  README.txt
  license_agreement.txt
```

Images are arranged into 101 class directories. The supplied metadata provides
the dataset's official train/test split. The archive is appropriate for a
single-image, single-label classification baseline after an approved
preparation step.

## Suitability for Calora

### Suitable uses

- Fine-tuning or evaluating a pretrained image classifier for clear,
  single-dominant-food images.
- Establishing a reproducible training pipeline and confidence-rejection
  baseline.
- Providing broad initial visual classes for research, subject to label review.

### Not supplied by Food-101

- Bounding boxes for separate foods in a meal photograph.
- Pixel masks for overlapping foods.
- Per-item serving mass, calories, or macro nutrients.
- Recipe, ingredient, cooking-method, or brand details needed for reliable
  nutrition selection.
- Realistic multi-food meal annotations or Calora-user distribution coverage.

Therefore Food-101 alone must **not** be used to claim multi-food detection,
automatic portion estimation, or exact calorie/macronutrient prediction.

## Production data requirements

Calora's first multi-food model requires a separate, consented and reviewed
dataset. Keep raw, prepared, and annotation data outside Flutter application
source folders, with immutable source IDs and dataset-version manifests.

Recommended canonical layout after preparation approval:

```text
ml/data/
  raw/<dataset-version>/
  prepared/<dataset-version>/images/{train,val,test}/
  prepared/<dataset-version>/labels/{train,val,test}/
  manifests/<dataset-version>.json
  taxonomy/food_taxonomy.csv
```

For object detection, each visible food needs at minimum:

- Stable image ID and split (`train`, `val`, or `test`).
- Canonical food class ID and user-facing display name.
- One normalized bounding box per food item (`class x_center y_center width height`)
  in YOLO format, or equivalent COCO JSON annotations.
- Annotation-review status and annotator/review identifiers.
- Capture/session ID to prevent photos of the same meal from crossing splits.

For future segmentation, add one polygon or mask per food item in COCO format.
For future portion research, add independently measured grams per item, meal
recipe details where available, and capture metadata. Never infer these labels
from the Food-101 class alone.

## Taxonomy and nutrition mapping

Maintain a reviewed mapping separate from model weights:

| Field | Purpose |
| --- | --- |
| `model_class_id` | Stable training/detection class |
| `display_name` | Name shown to the user |
| `canonical_food_id` | Internal food identity |
| `usda_search_term` | Controlled lookup phrase |
| `verified_fdc_id` | Reviewed nutrition record, when available |
| `status` | supported, ambiguous, or unsupported |

The model returns candidate food labels and confidence only. Calories and
macros must come from a reviewed nutrition record scaled by the user's
confirmed grams; the user can edit both food choice and quantity before saving.

## Data governance and licensing

The archive's `license_agreement.txt` states that Food-101 images originate
from Foodspotting and are not ETH Zurich property. It says use beyond
scientific fair use must be negotiated with the respective image owners under
the Foodspotting terms. Before model training, deployment, redistribution,
or commercial use, obtain a legal/licensing review and record the decision in
the dataset manifest.

For Calora-collected images:

- Obtain explicit, informed opt-in for training use; photo upload consent is
  not automatically training consent.
- Minimize collection and strip unnecessary identifiers/metadata.
- Define retention, deletion, access-control, and withdrawal procedures.
- Do not add user corrections to training data until they are reviewed.
- Maintain provenance, consent status, annotation history, and dataset/model
  version links for each included image.

## Gate before any model work

Do not begin training until all gates are met:

1. Licensing approval for the selected data and intended use.
2. A reviewed v1 taxonomy and nutrition mapping policy.
3. A documented source, consent, and annotation process for multi-food data.
4. Meal/session-level train/validation/test split rules.
5. Defined acceptance metrics, including low-confidence rejection and
   per-class performance—not only overall accuracy.

