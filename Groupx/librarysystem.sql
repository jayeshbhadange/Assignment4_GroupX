show databases;
create database LibrarySystem;
use LibrarySystem;
-- show tables;

-- drop table login_db;


CREATE TABLE login_db(
	email VARCHAR(40) NOT NULL,
    password VARCHAR(20) NOT NULL
);

INSERT INTO login_db(email,password) VALUES
( 'Jaggi@gmail.com' , 'harry');

select * from login_db;

CREATE TABLE users (
  UserID INT NOT NULL auto_increment,
  first_name VARCHAR(50) NOT NULL,
  middle_name VARCHAR(50),
  last_name VARCHAR(50),
  email VARCHAR(50) UNIQUE,
  CONSTRAINT PK_User PRIMARY KEY (UserID)
);

INSERT INTO users (UserID, first_name, middle_name, last_name, email) VALUES 
(1, 'John', 'David', 'Doe', 'john.doe@example.com'),
(2, 'Jane', 'Elizabeth', 'Smith', 'jane.smith@example.com'),
(3, 'Michael', 'Patrick', 'Scott', 'michael.scott@example.com'),
(4, 'Pamela', 'Morgan', 'Halpert', 'pamela.halpert@example.com'),
(5, 'Jim', 'Duncan', 'Halpert', 'jim.halpert@example.com'),
(6, 'Angela', 'Noelle', 'Martin', 'angela.martin@example.com'),
(7, 'Kevin', 'Jay', 'Malone', 'kevin.malone@example.com'),
(8, 'Oscar', 'Gutierrez', 'Martinez', 'oscar.martinez@example.com'),
(9, 'Toby', 'Wyatt', 'Flenderson', 'toby.flenderson@example.com'),
(10, 'Stanley', 'James', 'Hudson', 'stanley.hudson@example.com');


-- drop table users_credentials;

CREATE TABLE users_credentials (
  email VARCHAR(50) NOT NULL,
  UserPassword VARCHAR(50) UNIQUE,
  CONSTRAINT PK_User PRIMARY KEY (email)
);

INSERT INTO users_credentials (email,UserPassword) VALUES 
('john.doe@example.com','jd'),
('jane.smith@example.com','js'),
('michael.scott@example.com','ms'),
('pamela.halpert@example.com','ph'),
('jim.halpert@example.com','jh'),
('angela.martin@example.com','am'),
('kevin.malone@example.com','km'),
('oscar.martinez@example.com','om'),
('toby.flenderson@example.com','tf'),
('stanley.hudson@example.com','sh');


CREATE TABLE book (
  book_id INT NOT NULL,
  title varchar(500) DEFAULT NULL,
  edition int not null,
  Copies int not null,
  Availability_status boolean not null,
	author_id INT NOT NULL,
  CONSTRAINT pk_book PRIMARY KEY (book_id)
);

INSERT INTO book (book_id, title,edition,copies,availability_status,author_id) VALUES
(1, 'The Great Gatsby',1,10, true,1),
(2, 'To Kill a Mockingbird',2,15, true,2),
(3, '1984',1,5, false,1),
(4, 'Pride and Prejudice',3,20, true,3),
(5, 'The Catcher in the Rye',2,8, false,4),
(6, 'The Hobbit',1,12, true,5),
(7, 'Lord of the Flies',1,6, true,3),
(8, 'Animal Farm',2,10, false,8),
(9, 'The Odyssey',1,7, true,7),
(10, 'The Sun Also Rises',3,3, true,2),
(11, 'The Princeton Companion to Mathematics', 1, 10, true, 1),
(12, 'Introduction to Algorithms', 3, 8, true, 2),
(13, 'The Elements of Statistical Learning: Data Mining, Inference, and Prediction', 2, 12, true, 3),
(14, 'A Mathematician\'s Apology', 1, 5, true, 4),
(15, 'How to Solve It', 2, 7, true, 5),
(16, 'The Feynman Lectures on Physics', 1, 10, true, 6),
(17, 'University Physics with Modern Physics', 14, 8, true, 7),
(18, 'Introduction to Electrodynamics', 4, 12, true, 7),
(19, 'Gravitation', 1, 5, true, 9),
(20, 'Quantum Mechanics: Concepts and Applications', 2, 7, true, 10),
(21, 'Chemical Principles: The Quest for Insight', 3, 10, true, 1),
(22, 'Organic Chemistry', 2, 8, true, 2),
(23, 'Principles of Modern Chemistry', 8, 12, true, 3),
(24, 'Physical Chemistry: Thermodynamics, Structure, and Change', 10, 5,true, 4),
(25, 'Biochemistry', 7, 7, true, 5);


