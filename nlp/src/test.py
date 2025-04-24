from phoBert import PhoBertNER

ner_model = PhoBertNER()

text = "Anh Tuấn cần hoàn thành báo cáo trước 15/3"
results = ner_model.predict(text)

for ent in results:
    print(f"{ent['entity']} ({ent['type']})")