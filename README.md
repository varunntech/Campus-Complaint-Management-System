# Campus Complaint Management System

A Java-based web application designed to simplify campus complaint registration, tracking, and resolution. The system allows students to submit complaints and monitor their status, while administrators can review complaints, update their progress, and provide remarks.

## Features

### Student Features
- **User Registration:** Create a student account securely.
- **User Login:** Authenticate using registered email and password.
- **Submit Complaints:** Report campus-related issues with a title, category, and description.
- **Track Complaints:** View submitted complaints and their current status.
- **Status Monitoring:** Track complaints as Pending, In Progress, or Resolved.
- **Secure Logout:** End the current session.

### Admin Features
- **Admin Dashboard:** View complaints submitted by students.
- **Complaint Management:** Review complaint details and student information.
- **Status Updates:** Change complaint status.
- **Admin Remarks:** Add remarks or updates for students.
- **Centralized Management:** Manage complaints through a single web interface.

## Technology Stack

| Technology | Purpose |
|---|---|
| Java | Application logic |
| JSP | Dynamic web pages |
| Java Servlets | Request handling and application workflows |
| JDBC | Database connectivity |
| MySQL | Relational database |
| Apache Maven | Dependency and project management |
| Apache Tomcat 9 | Web application server |
| jBCrypt | Password hashing |
| HTML and CSS | User interface |

## Project Structure

```text
CampusComplaintManagementSystem/
├── pom.xml
├── src/
│   └── main/
│       ├── java/
│       │   └── com/
│       │       └── campus/
│       │           ├── config/
│       │           │   └── DBConnection.java
│       │           └── servlet/
│       │               ├── RegisterServlet.java
│       │               ├── LoginServlet.java
│       │               ├── LogoutServlet.java
│       │               ├── ComplaintServlet.java
│       │               └── AdminComplaintServlet.java
│       ├── resources/
│       │   └── db.properties
│       └── webapp/
│           ├── index.html
│           ├── login.jsp
│           ├── register.jsp
│           ├── dashboard.jsp
│           ├── submit-complaint.jsp
│           ├── my-complaints.jsp
│           ├── admin-dashboard.jsp
│           └── WEB-INF/
│               └── web.xml
└── README.md
```

*Note: This structure illustrates the expected project files. Your actual files may vary.*

## Database Setup

The application uses MySQL to store user accounts and complaints.

### 1. Create the database

Open MySQL Workbench and execute:

```sql
CREATE DATABASE IF NOT EXISTS campus_complaints;
USE campus_complaints;

CREATE TABLE IF NOT EXISTS users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('STUDENT', 'ADMIN') NOT NULL DEFAULT 'STUDENT',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS complaints (
    complaint_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    title VARCHAR(150) NOT NULL,
    category VARCHAR(60) NOT NULL,
    description TEXT NOT NULL,
    status ENUM('Pending', 'In Progress', 'Resolved')
        NOT NULL DEFAULT 'Pending',
    admin_remarks TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id)
        REFERENCES users(user_id)
        ON DELETE CASCADE
);
```

### 2. Configure database connectivity

Create or update `src/main/resources/db.properties`:

```properties
db.url=jdbc:mysql://localhost:3306/campus_complaints?useSSL=false&serverTimezone=Asia/Kolkata
db.username=root
db.password=YOUR_MYSQL_PASSWORD
```

Replace `YOUR_MYSQL_PASSWORD` with your local MySQL password.

**Security:** Never commit `db.properties` or database credentials to GitHub. Keep your local configuration file on your computer and exclude it through `.gitignore`.

## Installation and Setup

### Prerequisites

Install the following software:

- Java Development Kit (JDK) compatible with the project configuration
- Apache NetBeans IDE
- Apache Maven
- Apache Tomcat 9
- MySQL Server and MySQL Workbench
- Git, if uploading the project to GitHub

### Steps to Run

1. Clone or download the project.
2. Open Apache NetBeans.
3. Select **File → Open Project** and choose the project folder containing `pom.xml`.
4. Create the MySQL database and tables using the SQL commands above.
5. Configure `db.properties` with your local database credentials.
6. Ensure MySQL Server is running.
7. Ensure Apache Tomcat 9 is configured in NetBeans.
8. Right-click the project and select **Clean and Build**.
9. Run the project using NetBeans.
10. Open the application using the local URL provided by NetBeans, typically:

   `http://localhost:8080/CampusComplaintManagementSystem/`

   The context path may differ depending on your Maven configuration.

## How to Use

### Student Workflow

1. Open the application home page.
2. Register a new student account.
3. Log in with your registered credentials.
4. Submit a complaint by entering its title, category, and description.
5. Open **Track My Complaints** to review the submitted complaint and its status.
6. Log out when finished.

### Administrator Workflow

1. Register an account and configure its role as `ADMIN` in MySQL.
2. Log in again using that account.
3. Access the administrator dashboard.
4. Review complaints submitted by students.
5. Update complaint statuses and add administrative remarks.

To grant administrator access to an existing account, execute the following query using the intended administrator's email:

```sql
USE campus_complaints;

UPDATE users
SET role = 'ADMIN'
WHERE email = 'your-admin-email@example.com';

SELECT user_id, full_name, email, role
FROM users
WHERE email = 'your-admin-email@example.com';
```

Replace the example email with the account's registered email. Log out and log back in for the updated role to take effect.

## Complaint Statuses

| Status | Meaning |
|---|---|
| Pending | The complaint has been submitted and is awaiting action. |
| In Progress | The complaint is being reviewed or addressed. |
| Resolved | The complaint has been marked as resolved. |

## Security and Data Handling

- Passwords are hashed using jBCrypt rather than stored as plain text.
- Login sessions are used to manage authenticated users.
- Student and administrator workflows are separated by user roles.
- Database credentials should remain outside version control.
- Database queries should use prepared statements for user-provided input.

## Future Enhancements

- Email notifications for complaint status changes
- Complaint priority and department assignment
- File and image attachments
- Search, filtering, and pagination
- Complaint analytics and dashboard charts
- Password reset functionality
- Deployment to a cloud hosting environment

## Author

**Varun MCA Data Science**

## License

No license has been specified for this project yet. All rights are reserved by default unless a license is added.
