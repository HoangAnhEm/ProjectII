import torch
from transformers import AutoModelForTokenClassification, AutoTokenizer
from underthesea import word_tokenize

# Tải mô hình PhoBERT và tokenizer từ Hugging Face
MODEL_NAME = "vinai/phobert-base"
tokenizer = AutoTokenizer.from_pretrained(MODEL_NAME)
model = AutoModelForTokenClassification.from_pretrained(
    MODEL_NAME,
    num_labels=5,  # Số lượng nhãn (ví dụ: O, B-PERSON, I-PERSON, B-TASK, I-TASK)
    id2label={0: 'O', 1: 'B-PERSON', 2: 'I-PERSON', 3: 'B-TASK', 4: 'I-TASK'},
    label2id={'O': 0, 'B-PERSON': 1, 'I-PERSON': 2, 'B-TASK': 3, 'I-TASK': 4}
)

# Hàm xử lý văn bản đầu vào
def preprocess_text(text):
    """
    Tiền xử lý văn bản: tách từ tiếng Việt.
    """
    return word_tokenize(text, format="text")

# Hàm gán nhãn thực thể (NER)
def predict_ner(text):
    """
    Dự đoán nhãn thực thể cho từng token trong văn bản.
    """
    # Tiền xử lý văn bản (tách từ)
    segmented_text = preprocess_text(text)
    
    # Tokenize văn bản
    tokens = tokenizer.encode(segmented_text, return_tensors="pt")
    
    # Dự đoán nhãn BIO cho từng token
    with torch.no_grad():
        outputs = model(tokens)
        predictions = torch.argmax(outputs.logits, dim=2)  # Lấy nhãn có xác suất cao nhất
    
    # Chuyển đổi nhãn từ ID sang tên nhãn
    predicted_labels = [model.config.id2label[label_id] for label_id in predictions[0].tolist()]
    
    # Tách các token từ văn bản đã tiền xử lý
    tokens_list = segmented_text.split()
    
    # Kết hợp token với nhãn dự đoán
    ner_results = list(zip(tokens_list, predicted_labels))
    
    return ner_results

# Đoạn văn bản đầu vào cần gán nhãn
text_input = "Anh Nam được giao hoàn thành báo cáo tài chính trước ngày 25/03/2025."

# Gọi hàm dự đoán NER và hiển thị kết quả
ner_output = predict_ner(text_input)

print("Kết quả NER:")
for token, label in ner_output:
    print(f"{token}: {label}")
