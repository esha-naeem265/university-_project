-- University Academic DB — Full Advanced SQL Script Plan with SHA-256 & AES Encryption

## Database Setup
CREATE DATABASE IF NOT EXISTS UniversityDB;
USE UniversityDB;



## 2️⃣ Tables

### Departments


CREATE TABLE Departments (
    Department_ID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL UNIQUE,
    Head_Professor_ID INT,
    Budget DECIMAL(12,2) DEFAULT 0.00
);

-- ### Professors (Salary AES encrypted)


CREATE TABLE Professors (
    Professor_ID INT AUTO_INCREMENT PRIMARY KEY,
    First_Name VARCHAR(50) NOT NULL,
    Last_Name VARCHAR(50) NOT NULL,
    Email VARCHAR(150) UNIQUE NOT NULL,
    Department_ID INT,
    Hire_Date DATE,
    Salary VARBINARY(255),
    FOREIGN KEY (Department_ID) REFERENCES Departments(Department_ID)
);



### Students (Sensitive data AES encrypted)


CREATE TABLE Students (
    Student_ID INT AUTO_INCREMENT PRIMARY KEY,
    First_Name VARCHAR(50) NOT NULL,
    Last_Name VARCHAR(50) NOT NULL,
    Email VARCHAR(150) UNIQUE NOT NULL,
    Gender ENUM('Male','Female','Other') DEFAULT 'Male',
    DOB DATE,
    Department_ID INT,
    Enrollment_Date DATE,
    Contact_Number VARBINARY(255),
    FOREIGN KEY (Department_ID) REFERENCES Departments(Department_ID)
);

### Courses


CREATE TABLE Courses (
    Course_ID VARCHAR(10) PRIMARY KEY,
    Course_Name VARCHAR(150) NOT NULL,
    Credits INT NOT NULL,
    Department_ID INT,
    FOREIGN KEY (Department_ID) REFERENCES Departments(Department_ID)
);

### Enrollments
CREATE TABLE Enrollments (
    Enrollment_ID INT AUTO_INCREMENT PRIMARY KEY,
    Student_ID INT NOT NULL,
    Course_ID VARCHAR(10) NOT NULL,
    Semester ENUM('Spring','Summer','Fall') NOT NULL,
    Year YEAR NOT NULL,
    Grade VARCHAR(2),
    UNIQUE(Student_ID, Course_ID, Semester, Year),
    FOREIGN KEY (Student_ID) REFERENCES Students(Student_ID),
    FOREIGN KEY (Course_ID) REFERENCES Courses(Course_ID)
);





CREATE TABLE Exams (
    Exam_ID INT AUTO_INCREMENT PRIMARY KEY,
    Course_ID VARCHAR(10) NOT NULL,
    Exam_Type ENUM('Midterm','Final','Quiz') NOT NULL,
    Exam_Date DATETIME NOT NULL,
    Total_Marks INT NOT NULL,
    FOREIGN KEY (Course_ID) REFERENCES Courses(Course_ID)
);


### Results


CREATE TABLE Results (
    Result_ID INT AUTO_INCREMENT PRIMARY KEY,
    Student_ID INT NOT NULL,
    Exam_ID INT NOT NULL,
    Marks_Obtained INT NOT NULL,
    FOREIGN KEY (Student_ID) REFERENCES Students(Student_ID),
    FOREIGN KEY (Exam_ID) REFERENCES Exams(Exam_ID)
);

### Users (SHA-256 password hashing)

CREATE TABLE Users (
    User_ID INT AUTO_INCREMENT PRIMARY KEY,
    Username VARCHAR(50) UNIQUE NOT NULL,
    Password_Hash CHAR(64) NOT NULL,
    Role ENUM('Admin','Professor','Student') NOT NULL,
    Created_On DATETIME DEFAULT CURRENT_TIMESTAMP
);

### Audit_Log


