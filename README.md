# 📱 Learn to Help

**Learn to Help** is a full-stack skill exchange platform where users can discover and connect with others to exchange skills through **live, real-time sessions**. Built using **Flutter**, **Spring Boot**, and **PostgreSQL**, the platform promotes mutual learning by allowing users to send and receive skill exchange requests.

The backend is securely deployed on an **AWS EC2 instance** with a cloud-hosted **PostgreSQL (RDS)** database.

---

## ✨ Features

- 🔐 **JWT Authentication** for secure and stateless user login
- 💬 **Live Video Calling** for interactive skill-sharing sessions
- 🔁 **Mutual Requests System** to initiate and accept skill exchanges
- 👤 **User Profiles** with skill tags, bios, ratings, and locations
- 🔍 **Skill-Based Search & Matching** between users
- ☁️ **Hosted on AWS EC2** with **PostgreSQL on AWS RDS**

---

## 🛠 Tech Stack

### 🎯 Frontend (Mobile)
- **Flutter**
- **Provider** for state management
- **ZegoUIKitPrebuiltCall** for real-time video calls
- **Flutter Secure Storage** for storing tokens

### 🔧 Backend (API)
- **Java Spring Boot**
- **Spring Security** with **JWT-based Authentication**
- **Spring Data JPA**
- **PostgreSQL** as the database
- **RESTful APIs**

### ☁️ Cloud & Deployment
- **AWS EC2** for backend hosting
- **AWS RDS** for PostgreSQL database
- **GitHub** for version control

---


🚀 Getting Started
Follow these steps to run the project locally.

🔁 1. Fork & Clone the Repository
git clone https://github.com/YOUR_USERNAME/Learn-to-help.git
cd Learn-to-help

🔧 2. Backend Setup (Spring Boot)
📁 Navigate to the backend folder:
cd backend
🛠 Create application.properties at:
src/main/resources/application.properties
properties
# PostgreSQL DB (AWS RDS)
spring.datasource.url=jdbc:postgresql://<RDS-ENDPOINT>:5432/learn_to_help
spring.datasource.username=your_db_user
spring.datasource.password=your_db_password

# JPA Config
spring.jpa.hibernate.ddl-auto=update

# JWT Secret
jwt.secret=your_jwt_secret
▶️ Run the backend:
./mvnw spring-boot:run

📱 3. Frontend Setup (Flutter)
📁 Navigate to the frontend folder:
cd ../frontend
📦 Install dependencies:
flutter pub get
✏️ Update API base URL:
In lib/APiServices/APIBaseUrl.dart:
const String apiBaseUrl = "http://<YOUR_EC2_PUBLIC_IP>:8080";

🔐 4. ZegoCloud Video Calling Setup
In lib/Constants/VideoCallInfo.dart, add your Zego credentials:
const String appID = <YOUR_APP_ID>;       // as int
const String appSign = "<YOUR_APP_SIGN>"; // as String
📌 Get your credentials from ZegoCloud Console

▶️ 5. Run the Flutter App
flutter run

## 📁 Screenshots Folder
🔗 [View All Screenshots](https://github.com/DhruvSingh19/Learn-to-help/tree/main/ss)

🤝 Contributing
Pull requests are welcome! If you’d like to contribute or suggest improvements, feel free to fork the repo and open a PR.

👨‍💻 Developed By
Dhruv Singh
Built with ❤️ using Flutter, Spring Boot, and AWS.


Let me know if you also want:
- API documentation (Swagger/OpenAPI format)
- Postman collection for testing endpoints
- Screenshots in the README
- Deployment instructions to AWS EC2/RDS

Happy shipping 🚀
