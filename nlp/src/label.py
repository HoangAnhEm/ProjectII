with open('./data/noLabel/task/ENTMQMAAS-2xxxx.txt', 'r', encoding='utf-8') as f:
    lines = f.readlines()

with open('./data/raw/valid.txt', 'w', encoding='utf-8') as out:
    for line in lines:
        tokens = line.strip().split()
        for i, token in enumerate(tokens):
            label = 'B-TASK' if i == 0 else 'I-TASK'
            out.write(f"{token} {label}\n")
        out.write("\n") 