CREATE TABLE Audit_Log (
    Audit_ID INT AUTO_INCREMENT PRIMARY KEY,
    User_ID INT,
    Action VARCHAR(50),
    Table_Name VARCHAR(50),
    Record_ID INT,
    Timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (User_ID) REFERENCES Users(User_ID)
);



## 3️⃣ Indexes for performance


CREATE INDEX idx_student_email ON Students(Email);
CREATE INDEX idx_professor_email ON Professors(Email);
CREATE INDEX idx_enroll_student ON Enrollments(Student_ID);
CREATE INDEX idx_enroll_course ON Enrollments(Course_ID);
CREATE INDEX idx_results_exam ON Results(Exam_ID);




## 4️⃣ Sample Data


-- Departments
INSERT INTO Departments (Name, Budget) VALUES ('Computer Science', 100000), ('Electrical', 80000), ('Business', 90000);

-- Professors (Salary encrypted)
INSERT INTO Professors (First_Name, Last_Name, Email, Department_ID, Hire_Date, Salary) VALUES
('Ali','Khan','ali@uni.edu',1,'2020-01-10',AES_ENCRYPT('80000','secretkey')),
('Sara','Ahmed','sara@uni.edu',2,'2019-03-15',AES_ENCRYPT('75000','secretkey'));

-- Students (Contact encrypted)
INSERT INTO Students (First_Name, Last_Name, Email, Gender, DOB, Department_ID, Enrollment_Date, Contact_Number) VALUES
('Ahmed','Raza','ahmed@student.edu','Male','2001-05-10',1,'2022-08-15',AES_ENCRYPT('03001234567','secretkey')),
('Ayesha','Ali','ayesha@student.edu','Female','2002-07-20',2,'2022-08-16',AES_ENCRYPT('03111234567','secretkey'));

-- Courses
INSERT INTO Courses (Course_ID, Course_Name, Credits, Department_ID) VALUES ('CS101','Programming 101',3,1),('EE201','Circuits',4,2);

-- Enrollments
INSERT INTO Enrollments (Student_ID, Course_ID, Semester, Year, Grade) VALUES (1,'CS101','Fall',2025,'A'),(2,'EE201','Fall',2025,'B');

-- Exams
INSERT INTO Exams (Course_ID, Exam_Type, Exam_Date, Total_Marks) VALUES ('CS101','Midterm','2025-10-10 10:00:00',100),('EE201','Final','2025-12-15 14:00:00',100);

-- Results
INSERT INTO Results (Student_ID, Exam_ID, Marks_Obtained) VALUES (1,1,95),(2,2,88);

-- Users (SHA-256 hash)
INSERT INTO Users (Username, Password_Hash, Role) VALUES
('admin',SHA2('admin123',256),'Admin'),
('professor',SHA2('prof123',256),'Professor'),
('student',SHA2('stud123',256),'Student');

USE UniversityDB;

-- -------------------------
-- 1. Clean Tables Safely
-- -------------------------
SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE TABLE Results;
TRUNCATE TABLE Enrollments;
TRUNCATE TABLE Exams;
TRUNCATE TABLE Users;
TRUNCATE TABLE Students;
TRUNCATE TABLE Professors;
TRUNCATE TABLE Courses;
TRUNCATE TABLE Departments;

SET FOREIGN_KEY_CHECKS = 1;

-- -------------------------
-- 2. Departments
-- -------------------------
INSERT INTO Departments (Name, Budget) VALUES
('Computer Science', 100000),
('Electrical', 80000),
('Business', 90000);

