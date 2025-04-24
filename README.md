# Project II

Hệ thống trích xuất thông tin từ văn bản sử dụng công nghệ NLP kết hợp ứng dụng Web, giúp tự động nhận diện và tổ chức công việc từ biên bản họp hoặc tài liệu tiếng Việt.

## Tổng quan hệ thống

Dự án gồm ba thành phần chính:
- **Frontend (app/client):** Ứng dụng Flutter sử dụng RiverPod để quản lý state, cung cấp giao diện người dùng hiện đại, đa nền tảng (web, desktop, mobile). Người dùng có thể đăng nhập, quản lý workspace, project, task, tải lên văn bản và nhận kết quả trích xuất.
- **Backend (app/server):** API server xây dựng bằng Node.js, sử dụng MongoDB để lưu trữ dữ liệu. Backend chịu trách nhiệm xác thực, phân quyền, quản lý người dùng, workspace, project, task và giao tiếp với module NLP.
- **NLP module (nlp):** Xử lý tiếng Việt sử dụng mô hình PhoBert để nhận diện thực thể, kết hợp underthesea để tách từ. NLP module triển khai API bằng Python (FastAPI), nhận văn bản từ backend và trả về danh sách công việc đã trích xuất.

---

## Thành phần

### 1. Ứng dụng (app)

#### Frontend (client)
- **Công nghệ:** Flutter
- **Quản lý State:** RiverPod
- **Chức năng:** Giao diện người dùng cho việc tải lên và xử lý văn bản, hiển thị kết quả trích xuất.

##### Cấu trúc thư mục và design:
<pre>
server/
├── .husky/
├── bin/
├── node_modules/
└── src/
├── config/ # Cấu hình hệ thống, kết nối DB, biến môi trường
├── controllers/ # Xử lý logic cho các route
├── docs/ # Tài liệu API
├── middlewares/ # Xử lý trung gian (auth, log, validate)
├── models/ # Định nghĩa schema dữ liệu (Mongoose)
│ ├── plugins/
│ ├── project.model.js
│ ├── task.model.js
│ ├── token.model.js
│ ├── user.model.js
│ └── workspace.model.js
├── routes/ # Định tuyến API
├── services/ # Logic nghiệp vụ, giao tiếp ngoài
├── utils/ # Tiện ích dùng chung
├── validations/ # Kiểm tra dữ liệu đầu vào
├── app.js # Khởi tạo ứng dụng
└── index.js # Điểm chạy chính
</pre>
- **Design:** Ứng dụng xây dựng theo hướng modular, tách biệt rõ các tầng giao diện, logic, dữ liệu. Hỗ trợ responsive cho nhiều nền tảng. Sử dụng RiverPod để quản lý state toàn cục, đảm bảo hiệu năng và dễ bảo trì.

#### Backend (server)
- **Công nghệ:** Node.js
- **Cơ sở dữ liệu:** MongoDB
- **Chức năng:** API quản lý người dùng, lưu trữ văn bản và kết quả phân tích.

##### Cấu trúc thư mục (MVC):
<pre>
server/
├── .husky/
├── bin/
├── node_modules/
└── src/
├── config/ # Cấu hình hệ thống, kết nối DB, biến môi trường
├── controllers/ # Xử lý logic cho các route
├── docs/ # Tài liệu API
├── middlewares/ # Xử lý trung gian (auth, log, validate)
├── models/ # Định nghĩa schema dữ liệu (Mongoose)
│ ├── plugins/
│ ├── project.model.js
│ ├── task.model.js
│ ├── token.model.js
│ ├── user.model.js
│ └── workspace.model.js
├── routes/ # Định tuyến API
├── services/ # Logic nghiệp vụ, giao tiếp ngoài
├── utils/ # Tiện ích dùng chung
├── validations/ # Kiểm tra dữ liệu đầu vào
├── app.js # Khởi tạo ứng dụng
└── index.js # Điểm chạy chính
</pre>

##### Mô hình dữ liệu và phân cấp quản lý:
- **Workspace:** Không gian làm việc cho nhóm/tổ chức, chứa nhiều project, mỗi workspace có danh sách thành viên riêng.
- **Project:** Thuộc về một workspace, quản lý các mục tiêu cụ thể, chứa nhiều task và thành viên.
- **Task:** Đơn vị công việc nhỏ nhất, thuộc về một project, có thể gán cho thành viên, có mô tả, trạng thái, thời hạn, tiến độ.

### 2. Xử lý ngôn ngữ tự nhiên (nlp)

- **Mô hình chính:** PhoBERT - Mô hình Transformer tiền huấn luyện cho tiếng Việt.
- **Công cụ tách từ:** underthesea - Thư viện NLP cho tiếng Việt.
- **API Server:** FastAPI cung cấp endpoints cho phân tích văn bản.

##### Cấu trúc thư mục:
<pre>
nlp/
├── pycache_/
├── data/
├── model/
├── phobert-ner/
├── src/
├── transformers/
├── vncorenlp/
├── app.py
├── config.yaml
├── requirements.txt
└── server.py
</pre>

---

## Cài đặt và sử dụng

### 1. Frontend (Flutter)

#### Yêu cầu
- Flutter SDK
- Dart

#### Cài đặt & chạy
<pre>
cd app/client
flutter pub get
flutter run -d chrome
</pre>


### 2. Backend (Node.js + MongoDB)

#### Yêu cầu
- Node.js 14+
- MongoDB

#### Cài đặt & chạy
<pre>
cd app/server
npm install
npm run dev
</pre>
- Đảm bảo MongoDB đang chạy trên máy hoặc cấu hình đúng URI trong biến môi trường.

### 3. NLP module (Python)

#### Yêu cầu
- Python 3.8+
- Các thư viện trong `requirements.txt`

#### Cài đặt & sử dụng
<pre>
cd nlp
pip install -r requirements.txt
</pre>

- **Huấn luyện mô hình:**
<pre>python train.py</pre>

- **Kiểm thử mô hình:**
<pre>python test.py</pre>

- **Chạy server NLP:**
<pre>uvicorn server:app --reload</pre>


---

> **Lưu ý:**  
> - Đảm bảo các thành phần đã cài đặt đúng dependencies và cấu hình môi trường phù hợp trước khi chạy.
> - Tham khảo thêm chi tiết cấu trúc từng phần trong ảnh cấu trúc dự án đính kèm.
