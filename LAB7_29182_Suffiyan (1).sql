-- Create Student Table
CREATE TABLE Students (
    StudentID NUMBER PRIMARY KEY,
    StudentName VARCHAR2(255) NOT NULL
);

-- Create Course Table
CREATE TABLE Courses (
    CourseID VARCHAR2(10) PRIMARY KEY,
    CourseTitle VARCHAR2(255) NOT NULL UNIQUE
);

-- Create Faculty Table
CREATE TABLE Faculty (
    FacultyID NUMBER PRIMARY KEY,
    FacultyName VARCHAR2(255) NOT NULL
);

-- Create Course Offering Table
CREATE TABLE CourseOfferings (
    OfferingID NUMBER PRIMARY KEY,
    CourseID VARCHAR2(10) NOT NULL,
    FacultyID NUMBER NOT NULL,
    CONSTRAINT fk_CourseOffering_Course FOREIGN KEY (CourseID)
        REFERENCES Courses (CourseID),
    CONSTRAINT fk_CourseOffering_Faculty FOREIGN KEY (FacultyID)
        REFERENCES Faculty (FacultyID)
);

-- Create Enrollment Table
CREATE TABLE Enrollments (
    StudentID NUMBER NOT NULL,
    OfferingID NUMBER NOT NULL,
    Grade CHAR(1),
    CONSTRAINT pk_Enrollment PRIMARY KEY (StudentID, OfferingID),
    CONSTRAINT fk_Enrollment_Student FOREIGN KEY (StudentID)
        REFERENCES Students (StudentID),
    CONSTRAINT fk_Enrollment_Offering FOREIGN KEY (OfferingID)
        REFERENCES CourseOfferings (OfferingID)
);

--------------------------------------------------------------
-- Insert Data
--------------------------------------------------------------

-- Students
INSERT INTO Students VALUES (1, 'Ezan Raza');
INSERT INTO Students VALUES (2, 'Fawad Siddiqui');
INSERT INTO Students VALUES (3, 'Rafay Khan');
INSERT INTO Students VALUES (4, 'Daniyal Faisal');

-- Courses
INSERT INTO Courses VALUES ('C101', 'Database Systems');
INSERT INTO Courses VALUES ('C102', 'Data Structures');
INSERT INTO Courses VALUES ('C103', 'Artificial Intelligence');
INSERT INTO Courses VALUES ('C104', 'Software Engineering');

-- Faculty
INSERT INTO Faculty VALUES (1, 'Dr. Khalid');
INSERT INTO Faculty VALUES (2, 'Prof. Adeel');
INSERT INTO Faculty VALUES (3, 'Dr. Fatima');

-- Course Offerings
INSERT INTO CourseOfferings VALUES (1, 'C101', 1); -- Database Systems by Dr. Khalid
INSERT INTO CourseOfferings VALUES (2, 'C102', 2); -- Data Structures by Prof. Adeel
INSERT INTO CourseOfferings VALUES (3, 'C103', 3); -- AI by Dr. Fatima
INSERT INTO CourseOfferings VALUES (4, 'C104', 1); -- SE by Dr. Khalid

-- Enrollments
INSERT INTO Enrollments VALUES (1, 1, 'A');
INSERT INTO Enrollments VALUES (1, 2, 'B');
INSERT INTO Enrollments VALUES (2, 1, 'A');
INSERT INTO Enrollments VALUES (2, 3, 'A');
INSERT INTO Enrollments VALUES (3, 2, 'B');
INSERT INTO Enrollments VALUES (3, 4, 'A');
INSERT INTO Enrollments VALUES (4, 3, 'A');
INSERT INTO Enrollments VALUES (4, 4, 'B');

--------------------------------------------------------------
-- Q3: Insert new course and offering
--------------------------------------------------------------
INSERT INTO Courses VALUES ('C105', 'Business');
INSERT INTO CourseOfferings VALUES (5, 'C105', 1);

--------------------------------------------------------------
-- Q4: List Students with Enrolled Courses and Grades
--------------------------------------------------------------
SELECT 
    s.StudentName,
    c.CourseTitle,
    e.Grade
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
JOIN CourseOfferings co ON e.OfferingID = co.OfferingID
JOIN Courses c ON co.CourseID = c.CourseID
ORDER BY s.StudentName;

--------------------------------------------------------------
-- Q5: Count Students per Course
--------------------------------------------------------------
SELECT 
    c.CourseTitle,
    COUNT(e.StudentID) AS TotalStudents
FROM Courses c
LEFT JOIN CourseOfferings co ON c.CourseID = co.CourseID
LEFT JOIN Enrollments e ON co.OfferingID = e.OfferingID
GROUP BY c.CourseTitle
ORDER BY TotalStudents DESC;

--------------------------------------------------------------
-- Q6: Students enrolled in more than one course
--------------------------------------------------------------
SELECT 
    s.StudentName,
    COUNT(e.OfferingID) AS CourseCount
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
GROUP BY s.StudentName
HAVING COUNT(e.OfferingID) > 1;

--------------------------------------------------------------
-- Q7: List Courses with Faculty teaching them
--------------------------------------------------------------
SELECT 
    c.CourseTitle,
    f.FacultyName
FROM Courses c
JOIN CourseOfferings co ON c.CourseID = co.CourseID
JOIN Faculty f ON co.FacultyID = f.FacultyID;

--------------------------------------------------------------
-- Q8: Courses taught by more than one Faculty (if any)
--------------------------------------------------------------
SELECT 
    c.CourseTitle,
    COUNT(DISTINCT co.FacultyID) AS NumFaculty
FROM Courses c
JOIN CourseOfferings co ON c.CourseID = co.CourseID
GROUP BY c.CourseTitle
HAVING COUNT(DISTINCT co.FacultyID) > 1;

--------------------------------------------------------------
-- Q9: Student, Course, and Faculty detail
--------------------------------------------------------------
SELECT 
    s.StudentName,
    c.CourseTitle,
    f.FacultyName
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
JOIN CourseOfferings co ON e.OfferingID = co.OfferingID
JOIN Courses c ON co.CourseID = c.CourseID
JOIN Faculty f ON co.FacultyID = f.FacultyID
ORDER BY s.StudentName, c.CourseTitle;

--------------------------------------------------------------
-- Q10: Students who scored 'A'
--------------------------------------------------------------
SELECT 
    s.StudentName,
    c.CourseTitle,
    e.Grade
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
JOIN CourseOfferings co ON e.OfferingID = co.OfferingID
JOIN Courses c ON co.CourseID = c.CourseID
WHERE e.Grade = 'A'
ORDER BY s.StudentName;

--------------------------------------------------------------
-- Q11: Faculty handling more than one course
--------------------------------------------------------------
SELECT 
    f.FacultyName,
    COUNT(co.CourseID) AS NumCourses
FROM Faculty f
JOIN CourseOfferings co ON f.FacultyID = co.FacultyID
GROUP BY f.FacultyName
HAVING COUNT(co.CourseID) > 1;