CREATE TABLE shelf (
  section_id INT NOT NULL,
  row_no INT NOT NULL,
  section_dept VARCHAR(50) NOT NULL,
  CONSTRAINT PK_Shelf PRIMARY KEY (section_id, row_no)
);

INSERT INTO shelf (section_id, row_no, Department) VALUES 
(1, 1, 'Novels'),
(1, 2, 'Fiction'),
(2, 1, 'Math'),
(2, 2, 'Physics'),
(3, 1, 'chemistry');

CREATE TABLE PlacedOn (
  book_id INT,
  section_id INT,
  row_no INT,
  FOREIGN KEY (section_id, row_no) REFERENCES shelf (section_id, row_no),
  FOREIGN KEY (book_id) REFERENCES book (book_id)
);

INSERT INTO PlacedOn (book_id, section_id, row_no) VALUES  
(1,	1,	1),
(2,	1,	1),
(3,	1,	1),
(4,1	,1),
(5,	1,	1),
(6,	1,	2),
(7,	1,	2),
(8	,1,	2),
(9,	1,	2),
(10,	1,	2),
(11,	2,	1),
(12,	2,	1),
(13,	2,	1),
(14,	2,	1),
(15,	2,	1),
(16,	2,	2),
(17,	2,	2),
(18,	2,	2),
(19,	2,	2),
(20,	2,	2),
(21,	3,	1),
(22,	3,	1),
(23,	3,	1),
(24,	3,	1),
(25,	3,	1);

select * from PlacedOn;

CREATE TABLE book_issue (
  issue_id int not null auto_increment,
  book_id INT NOT NULL,
  email VARCHAR(50) NOT NULL,
  issue_date VARCHAR(50) NOT NULL,
  CONSTRAINT pk_issue PRIMARY KEY (issue_id)
);


CREATE TABLE author (
  author_id INT NOT NULL,
  author_name varchar(500) DEFAULT NULL,
  CONSTRAINT pk_author PRIMARY KEY (author_id)
);

INSERT INTO author (author_id, author_name) VALUES
(1, 'J K Rowling'),
(2, 'Stephen King'),
(3, 'Margaret Atwood'),
(4, 'James Baldwin'),
(5, 'Jane Austen'),
(6, 'Gabriel Garcia Marquez'),
(7, 'Chimamanda Ngozi Adichie'),
(8, 'Toni Morrison'),
(9, 'Haruki Murakami'),
(10, 'Salman Rushdie');


CREATE TABLE publisher (
  publisher_id INT NOT NULL,
  publisher_name varchar(500) DEFAULT NULL,
  CONSTRAINT pk_publisher PRIMARY KEY (publisher_id)
);

INSERT INTO publisher (publisher_id, publisher_name) VALUES
( 11, 'Penguin Random House'),
( 12, 'HarperCollins'),
( 13, 'Simon & Schuster'),
( 14,'Hachette Livre'),
( 15, 'Macmillan Publishers'),
( 16, 'Scholastic Corporation'),
( 17, 'Bloomsbury Publishing'),
( 18, 'Pearson Education'),
( 19, 'Oxford University Press'),
( 20, 'Cambridge University Press');

CREATE TABLE purchase (
  purchase_id INT NOT NULL,
  price INT NOT NULL,
  purchase_date DATE ,
  CONSTRAINT PK_purchase PRIMARY KEY (purchase_id)
);

INSERT INTO purchase (purchase_id, price, purchase_date) VALUES 
(1, 50, '2022-02-01'),
(2, 20, '2022-01-03'),
(3, 75, '2022-02-15'),
(4, 35, '2022-01-12'),
(5, 60, '2022-02-22'),
(6, 45, '2022-01-05'),
(7, 25, '2022-01-05'),
(8, 55, '2022-02-10'),
(9, 40, '2022-01-17'),
(10, 30, '2022-02-28');