-- -------------------------
-- 3. Professors (15)
-- -------------------------
INSERT INTO Professors (First_Name, Last_Name, Email, Department_ID, Hire_Date, Salary) VALUES
('Ali','Khan','ali.khan@uni.edu',1,'2015-01-10',AES_ENCRYPT('80000','secretkey')),
('Sara','Ahmed','sara.ahmed@uni.edu',2,'2016-03-15',AES_ENCRYPT('75000','secretkey')),
('Hamid','Iqbal','hamid.iqbal@uni.edu',1,'2017-05-20',AES_ENCRYPT('78000','secretkey')),
('Amina','Yousuf','amina.yousuf@uni.edu',2,'2018-02-10',AES_ENCRYPT('77000','secretkey')),
('Bilal','Shah','bilal.shah@uni.edu',3,'2019-06-01',AES_ENCRYPT('82000','secretkey')),
('Nadia','Khalid','nadia.khalid@uni.edu',1,'2014-09-12',AES_ENCRYPT('81000','secretkey')),
('Faisal','Rashid','faisal.raza@uni.edu',3,'2015-11-23',AES_ENCRYPT('80000','secretkey')),
('Zara','Hussain','zara.hussain@uni.edu',2,'2016-07-19',AES_ENCRYPT('79000','secretkey')),
('Omar','Khan','omar.khan@uni.edu',1,'2017-10-05',AES_ENCRYPT('77500','secretkey')),
('Hina','Aziz','hina.aziz@uni.edu',3,'2018-01-22',AES_ENCRYPT('76000','secretkey')),
('Imran','Rashid','imran.rashid@uni.edu',2,'2019-04-30',AES_ENCRYPT('77000','secretkey')),
('Sadia','Bashir','sadia.bashir@uni.edu',1,'2020-08-15',AES_ENCRYPT('78000','secretkey')),
('Adil','Nawaz','adil.nawaz@uni.edu',3,'2014-03-10',AES_ENCRYPT('82000','secretkey')),
('Rida','Shafiq','rida.shafiq@uni.edu',2,'2015-12-11',AES_ENCRYPT('79000','secretkey')),
('Tariq','Aslam','tariq.aslam@uni.edu',1,'2016-09-27',AES_ENCRYPT('80500','secretkey'));

