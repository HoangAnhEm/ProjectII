import torch
from transformers import (
    AutoModelForTokenClassification,
    AutoTokenizer,
    TrainingArguments,
    Trainer
)
from datasets import DatasetDict, load_dataset
from underthesea import word_tokenize
from seqeval.metrics import classification_report
import numpy as np
from dataset import DataProcessor
import yaml

with open("config.yaml") as f:
    config = yaml.safe_load(f)


class PhoBertNER:
    def __init__(self, model_name="vinai/phobert-base", num_labels=7):
        label_map = config["label_map"]
        self.device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
        self.tokenizer = AutoTokenizer.from_pretrained(model_name, use_fast=True)
        self.label_map = {k: v for k, v in label_map.items()}
        self.model = self._init_model(model_name, num_labels)
        self.processor = DataProcessor()
        
    def _init_model(self, model_name, num_labels):
        return AutoModelForTokenClassification.from_pretrained(
            model_name,
            num_labels=num_labels,
            id2label={v: k for k, v in self.label_map.items()},
            label2id=self.label_map
        ).to(self.device)

    def train(self):
        """Huấn luyện mô hình"""
        # Tải và tiền xử lý dữ liệu
        dataset = self.processor.load_data()
        tokenized_ds = self.processor.preprocess(dataset)
        
        # Thiết lập tham số huấn luyện
        args = TrainingArguments(
            output_dir=config["training"]["output_dir"],
            evaluation_strategy=config["training"]["evaluation_strategy"],
            learning_rate=config["training"]["learning_rate"],
            per_device_train_batch_size=config["training"]["per_device_train_batch_size"],
            per_device_eval_batch_size=config["training"]["per_device_eval_batch_size"],
            num_train_epochs=config["training"]["num_train_epochs"],
            weight_decay=config["training"]["weight_decay"]
        )
        
        # Khởi tạo Trainer
        trainer = Trainer(
            model=self.model,
            args=args,
            train_dataset=tokenized_ds["train"],
            eval_dataset=tokenized_ds["validation"],
            tokenizer=self.tokenizer,
            compute_metrics=self._compute_metrics
        )
        
        # Bắt đầu huấn luyện
        trainer.train()
        
        # Lưu mô hình
        self.model.save_pretrained(config["model_paths"]["fine_tuned"])
        self.tokenizer.save_pretrained(config["model_paths"]["fine_tuned"])

    def _compute_metrics(self, p):
        """Tính toán metrics đánh giá"""
        predictions, labels = p
        predictions = np.argmax(predictions, axis=2)

        true_predictions = [
            [self.model.config.id2label[p] for (p, l) in zip(pred, label) if l != -100]
            for pred, label in zip(predictions, labels)
        ]

        true_labels = [
            [self.model.config.id2label[l] for l in label if l != -100]
            for label in labels
        ]

        return classification_report(true_labels, true_predictions, output_dict=True)

    def evaluate(self):
        """Đánh giá mô hình trên tập test"""
        test_data = self.processor.load_data()
        tokenized_test = self.processor.preprocess(test_data)
        
        trainer = Trainer(
            model=self.model,
            eval_dataset=tokenized_test["test"],
            compute_metrics=self._compute_metrics
        )
        
        results = trainer.evaluate()
        print("Evaluation results:")
        for k, v in results.items():
            print(f"{k}: {v}")
        return results

    def predict(self, text):
        """Dự đoán thực thể từ văn bản"""
        words = word_tokenize(text)
        inputs = self.tokenizer(
            words,
            return_tensors="pt",
            truncation=True,
            padding="max_length",
            max_length=256,
            is_split_into_words=True
        ).to(self.device)
        
        with torch.no_grad():
            outputs = self.model(**inputs)
        
        predictions = torch.argmax(outputs.logits, dim=2)[0].cpu().numpy()
        word_ids = inputs.word_ids()

        entities = []
        current_entity = {"text": [], "label": None}
        for idx, word_id in enumerate(word_ids):
            if word_id is None:
                continue
                
            label = self.model.config.id2label[predictions[idx]]
            
            if label.startswith("B-"):
                if current_entity["text"]:
                    entities.append(current_entity)
                current_entity = {
                    "text": [words[word_id]],
                    "label": label[2:],
                    "start": idx,
                    "end": idx
                }
            elif label.startswith("I-") and current_entity["text"]:
                if label[2:] == current_entity["label"]:
                    current_entity["text"].append(words[word_id])
                    current_entity["end"] = idx
            else:
                if current_entity["text"]:
                    entities.append(current_entity)
                    current_entity = {"text": [], "label": None}
        
        if current_entity["text"]:
            entities.append(current_entity)
            
        # Format kết quả
        return [
            {
                "entity": " ".join(ent["text"]),
                "type": ent["label"],
                "positions": (ent["start"], ent["end"])
            }
            for ent in entities if ent["label"] is not None
        ]
