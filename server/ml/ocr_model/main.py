from transformers import TrOCRProcessor, VisionEncoderDecoderModel
from data.dataset_loader import Dataset_Loader
from config.settings import OCRConfig
from data.dataset import OCRDataset
from data.preprocessing import Preprocessing
from model.trocr_model import TrOCRModel
from model.trainer import OCRTrainer
from evaluation.evaluator import ModelEvaluator
from inference.predictor import OCRPredictor
from server.ml.ocr_model.evaluation.metrics import OCRMatrix

if __name__ == "__main__":

    __title__ = "TrOCR"
    __version__ = "1.0.0"

    config = OCRConfig()

    dl = Dataset_Loader()
    file_exract = dl.extract_file(config.PROJECT_ROOT, config.PROJECT_ROOT)

    train_csv_files = dl.verify_csv(config.TRAINING_DIR)
    train_img_files = dl.verify_img(config.TRAINING_DIR)

    val_csv_files = dl.verify_csv(config.TRAINING_DIR)
    val_img_files = dl.verify_img(config.TRAINING_DIR)

    dp = Preprocessing()

    train_df = dp.load_files(train_csv_files, train_img_files)
    train_df_info = dp.display_dataset_info(train_df)
    print(train_df_info)
    train_df_explore = dp.display_dataset_explore(train_df)
    print(train_df_explore)
    train_convert_hf = dp.to_hf(train_df)

    val_df = dp.load_files(val_csv_files, val_img_files)
    val_df_info = dp.display_dataset_info(train_df)
    print(val_df_info)
    val_df_explore = dp.display_dataset_explore(val_df)
    print(val_df_explore)
    val_convert_hf = dp.to_hf(val_df)

    processor = TrOCRProcessor.from_pretrained(config.BASE_MODEL, use_fast=True)
    model = VisionEncoderDecoderModel.from_pretrained(
        config.BASE_MODEL,
        use_fast=True,
        use_auth_token=True,
    )

    tune_model = TrOCRModel(processor, model, config)
    config_tune_model = tune_model.setup_model(config)

    train_data = OCRDataset(train_convert_hf, processor)
    validation_data = OCRDataset(val_convert_hf, processor)

    trainer = OCRTrainer(model, config, train_data, validation_data)
    preds = trainer.get_preds()
    refs = trainer.get_refs()
    trained_model = trainer.train()
    trainer.save_model()

    predictor = OCRPredictor(trained_model, processor, config)

    evaluate = ModelEvaluator(config, predictor)
    test_data = evaluate.verify_dataset()
    result_df = evaluate.load_dataset(test_data, preds, refs)

    matrix = OCRMatrix()
    cm_matrix = matrix.compute_matrices(preds, refs)
    print(cm_matrix)
    gen_acc = matrix.generate_accuracy(result_df)
    print(gen_acc)
    get_common_err = matrix.get_common_errors(result_df)
    print(get_common_err)
    visualize_evaluation = matrix.matrix_visualization(test_data, preds)