-- -------------------------
-- 4. Students (50)
-- -------------------------
INSERT INTO Students (First_Name, Last_Name, Email, Gender, DOB, Department_ID, Enrollment_Date, Contact_Number) VALUES
('Ahmed','Raza','student1@uni.edu','Male','2001-01-05',1,'2022-08-15',AES_ENCRYPT('03001234501','secretkey')),
('Ayesha','Ali','student2@uni.edu','Female','2002-02-12',2,'2022-08-16',AES_ENCRYPT('03001234502','secretkey')),
('Bilal','Shah','student3@uni.edu','Male','2001-03-18',3,'2022-08-17',AES_ENCRYPT('03001234503','secretkey')),
('Sana','Iqbal','student4@uni.edu','Female','2002-04-22',1,'2022-08-18',AES_ENCRYPT('03001234504','secretkey')),
('Faisal','Rashid','student5@uni.edu','Male','2001-05-30',2,'2022-08-19',AES_ENCRYPT('03001234505','secretkey')),
('Hina','Khan','student6@uni.edu','Female','2002-06-15',3,'2022-08-20',AES_ENCRYPT('03001234506','secretkey')),
('Omar','Aziz','student7@uni.edu','Male','2001-07-10',1,'2022-08-21',AES_ENCRYPT('03001234507','secretkey')),
('Zara','Yousuf','student8@uni.edu','Female','2002-08-02',2,'2022-08-22',AES_ENCRYPT('03001234508','secretkey')),
('Imran','Bashir','student9@uni.edu','Male','2001-09-25',3,'2022-08-23',AES_ENCRYPT('03001234509','secretkey')),
('Sadia','Khalid','student10@uni.edu','Female','2002-10-12',1,'2022-08-24',AES_ENCRYPT('03001234510','secretkey')),
('Ali','Nawaz','student11@uni.edu','Male','2001-11-01',2,'2022-08-25',AES_ENCRYPT('03001234511','secretkey')),
('Amina','Shah','student12@uni.edu','Female','2002-12-05',3,'2022-08-26',AES_ENCRYPT('03001234512','secretkey')),
('Bilal','Hussain','student13@uni.edu','Male','2001-01-20',1,'2022-08-27',AES_ENCRYPT('03001234513','secretkey')),
('Hina','Rashid','student14@uni.edu','Female','2002-02-14',2,'2022-08-28',AES_ENCRYPT('03001234514','secretkey')),
('Omar','Iqbal','student15@uni.edu','Male','2001-03-11',3,'2022-08-29',AES_ENCRYPT('03001234515','secretkey')),
('Zara','Bashir','student16@uni.edu','Female','2002-04-07',1,'2022-08-30',AES_ENCRYPT('03001234516','secretkey')),
('Imran','Khalid','student17@uni.edu','Male','2001-05-21',2,'2022-08-31',AES_ENCRYPT('03001234517','secretkey')),
('Sadia','Aziz','student18@uni.edu','Female','2002-06-16',3,'2022-09-01',AES_ENCRYPT('03001234518','secretkey')),
('Ahmed','Yousuf','student19@uni.edu','Male','2001-07-30',1,'2022-09-02',AES_ENCRYPT('03001234519','secretkey')),
('Ayesha','Shafiq','student20@uni.edu','Female','2002-08-22',2,'2022-09-03',AES_ENCRYPT('03001234520','secretkey')),
('Bilal','Nawaz','student21@uni.edu','Male','2001-09-05',3,'2022-09-04',AES_ENCRYPT('03001234521','secretkey')),
('Sana','Hussain','student22@uni.edu','Female','2002-10-17',1,'2022-09-05',AES_ENCRYPT('03001234522','secretkey')),
('Faisal','Iqbal','student23@uni.edu','Male','2001-11-23',2,'2022-09-06',AES_ENCRYPT('03001234523','secretkey')),
('Hina','Raza','student24@uni.edu','Female','2002-12-11',3,'2022-09-07',AES_ENCRYPT('03001234524','secretkey')),
('Omar','Shah','student25@uni.edu','Male','2001-01-15',1,'2022-09-08',AES_ENCRYPT('03001234525','secretkey')),
('Zara','Ahmed','student26@uni.edu','Female','2002-02-18',2,'2022-09-09',AES_ENCRYPT('03001234526','secretkey')),
('Imran','Hussain','student27@uni.edu','Male','2001-03-25',3,'2022-09-10',AES_ENCRYPT('03001234527','secretkey')),
('Sadia','Rashid','student28@uni.edu','Female','2002-04-12',1,'2022-09-11',AES_ENCRYPT('03001234528','secretkey')),
('Ali','Aziz','student29@uni.edu','Male','2001-05-08',2,'2022-09-12',AES_ENCRYPT('03001234529','secretkey')),
('Amina','Khalid','student30@uni.edu','Female','2002-06-23',3,'2022-09-13',AES_ENCRYPT('03001234530','secretkey')),
('Bilal','Yousuf','student31@uni.edu','Male','2001-07-17',1,'2022-09-14',AES_ENCRYPT('03001234531','secretkey')),
('Sana','Shafiq','student32@uni.edu','Female','2002-08-29',2,'2022-09-15',AES_ENCRYPT('03001234532','secretkey')),
('Faisal','Bashir','student33@uni.edu','Male','2001-09-11',3,'2022-09-16',AES_ENCRYPT('03001234533','secretkey')),
('Hina','Nawaz','student34@uni.edu','Female','2002-10-05',1,'2022-09-17',AES_ENCRYPT('03001234534','secretkey')),
('Omar','Raza','student35@uni.edu','Male','2001-11-19',2,'2022-09-18',AES_ENCRYPT('03001234535','secretkey')),
('Zara','Iqbal','student36@uni.edu','Female','2002-12-03',3,'2022-09-19',AES_ENCRYPT('03001234536','secretkey')),
('Imran','Shah','student37@uni.edu','Male','2001-01-28',1,'2022-09-20',AES_ENCRYPT('03001234537','secretkey')),
('Sadia','Ahmed','student38@uni.edu','Female','2002-02-13',2,'2022-09-21',AES_ENCRYPT('03001234538','secretkey')),
('Ahmed','Hussain','student39@uni.edu','Male','2001-03-07',3,'2022-09-22',AES_ENCRYPT('03001234539','secretkey')),
('Ayesha','Rashid','student40@uni.edu','Female','2002-04-25',1,'2022-09-23',AES_ENCRYPT('03001234540','secretkey')),
('Bilal','Aziz','student41@uni.edu','Male','2001-05-16',2,'2022-09-24',AES_ENCRYPT('03001234541','secretkey')),
('Sana','Khalid','student42@uni.edu','Female','2002-06-11',3,'2022-09-25',AES_ENCRYPT('03001234542','secretkey')),
('Faisal','Yousuf','student43@uni.edu','Male','2001-07-29',1,'2022-09-26',AES_ENCRYPT('03001234543','secretkey')),
('Hina','Shafiq','student44@uni.edu','Female','2002-08-07',2,'2022-09-27',AES_ENCRYPT('03001234544','secretkey')),
('Omar','Bashir','student45@uni.edu','Male','2001-09-22',3,'2022-09-28',AES_ENCRYPT('03001234545','secretkey')),
('Zara','Nawaz','student46@uni.edu','Female','2002-10-14',1,'2022-09-29',AES_ENCRYPT('03001234546','secretkey')),
('Imran','Raza','student47@uni.edu','Male','2001-11-08',2,'2022-09-30',AES_ENCRYPT('03001234547','secretkey')),
('Sadia','Iqbal','student48@uni.edu','Female','2002-12-20',3,'2022-10-01',AES_ENCRYPT('03001234548','secretkey')),
('Ali','Shah','student49@uni.edu','Male','2001-01-03',1,'2022-10-02',AES_ENCRYPT('03001234549','secretkey')),
('Amina','Ahmed','student50@uni.edu','Female','2002-02-28',2,'2022-10-03',AES_ENCRYPT('03001234550','secretkey'));

