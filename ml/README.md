# Calora Food Recognition Model

This directory isolates food-recognition research and model-serving assets from
the Flutter application. It is intentionally local-first and contains no cloud
deployment configuration, paid service setup, credentials, or trained model
weights.

## Current scope

The first model milestone is a reproducible **single dominant-food classifier**
baseline trained from Food-101. It is an evaluation baseline only: it cannot
identify several foods in one photo, estimate portion weight, or calculate
nutrition directly.

The production direction is a later food-object detector that returns one or
more food candidates and confidences. Calora will require the user to confirm
the food and grams; nutrition is then calculated from a verified food-database
record.

## Boundaries

- No training is started by this scaffold.
- No packages are installed automatically.
- No data is downloaded, uploaded, extracted, or copied by these files.
- No cloud provider, managed endpoint, or billable API is configured.
- The Flutter app remains unchanged by this model scaffold.

See `docs/` for audits, `training/` for the local training plan, and
`serving/` for the model-to-app contract.
