-- SCENARIO 1
CREATE OR REPLACE TRIGGER UpdateCustomerLastModified
BEFORE UPDATE ON Customers
FOR EACH ROW
BEGIN
  :NEW.LastModified := SYSDATE;
END;
/

-- SCENARIO 2
CREATE TABLE AuditLog (
  AuditID NUMBER PRIMARY KEY,
  TransactionID NUMBER,
  AccountID NUMBER,
  TransactionDate DATE,
  Amount NUMBER,
  TransactionType VARCHAR2(10),
  LogDate DATE
);
CREATE SEQUENCE AuditLog_SEQ START WITH 1 INCREMENT BY 1;
CREATE OR REPLACE TRIGGER LogTransaction
AFTER INSERT ON Transactions
FOR EACH ROW
BEGIN
  INSERT INTO AuditLog (AuditID, TransactionID, AccountID, TransactionDate, Amount, TransactionType, LogDate)
  VALUES (AuditLog_SEQ.NEXTVAL, :NEW.TransactionID, :NEW.AccountID, :NEW.TransactionDate, :NEW.Amount, :NEW.TransactionType, SYSDATE);
END;
/
-- SCENARIO 3
CREATE OR REPLACE TRIGGER CheckTransactionRules
BEFORE INSERT ON Transactions
FOR EACH ROW
DECLARE
  v_balance NUMBER;
BEGIN
  -- Getting the current balance of the account
  SELECT Balance INTO v_balance
  FROM Accounts
  WHERE AccountID = :NEW.AccountID
  FOR UPDATE;
  
  -- Checking if the transaction is a withdrawal
  IF :NEW.TransactionType = 'Withdrawal' THEN
    -- Ensure the withdrawal does not exceed the balance
    IF :NEW.Amount > v_balance THEN
      RAISE_APPLICATION_ERROR(-20001, 'Insufficient funds for withdrawal.');
    END IF;
  ELSIF :NEW.TransactionType = 'Deposit' THEN
    -- Ensure the deposit amount is positive
    IF :NEW.Amount <= 0 THEN
      RAISE_APPLICATION_ERROR(-20002, 'Deposit amount must be positive.');
    END IF;
  END IF;
END;
/
