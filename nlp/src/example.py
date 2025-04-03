from transformers import AutoModelForTokenClassification, AutoTokenizer

model_path = "./model/fine_tuned"  
model = AutoModelForTokenClassification.from_pretrained(model_path, local_files_only=True)
tokenizer = AutoTokenizer.from_pretrained(model_path, local_files_only=True)

import torch
from underthesea import word_tokenize

def predict_ner(text, model, tokenizer):
    # Phân đoạn từ
    words = word_tokenize(text)
    inputs = tokenizer(" ".join(words), return_tensors="pt", truncation=True)
    
    # Dự đoán
    with torch.no_grad():
        outputs = model(**inputs)
        predictions = torch.argmax(outputs.logits, dim=2)
    
    # Xử lý kết quả
    tokens = tokenizer.convert_ids_to_tokens(inputs["input_ids"][0])
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

# Sử dụng hàm dự đoán
sample_text = "Chị Hương là giám đốc công ty XYZ tại Hà Nội"
entities = predict_ner(sample_text, model, tokenizer)
print(f"Thực thể người được nhận diện: {entities}")
