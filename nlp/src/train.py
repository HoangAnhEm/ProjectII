import yaml
from transformers import AutoModelForTokenClassification, TrainingArguments, Trainer
from transformers import AutoTokenizer
from preprocess import read_data


# Đọc cấu hình từ file config.yaml.
with open("config.yaml", "r", encoding="utf-8") as f:
    config = yaml.safe_load(f)

# Đọc dữ liệu.
train_sentences, train_labels = read_data(config["paths"]["data_raw"] + "train.txt")
valid_sentences, valid_labels = read_data(config["paths"]["data_raw"] + "valid.txt")
model_path = read_data(config["paths"]["model_fine_tuned"])

# Tải tokenizer và model 
tokenizer = AutoTokenizer.from_pretrained(model_path, local_files_only=True)
model = AutoModelForTokenClassification.from_pretrained(
    model_path,
    local_files_only=True,
    num_labels=len(config["labels"]),
    id2label={i: label for i, label in enumerate(config["labels"])},
    label2id={label: i for i, label in enumerate(config["labels"])}
)

# Chuẩn bị dataset.
from dataset import NERDataset

train_dataset = NERDataset(train_sentences, train_labels, tokenizer, model.config.label2id)
valid_dataset = NERDataset(valid_sentences, valid_labels, tokenizer, model.config.label2id)

# Cấu hình tham số huấn luyện.
training_args = TrainingArguments(
    output_dir=config["paths"]["model_fine_tuned"],
    eval_strategy="epoch",  # Sửa từ evaluation_strategy thành eval_strategy
    learning_rate=float(config["training"]["learning_rate"]),
    per_device_train_batch_size=config["training"]["batch_size"],
    per_device_eval_batch_size=config["training"]["batch_size"],
    num_train_epochs=config["training"]["num_epochs"],
)


# Huấn luyện mô hình.
trainer = Trainer(
    model=model,
    args=training_args,
    train_dataset=train_dataset,
    eval_dataset=valid_dataset,
    data_collator=data_collator,  # Thay thế tokenizer
)


trainer.train()
