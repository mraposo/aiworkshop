# ABL Testing Best Practices

## Test Structure

**Always use explicit test case documentation:**
- Include test number, description, and expected result in comments
- Use consistent formatting for test output
- Track pass/fail counts with `iPass` and `iFail` variables

**Incorrect:**
```abl
iCount = oRepo:GetOrderLineCountByCustomer(INPUT 1).
MESSAGE iCount.
```

**Correct:**
```abl
/* Test 1: Customer with expected orders (positive test) */
iTest = 1.
iCount = oRepo:GetOrderLineCountByCustomer(INPUT iTest).
PUT UNFORMATTED "Test 1: Customer " iTest " - Expected: >0, Got: " iCount.
IF iCount > 0 THEN DO:
    PUT UNFORMATTED " [PASS]" SKIP.
    iPass = iPass + 1.
END.
ELSE DO:
    PUT UNFORMATTED " [FAIL]" SKIP.
    iFail = iFail + 1.
END.
```

## Test Coverage

**Include these test types in every test suite:**

1. **Positive tests** - Valid inputs that should return results
2. **Negative tests** - Invalid/non-existent inputs that should return 0 or error
3. **Edge cases** - Boundary values (0, negative numbers, very large numbers, empty strings)
4. **Null/Unknown tests** - Where applicable, test `?` (Unknown value)

## Naming Conventions

**Test procedures:**
- Use prefix `test` followed by method name being tested
- Example: `testGetOrderLineCount.p`, `testCalculateTotal.p`

**Test variables:**
- `iTest` - Current test case number or input value
- `iCount`/`iResult` - Result from method under test
- `iPass`/`iFail` - Counters for test results
- `lSuccess` - Logical flag for boolean results

## Assertions

**Always assert expected vs actual:**
```abl
IF iResult = iExpected THEN
    /* PASS */
ELSE
    /* FAIL */
```

**Never assume success:**
```abl
/* Incorrect - always passes */
iResult = oRepo:SomeMethod(INPUT iTest).
PUT UNFORMATTED "Test passed" SKIP.
iPass = iPass + 1.
```

## Output Format

**Use consistent test output:**
```abl
PUT UNFORMATTED "Test " iTestNum ": " pcDescription 
    " - Expected: " iExpected ", Got: " iActual.
```

**Always include a summary:**
```abl
PUT UNFORMATTED SKIP "=== Test Summary ===" SKIP.
PUT UNFORMATTED "Passed: " iPass SKIP.
PUT UNFORMATTED "Failed: " iFail SKIP.
PUT UNFORMATTED "Total:  " iPass + iFail SKIP.
```

## Error Handling

**Use BLOCK-LEVEL error handling:**
```abl
BLOCK-LEVEL ON ERROR UNDO, THROW.
```

**Clean up resources:**
```abl
FINALLY:
    IF VALID-OBJECT(oRepo) THEN
        DELETE OBJECT oRepo.
END.
```

## Database Access

**Always use explicit named buffers:**
```abl
DEFINE BUFFER bCustomer FOR Customer.
FOR EACH bCustomer WHERE bCustomer.Country = "USA":
    /* ... */
END.
```

**Use NO-LOCK for read-only queries:**
```abl
FOR EACH bOrder NO-LOCK WHERE bOrder.CustNum = piCustNum:
    /* ... */
END.
```