-- -------------------------
-- 5. Courses (10)
-- -------------------------
INSERT INTO Courses (Course_ID, Course_Name, Credits, Department_ID) VALUES
('CS101','Programming 101',3,1),
('CS102','Data Structures',3,1),
('CS103','Algorithms',3,1),
('EE201','Circuits',4,2),
('EE202','Signals',3,2),
('EE203','Electronics',3,2),
('BUS301','Marketing',3,3),
('BUS302','Finance',3,3),
('BUS303','Management',3,3),
('BUS304','Economics',3,3);

-- -------------------------
-- 6. Enrollments (2 courses per student)
-- -------------------------
INSERT INTO Enrollments (Student_ID, Course_ID, Semester, Year, Grade) VALUES
(1,'CS101','Fall',2025,'A'),(1,'CS102','Fall',2025,'B'),
(2,'EE201','Fall',2025,'A'),(2,'EE202','Fall',2025,'B'),
(3,'BUS301','Fall',2025,'B'),(3,'BUS302','Fall',2025,'A'),
(4,'CS103','Fall',2025,'A'),(4,'CS101','Fall',2025,'B'),
(5,'EE203','Fall',2025,'B'),(5,'EE202','Fall',2025,'C'),
(6,'BUS303','Fall',2025,'A'),(6,'BUS304','Fall',2025,'B'),
(7,'CS102','Fall',2025,'A'),(7,'CS103','Fall',2025,'B'),
(8,'EE201','Fall',2025,'C'),(8,'EE203','Fall',2025,'B'),
(9,'BUS301','Fall',2025,'B'),(9,'BUS302','Fall',2025,'A'),
(10,'CS101','Fall',2025,'A'),(10,'CS102','Fall',2025,'B'),
(11,'EE202','Fall',2025,'B'),(11,'EE203','Fall',2025,'A'),
(12,'BUS303','Fall',2025,'A'),(12,'BUS304','Fall',2025,'B'),
(13,'CS103','Fall',2025,'A'),(13,'CS101','Fall',2025,'B'),
(14,'EE201','Fall',2025,'B'),(14,'EE202','Fall',2025,'A'),
(15,'BUS301','Fall',2025,'A'),(15,'BUS302','Fall',2025,'B'),
(16,'CS102','Fall',2025,'B'),(16,'CS103','Fall',2025,'A'),
(17,'EE203','Fall',2025,'A'),(17,'EE201','Fall',2025,'B'),
(18,'BUS303','Fall',2025,'B'),(18,'BUS304','Fall',2025,'A'),
(19,'CS101','Fall',2025,'A'),(19,'CS102','Fall',2025,'B'),
(20,'EE202','Fall',2025,'B'),(20,'EE203','Fall',2025,'A'),
(21,'BUS301','Fall',2025,'A'),(21,'BUS302','Fall',2025,'B'),
(22,'CS103','Fall',2025,'B'),(22,'CS101','Fall',2025,'A'),
(23,'EE201','Fall',2025,'A'),(23,'EE202','Fall',2025,'B'),
(24,'BUS303','Fall',2025,'A'),(24,'BUS304','Fall',2025,'B'),
(25,'CS102','Fall',2025,'B'),(25,'CS103','Fall',2025,'A'),
(26,'EE203','Fall',2025,'A'),(26,'EE201','Fall',2025,'B'),
(27,'BUS301','Fall',2025,'B'),(27,'BUS302','Fall',2025,'A'),
(28,'CS101','Fall',2025,'A'),(28,'CS102','Fall',2025,'B'),
(29,'EE202','Fall',2025,'B'),(29,'EE203','Fall',2025,'A'),
(30,'BUS303','Fall',2025,'A'),(30,'BUS304','Fall',2025,'B'),
(31,'CS103','Fall',2025,'A'),(31,'CS101','Fall',2025,'B'),
(32,'EE201','Fall',2025,'B'),(32,'EE202','Fall',2025,'A'),
(33,'BUS301','Fall',2025,'A'),(33,'BUS302','Fall',2025,'B'),
(34,'CS102','Fall',2025,'B'),(34,'CS103','Fall',2025,'A'),
(35,'EE203','Fall',2025,'A'),(35,'EE201','Fall',2025,'B'),
(36,'BUS303','Fall',2025,'B'),(36,'BUS304','Fall',2025,'A'),
(37,'CS101','Fall',2025,'A'),(37,'CS102','Fall',2025,'B'),
(38,'EE202','Fall',2025,'B'),(38,'EE203','Fall',2025,'A'),
(39,'BUS301','Fall',2025,'A'),(39,'BUS302','Fall',2025,'B'),
(40,'CS103','Fall',2025,'B'),(40,'CS101','Fall',2025,'A'),
(41,'EE201','Fall',2025,'A'),(41,'EE202','Fall',2025,'B'),
(42,'BUS303','Fall',2025,'A'),(42,'BUS304','Fall',2025,'B'),
(43,'CS102','Fall',2025,'B'),(43,'CS103','Fall',2025,'A'),
(44,'EE203','Fall',2025,'A'),(44,'EE201','Fall',2025,'B'),
(45,'BUS301','Fall',2025,'B'),(45,'BUS302','Fall',2025,'A'),
(46,'CS101','Fall',2025,'A'),(46,'CS102','Fall',2025,'B'),
(47,'EE202','Fall',2025,'B'),(47,'EE203','Fall',2025,'A'),
(48,'BUS303','Fall',2025,'A'),(48,'BUS304','Fall',2025,'B'),
(49,'CS103','Fall',2025,'A'),(49,'CS101','Fall',2025,'B'),
(50,'EE201','Fall',2025,'B'),(50,'EE202','Fall',2025,'A');

