import torch


class NERDataset:
    def __init__(self, sentences, labels, tokenizer, label2id, max_length=256):
        self.sentences = sentences
        self.labels = labels
        self.tokenizer = tokenizer
        self.label2id = label2id
        self.max_length = max_length

    def __len__(self):
        return len(self.sentences)

    def __getitem__(self, idx):
        tokens = self.sentences[idx]
        tags = self.labels[idx]

        # Tokenize từng từ
        tokenized_inputs = self.tokenizer(
            tokens,
            truncation=True,
            is_split_into_words=True,
            padding="max_length",
            max_length=self.max_length,
            return_tensors="pt"
        )

        # Ánh xạ nhãn thực thể với các token
        word_ids = tokenized_inputs.word_ids(batch_index=0)  # Lấy word_ids để ánh xạ từ gốc với token
        label_ids = []
        previous_word_idx = None

        for word_idx in word_ids:
            if word_idx is None:  # Padding hoặc special tokens ([CLS], [SEP])
                label_ids.append(-100)
            elif word_idx != previous_word_idx:  # Token đầu tiên của một từ mới
                label_ids.append(self.label2id[tags[word_idx]])
            else:  # Subword tokens của từ hiện tại
                label_ids.append(-100)  # Gán -100 để bỏ qua khi tính loss

            previous_word_idx = word_idx

        tokenized_inputs["labels"] = torch.tensor(label_ids)

        return {key: val.squeeze(0) for key, val in tokenized_inputs.items()}
