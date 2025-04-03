import torch
from transformers import AutoModelForTokenClassification, AutoTokenizer
from transformers import TrainingArguments, Trainer
from datasets import load_dataset
from underthesea import word_tokenize

# Tải mô hình PhoBERT
tokenizer = AutoTokenizer.from_pretrained("vinai/phobert-base", use_fast=True)
model = AutoModelForTokenClassification.from_pretrained(
    "vinai/phobert-base", 
    num_labels=9,
    id2label={
        0: "O",
        1: "B-PER",
        2: "I-PER",
        3: "B-ORG",
        4: "I-ORG",
        5: "B-LOC",
        6: "I-LOC",
        7: "B-MISC",
        8: "I-MISC"
    },
    label2id={
        "O": 0,
        "B-PER": 1,
        "I-PER": 2,
        "B-ORG": 3,
        "I-ORG": 4,
        "B-LOC": 5,
        "I-LOC": 6,
        "B-MISC": 7,
        "I-MISC": 8
    }
)



# Tải dữ liệu (giả sử bạn đã có dữ liệu ở định dạng phù hợp)
dataset = load_dataset("text", data_files={
    "train": "./data/raw/train.txt",
    "validation": "./data/raw/valid.txt",
    "test": "./data/raw/test.txt"
})

def process_conll_format(examples):
    tokens = []
    ner_tags = []
    
    current_tokens = []
    current_tags = []
    
    for line in examples["text"]:
        line = line.strip()
        if line:
            parts = line.split()
            if len(parts) >= 2:  # Đảm bảo có ít nhất từ và nhãn
                token, tag = parts[0], parts[-1]  # Lấy từ đầu tiên và nhãn cuối cùng
                current_tokens.append(token)
                current_tags.append(tag)
        elif current_tokens:  # Dòng trống đánh dấu kết thúc câu
            tokens.append(current_tokens)
            ner_tags.append(current_tags)
            current_tokens = []
            current_tags = []
    
    # Thêm câu cuối cùng nếu có
    if current_tokens:
        tokens.append(current_tokens)
        ner_tags.append(current_tags)
    
    return {"tokens": tokens, "ner_tags": ner_tags}

# Áp dụng xử lý cho mỗi phân vùng
processed_dataset = {}
for split in dataset:
    processed_dataset[split] = dataset[split].map(
        process_conll_format, 
        batched=True, 
        remove_columns=["text"]
    )

# Tạo DatasetDict từ các phân vùng đã xử lý
from datasets import DatasetDict
final_dataset = DatasetDict(processed_dataset)

# Tiền xử lý dữ liệu
def preprocess_data(examples):
    # Tokenize các câu
    tokenized_inputs = tokenizer(
        [" ".join(tokens) for tokens in examples["tokens"]],
        truncation=True,
        padding="max_length",
        max_length=256
    )
    
    # Chuyển đổi nhãn thành ID
    label_to_id = {
        "O": 0,
        "B-PER": 1,
        "I-PER": 2,
        "B-ORG": 3,
        "I-ORG": 4,
        "B-LOC": 5,
        "I-LOC": 6,
        "B-MISC": 7,
        "I-MISC": 8
    }
    
    # Xử lý nhãn
    labels = []
    for i, (input_ids, tag_list) in enumerate(zip(tokenized_inputs["input_ids"], examples["ner_tags"])):
        # Chuyển đổi nhãn văn bản thành ID
        tag_ids = [label_to_id.get(tag, 0) for tag in tag_list]
        
        # Đảm bảo độ dài của nhãn bằng với độ dài của input_ids
        # Thêm nhãn 0 (O) cho các token đặc biệt và padding
        if len(tag_ids) < len(input_ids):
            tag_ids = [0] + tag_ids + [0] * (len(input_ids) - len(tag_ids) - 1)
        else:
            tag_ids = [0] + tag_ids[:len(input_ids)-2] + [0]
            
        labels.append(tag_ids)
    
    tokenized_inputs["labels"] = labels
    
    return tokenized_inputs




tokenized_dataset = final_dataset.map(preprocess_data, batched=True)

# Thiết lập tham số huấn luyện
training_args = TrainingArguments(
    output_dir="./phobert-ner",
    evaluation_strategy="epoch",
    learning_rate=1e-5,
    per_device_train_batch_size=32,
    per_device_eval_batch_size=32,
    num_train_epochs=3,
    weight_decay=0.01,
)

# Khởi tạo Trainer
trainer = Trainer(
    model=model,
    args=training_args,
    train_dataset=tokenized_dataset["train"],
    eval_dataset=tokenized_dataset["validation"],
    tokenizer=tokenizer,
)

# Fine-tune mô hình
trainer.train()

# Lưu mô hình đã fine-tune
model.save_pretrained("./model/fine_tuned")
tokenizer.save_pretrained("./model/fine_tuned")


# Đánh giá mô hình
results = trainer.evaluate()
print(results)

# Sử dụng mô hình để dự đoán
def predict_ner(text):
    # Phân đoạn từ
    words = word_tokenize(text)
    inputs = tokenizer(" ".join(words), return_tensors="pt", truncation=True)
    
    # Dự đoán
    with torch.no_grad():
        outputs = model(**inputs)
        predictions = torch.argmax(outputs.logits, dim=2)
    
    # Xử lý kết quả
    predicted_labels = [model.config.id2label[t.item()] for t in predictions[0]]
    
    # Trích xuất thực thể người
    entities = []
    current_entity = ""
    
    for word, label in zip(words, predicted_labels[:len(words)]):
        if label == "B-PER":
            if current_entity:
                entities.append(current_entity.strip())
            current_entity = word
        elif label == "I-PER" and current_entity:
            current_entity += " " + word
        elif current_entity:
            entities.append(current_entity.strip())
            current_entity = ""
    
    if current_entity:
        entities.append(current_entity.strip())
    
    return entities

# Thử nghiệm
sample_text = "Ông Nguyễn Văn A là giám đốc công ty XYZ tại Hà Nội"
entities = predict_ner(sample_text)
print(f"Thực thể người được nhận diện: {entities}")