-- -------------------------
-- 7. Exams (2 per course)
-- -------------------------
INSERT INTO Exams (Course_ID, Exam_Type, Exam_Date, Total_Marks) VALUES
('CS101','Midterm','2025-10-10 10:00:00',100),
('CS101','Final','2025-12-15 14:00:00',100),
('CS102','Midterm','2025-10-12 09:00:00',100),
('CS102','Final','2025-12-18 13:00:00',100),
('CS103','Midterm','2025-10-14 11:00:00',100),
('CS103','Final','2025-12-20 15:00:00',100),
('EE201','Midterm','2025-10-16 10:00:00',100),
('EE201','Final','2025-12-22 14:00:00',100),
('EE202','Midterm','2025-10-18 09:00:00',100),
('EE202','Final','2025-12-24 13:00:00',100),
('EE203','Midterm','2025-10-20 11:00:00',100),
('EE203','Final','2025-12-26 15:00:00',100),
('BUS301','Midterm','2025-10-22 10:00:00',100),
('BUS301','Final','2025-12-28 14:00:00',100),
('BUS302','Midterm','2025-10-24 09:00:00',100),
('BUS302','Final','2025-12-30 13:00:00',100),
('BUS303','Midterm','2025-10-26 11:00:00',100),
('BUS303','Final','2025-12-31 15:00:00',100),
('BUS304','Midterm','2025-10-28 10:00:00',100),
('BUS304','Final','2025-12-31 14:00:00',100);

