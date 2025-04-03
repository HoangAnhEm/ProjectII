import os

def read_data(file_path):
    """
    Đọc dữ liệu từ file định dạng BIO.
    """
    sentences = []
    labels = []
    with open(file_path, "r", encoding="utf-8") as f:
        sentence = []
        label = []
        for line in f:
            line = line.strip()
            if not line:  # Nếu gặp dòng trống, kết thúc câu hiện tại.
                if sentence:
                    sentences.append(sentence)
                    labels.append(label)
                    sentence = []
                    label = []
            else:
                token, tag = line.split()
                sentence.append(token)
                label.append(tag)

        if sentence:  # Thêm câu cuối cùng nếu có.
            sentences.append(sentence)
            labels.append(label)

    return sentences, labels


