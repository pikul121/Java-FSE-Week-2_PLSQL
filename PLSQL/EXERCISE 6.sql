--SCENARIO 1
DECLARE
    CURSOR c_transactions IS
        SELECT c.CustomerID, c.Name, t.TransactionDate, t.Amount, t.TransactionType
        FROM Customers c
        JOIN Accounts a ON c.CustomerID = a.CustomerID
        JOIN Transactions t ON a.AccountID = t.AccountID
        WHERE t.TransactionDate BETWEEN TRUNC(SYSDATE, 'MM') AND LAST_DAY(SYSDATE);
        
    v_CustomerID Customers.CustomerID%TYPE;
    v_Name Customers.Name%TYPE;
    v_TransactionDate Transactions.TransactionDate%TYPE;
    v_Amount Transactions.Amount%TYPE;
    v_TransactionType Transactions.TransactionType%TYPE;
BEGIN
    OPEN c_transactions;
    LOOP
        FETCH c_transactions INTO v_CustomerID, v_Name, v_TransactionDate, v_Amount, v_TransactionType;
        EXIT WHEN c_transactions%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE('Customer: ' || v_Name || ', Date: ' || TO_CHAR(v_TransactionDate, 'YYYY-MM-DD') ||
                             ', Amount: ' || v_Amount || ', Type: ' || v_TransactionType);
    END LOOP;
    CLOSE c_transactions;
END;
/
--SCENARIO 2
DECLARE
    CURSOR c_accounts IS
        SELECT AccountID, Balance
        FROM Accounts;
        
    v_AccountID Accounts.AccountID%TYPE;
    v_Balance Accounts.Balance%TYPE;
    v_AnnualFee CONSTANT NUMBER := 50; -- Define the annual fee here
BEGIN
    OPEN c_accounts;
    LOOP
        FETCH c_accounts INTO v_AccountID, v_Balance;
        EXIT WHEN c_accounts%NOTFOUND;
        
        UPDATE Accounts
        SET Balance = v_Balance - v_AnnualFee,
            LastModified = SYSDATE
        WHERE AccountID = v_AccountID;
    END LOOP;
    CLOSE c_accounts;
    COMMIT;
END;
/
--SCENARIO 3
DECLARE
    CURSOR c_loans IS
        SELECT LoanID, InterestRate
        FROM Loans;
        
    v_LoanID Loans.LoanID%TYPE;
    v_InterestRate Loans.InterestRate%TYPE;
    v_NewInterestRate CONSTANT NUMBER := 6; -- Define the new interest rate here
BEGIN
    OPEN c_loans;
    LOOP
        FETCH c_loans INTO v_LoanID, v_InterestRate;
        EXIT WHEN c_loans%NOTFOUND;
        
        UPDATE Loans
        SET InterestRate = v_NewInterestRate
        WHERE LoanID = v_LoanID;
    END LOOP;
    CLOSE c_loans;
    COMMIT;
END;
/