CREATE TABLE student (
  UserID INT NOT NULL,
  Program VARCHAR(50),
  MaxBooks INT CHECK (MaxBooks <= 6),
  CONSTRAINT PK_Student PRIMARY KEY (UserID),
  CONSTRAINT FK_Student_User FOREIGN KEY (UserID) REFERENCES library.users (UserID)
);

CREATE TABLE faculty (
  UserID INT NOT NULL,
  Dept VARCHAR(50) NOT NULL,
  Office VARCHAR(50),
  CONSTRAINT PK_Faculty PRIMARY KEY (UserID),
  CONSTRAINT FK_Faculty_User FOREIGN KEY (UserID) REFERENCES library.users (UserID)
);

INSERT INTO student (UserID, Program, MaxBooks) VALUES 
(1, 'Computer Science', 5),
(2, 'Business', 3),
(3, 'Psychology', 6),
(4, 'Engineering', 4),
(5, 'Nursing', 2);

INSERT INTO faculty (UserID, Dept, Office) VALUES 

(6, 'History', 'H567'),
(7, 'Mathematics', 'M890'),
(8, 'English', 'E123'),
(9, 'Biology', 'B456'),
(10, 'Education', 'E789');

CREATE TABLE issue (
  issue_id INT NOT NULL,
  issue_date date,
  UserId int not null,
  book_id int not null,
  due_date date,
  CONSTRAINT pk_issue PRIMARY KEY (issue_id),
  CONSTRAINT fk_user FOREIGN KEY (UserId) REFERENCES library.users (UserId),
  CONSTRAINT fk_book FOREIGN KEY (book_id) REFERENCES library.book (book_id)
);
INSERT INTO issue (issue_id,issue_date,UserId,book_id, due_date ) VALUES 
( 21, '2022-05-07' ,1 ,1,'2022-05-10'),
( 22, '2022-08-11',2 ,2,'2022-08-21'),
( 23, '2022-11-15' ,3 ,4,'2022-11-29'),
( 24, '2023-02-19',4 ,6,'2023-02-21'),
( 25, '2023-06-23',5 ,7,'2023-06-28'),
( 26, '2023-09-27',6 ,9,'2023-09-30'),
( 27, '2023-12-31',7 ,10,'2024-01-07');


-- CREATE TABLE returnn (
--   return_id INT NOT NULL,
--   ReturnDate DATE NOT NULL,
--   fine_id INT DEFAULT NULL,
--   book_id INT NOT NULL,
--   issue_id INT NOT NULL,
--   UserID INT NOT NULL,
--   CONSTRAINT PK_Return PRIMARY KEY (return_id),
--   CONSTRAINT FK_Return_Fine FOREIGN KEY (fine_id) REFERENCES fine (fine_id),
--   CONSTRAINT FK_Return_Book FOREIGN KEY (book_id) REFERENCES book (book_id),
--   CONSTRAINT FK_Return_Issue FOREIGN KEY (issue_id) REFERENCES issue (issue_id),
--   CONSTRAINT FK_Return_User FOREIGN KEY (UserID) REFERENCES users (UserID)
-- );

-- INSERT INTO returnn (return_id, ReturnDate, fine_id, book_id, issue_id, UserID) VALUES 
-- (1, '2022-05-13', 1, 1, 21, 1),
-- (2, '2022-08-18', 2, 2, 22, 2),
-- (3, '2022-11-25', 3, 4, 23, 3),
-- (4, '2023-02-28', 4, 6, 24, 4),
-- (5, '2023-06-27', NULL, 7, 25, 5),
-- (6, '2023-09-29', NULL, 9, 26, 6),
-- (7, '2023-12-31', NULL, 10, 27, 7);

-- select * from book;
select * from login_db;
SELECT * FROM login_db WHERE email = 'Jaggi@gmail.com';

use librarysystem;
show tables;
-- DELETE FROM users_credentials WHERE UserPassword='gs';
-- DELETE FROM users WHERE first_name ='gaju';
select * from users;
select * from users_credentials;
DESCRIBE users;
-- drop table book_issue;
select * from book;

select * from book_issue;