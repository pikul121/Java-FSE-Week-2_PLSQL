--SCENARIO1
CREATE OR REPLACE FUNCTION CalculateAge (dob DATE)
RETURN NUMBER
IS
    v_age NUMBER;
BEGIN
    v_age := FLOOR(MONTHS_BETWEEN(SYSDATE, dob) / 12);
    RETURN v_age;
END CalculateAge;
/
--SCENARIO2
CREATE OR REPLACE FUNCTION CalculateMonthlyInstallment (
    loan_amount NUMBER,
    annual_interest_rate NUMBER,
    loan_duration_years NUMBER
)
RETURN NUMBER
IS
    v_monthly_interest_rate NUMBER;
    v_number_of_months NUMBER;
    v_monthly_installment NUMBER;
BEGIN
    v_monthly_interest_rate := annual_interest_rate / 12 / 100;
    v_number_of_months := loan_duration_years * 12;
    
    v_monthly_installment := loan_amount * v_monthly_interest_rate / 
                             (1 - POWER((1 + v_monthly_interest_rate), -v_number_of_months));
    
    RETURN v_monthly_installment;
END CalculateMonthlyInstallment;
/
--SCENARIO 3
CREATE OR REPLACE FUNCTION HasSufficientBalance (account_id NUMBER, amount NUMBER)
RETURN BOOLEAN
IS
    v_balance NUMBER;
BEGIN
    SELECT balance
    INTO v_balance
    FROM accounts
    WHERE account_id = account_id;

    IF v_balance >= amount THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END HasSufficientBalance;
/
DECLARE
    v_age NUMBER;
BEGIN
    v_age := CalculateAge(TO_DATE('1980-01-01', 'YYYY-MM-DD'));
    DBMS_OUTPUT.PUT_LINE('Age: ' || v_age);
END;
/
DECLARE
    v_installment NUMBER;
BEGIN
    v_installment := CalculateMonthlyInstallment(10000, 5, 2);
    DBMS_OUTPUT.PUT_LINE('Monthly Installment: ' || v_installment);
END;
/
