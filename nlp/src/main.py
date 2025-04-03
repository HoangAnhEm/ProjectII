from extract_tasks import extract_tasks_from_text

def main():
    # Đọc biên bản họp từ file
    with open("data/sample_meeting.txt", "r", encoding="utf-8") as f:
        meeting_text = f.read()

    # Xử lý văn bản với PhoBERT
    processed_text = process_meeting_text(meeting_text)

    # Trích xuất danh sách nhiệm vụ từ văn bản đã xử lý
    tasks = extract_tasks_from_text(processed_text)

    # Hiển thị kết quả
    print("Danh sách nhiệm vụ được trích xuất:")
    for task in tasks:
        print(task)

    # Lưu kết quả vào file JSON (nếu cần)
    with open("data/processed_tasks.json", "w", encoding="utf-8") as f:
        import json
        json.dump(tasks, f, ensure_ascii=False, indent=4)

if __name__ == "__main__":
    main()
