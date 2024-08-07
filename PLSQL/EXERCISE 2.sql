CREATE OR REPLACE PROCEDURE SafeTransferFunds (
  p_from_account_id IN NUMBER,
  p_to_account_id IN NUMBER,
  p_amount IN NUMBER
) IS
  e_insufficient_funds EXCEPTION;
  v_from_balance NUMBER;
BEGIN
  -- Getting account balance
  SELECT Balance INTO v_from_balance
  FROM Accounts
  WHERE AccountID = p_from_account_id
  FOR UPDATE;
  
  -- Checking if the account have sufficient balance or not
  IF v_from_balance < p_amount THEN
    RAISE e_insufficient_funds;
  END IF;
  
  -- Deducting ammount from the account
  UPDATE Accounts
  SET Balance = Balance - p_amount
  WHERE AccountID = p_from_account_id;
  
  -- Adding balance to the destination account
  UPDATE Accounts
  SET Balance = Balance + p_amount
  WHERE AccountID = p_to_account_id;
  
  COMMIT;
EXCEPTION
  WHEN e_insufficient_funds THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('Error: Insufficient funds in the source account.');
  WHEN OTHERS THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END ;
/


--Q2. Write a stored procedure UpdateSalary that increases the salary of an employee by a given percentage. If the employee ID does not exist, handle the exception and log an error message.
CREATE OR REPLACE PROCEDURE UpdateSalary (
  p_employee_id IN NUMBER,
  p_percentage IN NUMBER
) IS
  v_current_salary Employees.Salary%TYPE;
BEGIN
  -- Getting salary of the employee
  SELECT Salary INTO v_current_salary
  FROM Employees
  WHERE EmployeeID = p_employee_id
  FOR UPDATE;
  
  -- Updating the salary of employee
  UPDATE Employees
  SET Salary = v_current_salary * (1 + p_percentage / 100)
  WHERE EmployeeID = p_employee_id;
  
  COMMIT;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('Error: Employee ID ' || p_employee_id || ' does not exist.');
  WHEN OTHERS THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/


-- Q3. Write a stored procedure AddNewCustomer that inserts a new customer into the Customers table. If a customer with the same ID already exists, handle the exception by logging an error and preventing the insertion.
CREATE OR REPLACE PROCEDURE AddNewCustomer (
  p_customer_id IN NUMBER,
  p_name IN VARCHAR2,
  p_dob IN DATE,
  p_balance IN NUMBER
) IS
BEGIN
  -- Inserting new customers
  INSERT INTO Customers (CustomerID, Name, DOB, Balance, LastModified)
  VALUES (p_customer_id, p_name, p_dob, p_balance, SYSDATE);
  
  COMMIT;
EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('Error: Customer with ID ' || p_customer_id || ' already exists.');
  WHEN OTHERS THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/
