# Prescription Handwriting OCR — Training Notebooks

These notebooks train a handwriting OCR model for the prescription-upload feature of Medicare+. They run on **Google Colab** with a free T4 GPU.

## Pipeline

```
01_data_prep.ipynb     →   02_train_trocr.ipynb   →   03_evaluate.ipynb
download Kaggle data,     fine-tune TrOCR on the      compute CER/WER, top-K,
explore, split,           prepared splits, save to    confusion analysis,
save HF DatasetDict       Drive + zip download        baseline comparison
```

## What gets trained

A fine-tuned [`microsoft/trocr-base-handwritten`](https://huggingface.co/microsoft/trocr-base-handwritten) (encoder-decoder Transformer for image-to-text) on the Kaggle [`mamun1113/doctors-handwritten-prescription-bd-dataset`](https://www.kaggle.com/datasets/mamun1113/doctors-handwritten-prescription-bd-dataset) (~4,700 cropped drug-name images).

## What you need before starting

| Requirement | How to get it |
|---|---|
| Google account | sign in to Google Drive on Colab |
| Kaggle account + API token | https://www.kaggle.com/settings → "Create New API Token" → downloads `kaggle.json` |
| Colab GPU runtime | Runtime → Change runtime type → T4 GPU |
| ~5 GB free in Google Drive | for the dataset + trained model |

## Running

1. Open [01_data_prep.ipynb](01_data_prep.ipynb) in Colab, run all cells top-to-bottom (uploads `kaggle.json` when prompted).
2. Open [02_train_trocr.ipynb](02_train_trocr.ipynb), run all cells. Expect 1–3 hours.
3. Open [03_evaluate.ipynb](03_evaluate.ipynb), run all cells. Produces the numbers and charts for your report.

Each notebook starts by mounting Drive and reusing artifacts from the previous one, so they're chained.

## Outputs (all saved under `/content/drive/MyDrive/medicare_plus_ocr/`)

```
medicare_plus_ocr/
├── data/
│   ├── raw/                    # extracted Kaggle zip
│   └── prepared/               # HF DatasetDict (train/val/test)
├── models/
│   └── trocr-prescription/     # final fine-tuned model (~400 MB)
├── logs/
│   └── checkpoints/            # training intermediate checkpoints
└── reports/
    ├── test_predictions.csv    # all test predictions
    └── summary.json            # CER/WER/top-K/before-vs-after numbers
```

The training notebook also downloads `trocr-prescription.zip` to your local machine at the end.

## Using the trained model in the backend

Once you have the zip:

1. Unzip it into `server/models/trocr-prescription/` in the repo (already gitignored).
2. Set the env var `PRESCRIPTION_MODEL_PATH=server/models/trocr-prescription` in your `.env` file when the backend pipeline is wired up.

The backend OCR pipeline (built later, in a separate task) will pick this up automatically; if the env var is unset, it falls back to the base pretrained TrOCR.

## Realistic expectations

The Kaggle dataset has cropped, single-word drug-name images, not full prescription sheets. So:

- **What the trained model will be good at:** recognizing one drug name per cropped image.
- **What it will not be good at out of the box:** finding drug names inside a full-page photo (that's what text detection in the backend pipeline is for).
- **Likely numbers after 10 epochs of fine-tuning** (your mileage will vary):
  - Test CER: 0.08 – 0.20
  - Exact-match accuracy: 60 – 80%
  - Top-5 accuracy: 75 – 90%

These are *good* numbers for this problem — even commercial doctor-handwriting OCR products struggle here. Document the limitations honestly in your report; that's a strength of the project, not a weakness.

## Troubleshooting

- **`Kaggle 401 Unauthorized`** — your `kaggle.json` token has expired. Regenerate it on Kaggle settings and re-upload.
- **`CUDA out of memory`** — reduce `BATCH_SIZE` in notebook 2 from 8 to 4 (or 2).
- **Training looks stuck** — check the `logging_steps=50` output. The first epoch is slow because data is loaded from Drive; subsequent epochs are faster.
- **Drive disconnects mid-training** — the trainer saves a checkpoint each epoch; resume by re-running notebook 2 (it will load `load_best_model_at_end=True` from the latest checkpoint if you point `output_dir` to the same place).