-- -------------------------
-- 8. Results (sample marks for all students)
-- -------------------------
INSERT INTO Results (Student_ID, Exam_ID, Marks_Obtained) VALUES
(1,1,85),(1,2,90),(1,3,78),(1,4,82),
(2,5,88),(2,6,92),(2,7,80),(2,8,85),
(3,9,90),(3,10,86),(3,11,75),(3,12,80);
-- continue pattern as needed (50 students × 2 exams per course)

-- -------------------------
-- 9. Users (SHA-256)
-- -------------------------
INSERT INTO Users (Username, Password_Hash, Role) VALUES
('admin',SHA2('admin123',256),'Admin'),
('professor',SHA2('prof123',256),'Professor'),
('student',SHA2('stud123',256),'Student');



## 5️⃣ Stored Procedures & Triggers
-- Example: AddNewStudent stored procedure
DELIMITER $$
CREATE PROCEDURE AddNewStudent(
  IN f_name VARCHAR(50),
  IN l_name VARCHAR(50),
  IN email VARCHAR(150),
  IN gender ENUM('Male','Female','Other'),
  IN dob DATE,
  IN dept INT,
  IN contact VARBINARY(255)
)
BEGIN
  START TRANSACTION;
    INSERT INTO Students (First_Name, Last_Name, Email, Gender, DOB, Department_ID, Enrollment_Date, Contact_Number)
    VALUES (f_name, l_name, email, gender, dob, dept, CURDATE(), contact);
  COMMIT;
END$$
DELIMITER ;
-- Trigger: Audit on Results INSERT
  DELIMITER $$

CREATE TRIGGER trg_results_after_insert
AFTER INSERT ON Results
FOR EACH ROW
BEGIN
  INSERT INTO Audit_Log(User_ID, Action, Table_Name, Record_ID)
  VALUES (NULL, 'INSERT', 'Results', NEW.Result_ID);
END$$

DELIMITER ;

## 6️⃣ Views for Reporting

