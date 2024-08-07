set serveroutput on;
DECLARE
  CURSOR c_customers IS
    SELECT c.CustomerID, l.LoanID, l.InterestRate
    FROM Customers c
    JOIN Loans l ON c.CustomerID = l.CustomerID
    WHERE MONTHS_BETWEEN(SYSDATE, c.DOB) / 12 > 60;
    
  v_customer_id Customers.CustomerID%TYPE;
  v_loan_id Loans.LoanID%TYPE;
  v_interest_rate Loans.InterestRate%TYPE;
BEGIN
  OPEN c_customers;
  LOOP
    FETCH c_customers INTO v_customer_id, v_loan_id, v_interest_rate;
    EXIT WHEN c_customers%NOTFOUND;

    UPDATE Loans
    SET InterestRate = v_interest_rate - 1
    WHERE LoanID = v_loan_id;
  END LOOP;
  CLOSE c_customers;
  DBMS_OUTPUT.PUT_LINE('Operation Completed');
  COMMIT;
END;
/


--SCENARIO 2
ALTER TABLE Customers ADD (IsVIP VARCHAR2(3));

DECLARE
  CURSOR c_customers IS
    SELECT CustomerID, Balance
    FROM Customers
    WHERE Balance > 10000;
    
  v_customer_id Customers.CustomerID%TYPE;
  v_balance Customers.Balance%TYPE;
BEGIN
  OPEN c_customers;
  LOOP
    FETCH c_customers INTO v_customer_id, v_balance;
    EXIT WHEN c_customers%NOTFOUND;
    
    UPDATE Customers
    SET IsVIP = 'YES'
    WHERE CustomerID = v_customer_id;
  END LOOP;
  CLOSE c_customers;
  
  COMMIT;
END;
/

-- SCENARIO 3
set serveroutput on;
DECLARE
  CURSOR c_loans IS
    SELECT c.CustomerID, c.Name, l.LoanID, l.EndDate
    FROM Loans l
    JOIN Customers c ON c.CustomerID = l.CustomerID
    WHERE l.EndDate BETWEEN SYSDATE AND SYSDATE + 30;
    
  v_customer_id Customers.CustomerID%TYPE;
  v_customer_name Customers.Name%TYPE;
  v_loan_id Loans.LoanID%TYPE;
  v_end_date Loans.EndDate%TYPE;
BEGIN
  OPEN c_loans;
  LOOP
    FETCH c_loans INTO v_customer_id, v_customer_name, v_loan_id, v_end_date;
    EXIT WHEN c_loans%NOTFOUND;
    
    DBMS_OUTPUT.PUT_LINE('Reminder: Loan ' || v_loan_id || ' for customer :' || v_customer_name || ' is due on ' || TO_CHAR(v_end_date, 'YYYY-MM-DD'));
  END LOOP;
  CLOSE c_loans;
END;
