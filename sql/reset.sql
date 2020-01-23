/* Reset the database */

/* Drop all tables */
DROP TABLE Transactions;
DROP TABLE ApplicationRequests;
DROP TABLE Employees;
DROP TABLE Customers;
DROP TABLE Users;
COMMIT;

/* Initialize tables for the banking app */
CREATE TABLE Users
(
    U_ID NUMBER NOT NULL,
    Username VARCHAR2(10) NOT NULL,
    Password VARCHAR2(10) NOT NULL,
    Type VARCHAR2(10) NOT NULL,
    
    CONSTRAINT USER_PK PRIMARY KEY (U_ID)
);

CREATE TABLE Customers
(
    C_ID NUMBER NOT NULL,
    Username VARCHAR2(10) NOT NULL,
    Balance NUMBER NOT NULL,
    Status NUMBER NOT NULL,
    
    CONSTRAINT CUSTOMER_PK PRIMARY KEY (C_ID),
    CONSTRAINT CUSTOMER_FK FOREIGN KEY (C_ID) REFERENCES Users (U_ID)
);

CREATE TABLE Employees
(
    E_ID NUMBER NOT NULL,
    Username VARCHAR2(10) NOT NULL,
    C_Username VARCHAR2(10) NULL,
    
    CONSTRAINT EMPLOYEE_PK PRIMARY KEY (E_ID),
    CONSTRAINT EMPLOYEE_FK FOREIGN KEY (E_ID) REFERENCES Users (U_ID)
);

CREATE TABLE ApplicationRequests
(
    A_ID NUMBER NOT NULL,
    C_ID NUMBER NOT NULL,
    C_Username VARCHAR2(10) NOT NULL,
    
    CONSTRAINT APPREQUEST_PK PRIMARY KEY (A_ID),
    CONSTRAINT APPREQUEST_CUSTOMER_FK FOREIGN KEY (C_ID) REFERENCES Customers (C_ID)
);

CREATE TABLE Transactions
(
    C_Username VARCHAR2(10) NOT NULL,
    Balance NUMBER
);

COMMIT;

/* Initialize sequence and triggers */
-- Drop Sequences
DROP SEQUENCE Users_Seq;
DROP SEQUENCE AR_Seq;
COMMIT;

-- Sequences
CREATE SEQUENCE Users_Seq
    MINVALUE 1
    MAXVALUE 9999
    START WITH 1
    INCREMENT BY 1;
    
CREATE SEQUENCE AR_Seq
    MINVALUE 1
    MAXVALUE 9999
    START WITH 1
    INCREMENT BY 1;
    
-- Triggers
CREATE OR REPLACE TRIGGER New_Users_Trigger
    BEFORE INSERT ON Users
    FOR EACH ROW
    BEGIN
        SELECT Users_Seq.NEXTVAL INTO :new.U_ID FROM Dual;
    END;
/

CREATE OR REPLACE TRIGGER New_Customers_Trigger
    BEFORE INSERT ON Customers
    FOR EACH ROW
    BEGIN
        SELECT Users_Seq.CURRVAL INTO :new.C_ID FROM Dual;
    END;
/

CREATE OR REPLACE TRIGGER New_Employees_Trigger
    BEFORE INSERT ON Employees
    FOR EACH ROW
    BEGIN
        SELECT Users_Seq.CURRVAL INTO :new.E_ID FROM Dual;   
    END;
/

CREATE OR REPLACE TRIGGER New_AR_Trigger
    BEFORE INSERT ON ApplicationRequests
    FOR EACH ROW
    BEGIN
        SELECT AR_Seq.NEXTVAL INTO :new.A_ID FROM Dual;   
    END;
/
COMMIT;