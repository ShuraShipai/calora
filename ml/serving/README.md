# Calora food-recognition serving contract

This directory specifies the boundary between a future food-detection model and
Calora. It is documentation and schemas only: there is no server, model,
deployment configuration, dependency, or billable integration here.

## Proposed local development shape

An optional FastAPI server may later implement `openapi.yaml` on
`http://127.0.0.1:8000`. It should accept one image, validate it before decode,
run a local detector, and return JSON conforming to
`food_recognition_response.schema.json`. The app must retain its manual-entry
fallback when the server returns an error or no results.

This is deliberately not a run instruction: implementing it requires a later,
explicit decision on Python version, dependencies, model runtime, and local
hardware support.

## Contract decisions

- The model returns multiple detected food suggestions, normalized bounding
  boxes, confidence, and up to five alternatives for each detection.
- `label` is a stable Calora taxonomy ID. It is not a USDA/FDC ID and has no
  nutrition attached to it.
- `portion_grams` is `null` in v1. The user must choose or edit grams before
  nutrition is looked up and a diary entry is saved.
- An empty `items` array is a valid successful result. The client must never
  create a food entry automatically from a model response.
- Confidence is recognition confidence, not calorie or macro confidence.

## Privacy, authentication, and retention boundary

The eventual endpoint must require a verified app-user token, enforce request
size/type/pixel limits and rate limits, and return generic errors that do not
expose infrastructure details. It must not log image contents, raw tokens,
or user identifiers. Images should be processed in memory and discarded after
the response unless a user explicitly opts into a separately designed,
documented feedback programme. Any stored feedback needs deletion support,
access controls, a retention period, and human review before training use.

## No-billing boundary

The planned first implementation is local-only and must use no managed
inference endpoint, object storage, third-party vision API, paid nutrition API,
or automatic cloud deployment. Running a local FastAPI process and an
open-source model later can still consume the developer's own compute, but
creates no vendor billing integration. Cloud serving is a later product
decision requiring explicit cost, privacy, quota, and user-consent review.

## Audit: current integration position

The current scanner uses `MlKitMealLabelSuggestionService`, which performs
generic on-device image labeling and returns only label/confidence pairs. It
has no food taxonomy, multiple-object geometry, candidates, model version,
or model-serving API. The contract above supplies those missing data fields
without changing the Flutter app. Nutrition and diary persistence remain
downstream, after the person has corrected the food and portion.

## Files

- `openapi.yaml` — API request/response, error, auth, and normalized-box rules.
- `food_recognition_response.schema.json` — standalone response validator for
  fixtures and a future server.