-- Student performance summary
CREATE VIEW StudentPerformanceView AS
SELECT s.Student_ID, s.First_Name, s.Last_Name, c.Course_Name, e.Exam_Type, r.Marks_Obtained
FROM Students s
JOIN Enrollments en ON s.Student_ID = en.Student_ID
JOIN Courses c ON en.Course_ID = c.Course_ID
JOIN Exams e ON c.Course_ID = e.Course_ID
JOIN Results r ON s.Student_ID = r.Student_ID AND e.Exam_ID = r.Exam_ID;


SELECT * FROM Students;
SELECT p.Professor_ID, p.First_Name, p.Last_Name, d.Name AS Department
FROM Professors p
JOIN Departments d ON p.Department_ID = d.Department_ID;
SELECT c.Course_ID, c.Course_Name, c.Credits, d.Name AS Department
FROM Courses c
JOIN Departments d ON c.Department_ID = d.Department_ID;
SELECT s.First_Name, s.Last_Name, c.Course_Name, e.Semester, e.Year, e.Grade
FROM Enrollments e
JOIN Students s ON e.Student_ID = s.Student_ID
JOIN Courses c ON e.Course_ID = c.Course_ID;
SELECT s.First_Name, s.Last_Name, c.Course_Name, r.Marks_Obtained
FROM Results r
JOIN Students s ON r.Student_ID = s.Student_ID
JOIN Exams e ON r.Exam_ID = e.Exam_ID
JOIN Courses c ON e.Course_ID = c.Course_ID;
SELECT s.First_Name, s.Last_Name, AVG(r.Marks_Obtained) AS Avg_Marks
FROM Results r
JOIN Students s ON r.Student_ID = s.Student_ID
GROUP BY s.Student_ID;
SELECT s.First_Name, s.Last_Name
FROM Enrollments e
JOIN Students s ON e.Student_ID = s.Student_ID
WHERE e.Course_ID = 'CS101';
SELECT c.Course_Name, COUNT(e.Student_ID) AS Total_Students
FROM Courses c
LEFT JOIN Enrollments e ON c.Course_ID = e.Course_ID
GROUP BY c.Course_ID;
SELECT s.First_Name, s.Last_Name, r.Marks_Obtained
FROM Results r
JOIN Students s ON r.Student_ID = s.Student_ID
WHERE r.Marks_Obtained > (SELECT AVG(Marks_Obtained) FROM Results);
SELECT * FROM StudentPerformanceView
WHERE Marks_Obtained >= 90;
SELECT First_Name, Last_Name, CAST(AES_DECRYPT(Contact_Number, 'secretkey') AS CHAR) AS Contact
FROM Students;
SELECT First_Name, Last_Name, CAST(AES_DECRYPT(Salary, 'secretkey') AS CHAR) AS Salary
FROM Professors;
SELECT Name, Budget
FROM Departments
WHERE Budget > (SELECT AVG(Budget) FROM Departments);

-- Verify Your Data

-- Check that all tables have the expected number of records:
SELECT COUNT(*) FROM Departments;
SELECT COUNT(*) FROM Professors;
SELECT COUNT(*) FROM Students;
SELECT COUNT(*) FROM Courses;
SELECT COUNT(*) FROM Enrollments;
SELECT COUNT(*) FROM Exams;
SELECT COUNT(*) FROM Results;
SELECT COUNT(*) FROM Users;

-- Example: List all courses each student is enrolled in
SELECT s.First_Name, s.Last_Name, c.Course_Name
FROM Enrollments e
JOIN Students s ON e.Student_ID = s.Student_ID
JOIN Courses c ON e.Course_ID = c.Course_ID
LIMIT 20;

-- Example: List exam results for a student
SELECT s.First_Name, s.Last_Name, c.Course_Name, r.Marks_Obtained
FROM Results r
JOIN Exams e ON r.Exam_ID = e.Exam_ID
JOIN Students s ON r.Student_ID = s.Student_ID
JOIN Courses c ON e.Course_ID = c.Course_ID
WHERE s.Student_ID = 1;