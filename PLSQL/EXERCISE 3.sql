--SCENARIO 1
CREATE OR REPLACE PROCEDURE ProcessMonthlyInterest AS
BEGIN
    UPDATE Accounts
    SET Balance = Balance * 1.01, 
        LastModified = SYSDATE
    WHERE AccountType = 'Savings';
END;
/
--SCENARIO 2
CREATE OR REPLACE PROCEDURE UpdateEmployeeBonus(p_Department VARCHAR2, p_BonusPercentage NUMBER) AS
BEGIN
    UPDATE Employees
    SET Salary = Salary * (1 + p_BonusPercentage / 100)
    WHERE Department = p_Department;
END;
/
--SCENARIO 3
CREATE OR REPLACE PROCEDURE TransferFunds(p_SourceAccountID NUMBER, p_TargetAccountID NUMBER, p_Amount NUMBER) AS
    v_SourceBalance Accounts.Balance%TYPE;
BEGIN
    -- Checking if the account has sufficient balance or not
    SELECT Balance INTO v_SourceBalance
    FROM Accounts
    WHERE AccountID = p_SourceAccountID
    FOR UPDATE;

    IF v_SourceBalance >= p_Amount THEN
        -- Deducting the amount from the source account
        UPDATE Accounts
        SET Balance = Balance - p_Amount,
            LastModified = SYSDATE
        WHERE AccountID = p_SourceAccountID;

        -- Adding the amount to the destination account
        UPDATE Accounts
        SET Balance = Balance + p_Amount,
            LastModified = SYSDATE
        WHERE AccountID = p_TargetAccountID;
    ELSE
        RAISE_APPLICATION_ERROR(-20001, 'Insufficient balance in the source account.');
    END IF;
END;
/
SELECT * FROM Employees;
SELECT * FROM Customers;
SELECT * FROM Accounts;
