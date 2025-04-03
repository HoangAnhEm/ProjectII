import torch

def extract_tasks_from_text(text_embeddings):
    """
    In ra các thông tin của văn bản đã được xử lý bởi PhoBERT.
    
    Args:
        text_embeddings: Các embedding của văn bản đã được xử lý bởi PhoBERT.

    Returns:
        None
    """
    print("Thông tin về các embedding:")
    print("Kích thước của tensor:", text_embeddings.shape)
    print("Loại dữ liệu:", type(text_embeddings))
    
    # In ra các giá trị của tensor
    print("Giá trị của tensor:")
    print(text_embeddings)
    
    # Nếu muốn in ra từng giá trị một cách chi tiết
    for i, embedding in enumerate(text_embeddings):
        print(f"Embedding thứ {i+1}:")
        print(embedding)