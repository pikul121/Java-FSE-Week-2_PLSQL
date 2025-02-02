--SCENARIO 1
CREATE OR REPLACE PACKAGE CustomerManagement AS
    PROCEDURE AddCustomer(
        p_CustomerID IN NUMBER, 
        p_Name IN VARCHAR2, 
        p_DOB IN DATE, 
        p_Balance IN NUMBER);
        
    PROCEDURE UpdateCustomer(
        p_CustomerID IN NUMBER, 
        p_Name IN VARCHAR2, 
        p_DOB IN DATE, 
        p_Balance IN NUMBER);
        
    FUNCTION GetCustomerBalance(
        p_CustomerID IN NUMBER) 
        RETURN NUMBER;
END CustomerManagement;
/
CREATE OR REPLACE PACKAGE BODY CustomerManagement AS
    PROCEDURE AddCustomer(
        p_CustomerID IN NUMBER, 
        p_Name IN VARCHAR2, 
        p_DOB IN DATE, 
        p_Balance IN NUMBER) IS
    BEGIN
        INSERT INTO Customers (CustomerID, Name, DOB, Balance, LastModified)
        VALUES (p_CustomerID, p_Name, p_DOB, p_Balance, SYSDATE);
    END AddCustomer;
    
    PROCEDURE UpdateCustomer(
        p_CustomerID IN NUMBER, 
        p_Name IN VARCHAR2, 
        p_DOB IN DATE, 
        p_Balance IN NUMBER) IS
    BEGIN
        UPDATE Customers
        SET Name = p_Name, DOB = p_DOB, Balance = p_Balance, LastModified = SYSDATE
        WHERE CustomerID = p_CustomerID;
    END UpdateCustomer;
    
    FUNCTION GetCustomerBalance(
        p_CustomerID IN NUMBER) 
        RETURN NUMBER IS
        v_Balance NUMBER;
    BEGIN
        SELECT Balance INTO v_Balance
        FROM Customers
        WHERE CustomerID = p_CustomerID;
        
        RETURN v_Balance;
    END GetCustomerBalance;
END CustomerManagement;
/
--SCENARIO 2
CREATE OR REPLACE PACKAGE EmployeeManagement AS
    PROCEDURE HireEmployee(
        p_EmployeeID IN NUMBER, 
        p_Name IN VARCHAR2, 
        p_Position IN VARCHAR2, 
        p_Salary IN NUMBER, 
        p_Department IN VARCHAR2, 
        p_HireDate IN DATE);
        
    PROCEDURE UpdateEmployee(
        p_EmployeeID IN NUMBER, 
        p_Name IN VARCHAR2, 
        p_Position IN VARCHAR2, 
        p_Salary IN NUMBER, 
        p_Department IN VARCHAR2);
        
    FUNCTION CalculateAnnualSalary(
        p_EmployeeID IN NUMBER) 
        RETURN NUMBER;
END EmployeeManagement;
/
CREATE OR REPLACE PACKAGE BODY EmployeeManagement AS
    PROCEDURE HireEmployee(
        p_EmployeeID IN NUMBER, 
        p_Name IN VARCHAR2, 
        p_Position IN VARCHAR2, 
        p_Salary IN NUMBER, 
        p_Department IN VARCHAR2, 
        p_HireDate IN DATE) IS
    BEGIN
        INSERT INTO Employees (EmployeeID, Name, Position, Salary, Department, HireDate)
        VALUES (p_EmployeeID, p_Name, p_Position, p_Salary, p_Department, p_HireDate);
    END HireEmployee;
    
    PROCEDURE UpdateEmployee(
        p_EmployeeID IN NUMBER, 
        p_Name IN VARCHAR2, 
        p_Position IN VARCHAR2, 
        p_Salary IN NUMBER, 
        p_Department IN VARCHAR2) IS
    BEGIN
        UPDATE Employees
        SET Name = p_Name, Position = p_Position, Salary = p_Salary, Department = p_Department
        WHERE EmployeeID = p_EmployeeID;
    END UpdateEmployee;
    
    FUNCTION CalculateAnnualSalary(
        p_EmployeeID IN NUMBER) 
        RETURN NUMBER IS
        v_Salary NUMBER;
    BEGIN
        SELECT Salary INTO v_Salary
        FROM Employees
        WHERE EmployeeID = p_EmployeeID;
        
        RETURN v_Salary * 12;
    END CalculateAnnualSalary;
END EmployeeManagement;
/
--SCENARIO 3
CREATE OR REPLACE PACKAGE AccountOperations AS
    PROCEDURE OpenAccount(
        p_AccountID IN NUMBER, 
        p_CustomerID IN NUMBER, 
        p_AccountType IN VARCHAR2, 
        p_Balance IN NUMBER);
        
    PROCEDURE CloseAccount(
        p_AccountID IN NUMBER);
        
    FUNCTION GetTotalBalance(
        p_CustomerID IN NUMBER) 
        RETURN NUMBER;
END AccountOperations;
/
CREATE OR REPLACE PACKAGE BODY AccountOperations AS
    PROCEDURE OpenAccount(
        p_AccountID IN NUMBER, 
        p_CustomerID IN NUMBER, 
        p_AccountType IN VARCHAR2, 
        p_Balance IN NUMBER) IS
    BEGIN
        INSERT INTO Accounts (AccountID, CustomerID, AccountType, Balance, LastModified)
        VALUES (p_AccountID, p_CustomerID, p_AccountType, p_Balance, SYSDATE);
    END OpenAccount;
    
    PROCEDURE CloseAccount(
        p_AccountID IN NUMBER) IS
    BEGIN
        DELETE FROM Accounts
        WHERE AccountID = p_AccountID;
    END CloseAccount;
    
    FUNCTION GetTotalBalance(
        p_CustomerID IN NUMBER) 
        RETURN NUMBER IS
        v_TotalBalance NUMBER;
    BEGIN
        SELECT SUM(Balance) INTO v_TotalBalance
        FROM Accounts
        WHERE CustomerID = p_CustomerID;
        
        RETURN v_TotalBalance;
    END GetTotalBalance;
END AccountOperations;
/
--TESTING 
BEGIN
    CustomerManagement.AddCustomer(3, 'Alice Brown', TO_DATE('1980-03-25', 'YYYY-MM-DD'), 2000);
    CustomerManagement.UpdateCustomer(3, 'Alice Brown', TO_DATE('1980-03-25', 'YYYY-MM-DD'), 2500);
    DBMS_OUTPUT.PUT_LINE('Balance: ' || CustomerManagement.GetCustomerBalance(3));
END;
/
BEGIN
    EmployeeManagement.HireEmployee(3, 'Charlie Davis', 'Analyst', 50000, 'Finance', TO_DATE('2018-09-15', 'YYYY-MM-DD'));
    EmployeeManagement.UpdateEmployee(3, 'Charlie Davis', 'Senior Analyst', 55000, 'Finance');
    DBMS_OUTPUT.PUT_LINE('Annual Salary: ' || EmployeeManagement.CalculateAnnualSalary(3));
END;
/
BEGIN
    AccountOperations.OpenAccount(3, 1, 'Checking', 2000);
    AccountOperations.CloseAccount(3);
    DBMS_OUTPUT.PUT_LINE('Total Balance: ' || AccountOperations.GetTotalBalance(1));
END;
/


