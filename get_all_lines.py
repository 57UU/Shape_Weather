import os

def count_lines_in_directory(directory):
    total_lines = 0
    for root, dirs, files in os.walk(directory):
        for file in files:
            total_lines += count_lines_in_file(os.path.join(root, file))
    return total_lines

def count_lines_in_file(file_path):
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            return sum(1 for line in f)
    except Exception as e:
        print(f"无法读取文件 {file_path}：{e}")
        return 0

directory = 'lib'
total_lines = count_lines_in_directory(directory)
print(f"directory '{directory}' :all files： {total_lines} lines")

input("Press Enter to Continue...")
