# data_processor.py
from datasets import DatasetDict, load_dataset
from underthesea import word_tokenize
from transformers import AutoTokenizer
import yaml

with open("config.yaml") as f:
    config = yaml.safe_load(f)


class DataProcessor:
    def __init__(self, tokenizer_name="vinai/phobert-base"):
        self.tokenizer = AutoTokenizer.from_pretrained(tokenizer_name, use_fast=True)
        label_map = config["label_map"]
        self.label_mappings = {k: v for k, v in label_map.items()}

        self.data_paths = {
            "train": config["data_paths"]["train"],
            "validation": config["data_paths"]["validation"],
            "test": config["data_paths"]["test"]
        }

    def load_data(self):
        """Tải và xử lý dữ liệu thô từ các file"""
        dataset = load_dataset("text", data_files=self.data_paths)
        processed = {}
        
        for split in dataset:
            processed[split] = dataset[split].map(
                self._process_conll_format,
                batched=True,
                remove_columns=["text"]
            )
            
        return DatasetDict(processed)

    def _process_conll_format(self, examples):
        """Xử lý định dạng CONLL"""
        tokens, ner_tags = [], []
        current_tokens, current_tags = [], []
        
        for line in examples["text"]:
            line = line.strip()
            if line:
                parts = line.split()
                if len(parts) >= 2:
                    current_tokens.append(parts[0])
                    current_tags.append(parts[-1])
            elif current_tokens:
                tokens.append(current_tokens)
                ner_tags.append(current_tags)
                current_tokens, current_tags = [], []
        
        if current_tokens:
            tokens.append(current_tokens)
            ner_tags.append(current_tags)
            
        return {"tokens": tokens, "ner_tags": ner_tags}

    def preprocess(self, dataset):
        """Tiền xử lý dữ liệu cho mô hình"""
        return dataset.map(
            self._preprocess_batch,
            batched=True,
            remove_columns=["tokens", "ner_tags"]
        )

    def _preprocess_batch(self, examples):
        """Xử lý batch dữ liệu"""
        tokenized = self.tokenizer(
            examples["tokens"],
            truncation=True,
            padding="max_length",
            max_length=256,
            is_split_into_words=True
        )
        
        tokenized["labels"] = self._align_labels(examples["ner_tags"], tokenized)
        return tokenized

    def _align_labels(self, ner_tags, tokenized):
        """Căn chỉnh nhãn với subwords"""
        aligned_labels = []
        for i, tag_lists in enumerate(ner_tags):
            word_ids = tokenized.word_ids(batch_index=i)
            label_ids = []
            previous_word_idx = None
            
            for word_idx in word_ids:
                if word_idx is None:
                    label_ids.append(-100)
                elif word_idx != previous_word_idx:
                    label_ids.append(self.label_mappings[tag_lists[word_idx]])
                else:
                    label_ids.append(-100 if tag_lists[word_idx] == "O" else self.label_mappings[tag_lists[word_idx]])
                previous_word_idx = word_idx
                
            aligned_labels.append(label_ids)
            
        return aligned_labels
