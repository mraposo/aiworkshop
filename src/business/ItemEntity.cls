/*------------------------------------------------------------------------
  File        : ItemEntity.cls
  Purpose     : Business entity class for Item operations
  Syntax      : 
  Description : Encapsulates Item business logic, validation, and data access
  Author(s)   : 
  Created     : Wed Jun 03 11:44:00 UTC 2026
  Notes       : Inherits from BusinessEntity base class
----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING OpenEdge.BusinessLogic.BusinessEntity.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS business.ItemEntity INHERITS BusinessEntity:

    {business/ItemDataset.i}

    DEFINE DATA-SOURCE srcItem FOR Item.

    /*------------------------------------------------------------------------------
     Purpose: Constructor - initializes the entity with dataset and data source
     Notes:
    ------------------------------------------------------------------------------*/
    CONSTRUCTOR PUBLIC ItemEntity():
        SUPER(DATASET dsItem:HANDLE).

        VAR HANDLE[1] hDataSourceArray = DATA-SOURCE srcItem:HANDLE.
        VAR CHARACTER[1] cSkipListArray = [""].

        /* Data Source for each table in dataset */
        THIS-OBJECT:ProDataSource = hDataSourceArray.
        /* Skip-list entry for each table in dataset */
        THIS-OBJECT:SkipList = cSkipListArray.
    END CONSTRUCTOR.

    /*------------------------------------------------------------------------------
     Purpose: Retrieve an item by item number
     Notes:   Populates the ttItem temp-table with the found record
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC LOGICAL GetItemByNumber(INPUT ipiItemNum AS INTEGER,
                                           OUTPUT DATASET dsItem):
        DEFINE VARIABLE cFilter AS CHARACTER NO-UNDO.

        /* Build filter for item number */
        cFilter = "WHERE Item.Itemnum = " + STRING(ipiItemNum).

        /* Read data using filter */
        THIS-OBJECT:ReadData(cFilter).

        /* Check if item was found */
        RETURN CAN-FIND(FIRST ttItem).
    END METHOD.

    /*------------------------------------------------------------------------------
     Purpose: Validate item data before persistence
     Notes:   Checks business rules: price not zero, total value limit
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC LOGICAL ValidateItem(
        INPUT-OUTPUT DATASET dsItem,
        OUTPUT opcErrorMessage AS CHARACTER):

        DEFINE VARIABLE dTotalValue AS DECIMAL NO-UNDO.

        FIND FIRST ttItem NO-ERROR.
        IF AVAILABLE ttItem THEN DO:
            /* Validate price is not zero */
            IF ttItem.Price = 0 THEN DO:
                opcErrorMessage = "Price cannot be empty".
                RETURN FALSE.
            END.

            /* Validate total value on hand does not exceed 6000 */
            dTotalValue = ttItem.Onhand * ttItem.Price.
            IF dTotalValue > 6000 THEN DO:
                opcErrorMessage = "Total value onhand will be " + STRING(dTotalValue) +
                                  ", should not be larger than 6000".
                RETURN FALSE.
            END.
        END.

        opcErrorMessage = "".
        RETURN TRUE.
    END METHOD.

    /*------------------------------------------------------------------------------
     Purpose: Update item data in database
     Notes:   Assumes data has been validated before calling
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC VOID UpdateItem(INPUT-OUTPUT DATASET dsItem):
        THIS-OBJECT:UpdateData(DATASET dsItem BY-REFERENCE).
    END METHOD.

    /*------------------------------------------------------------------------------
     Purpose: Get the current price from temp-table
     Notes:   Helper method for UI binding
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC DECIMAL GetPrice():
        IF AVAILABLE ttItem THEN
            RETURN ttItem.Price.
        ELSE
            RETURN 0.
    END METHOD.

    /*------------------------------------------------------------------------------
     Purpose: Set the price in temp-table
     Notes:   Used before validation and update
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC VOID SetPrice(INPUT ipdPrice AS DECIMAL):
        IF AVAILABLE ttItem THEN
            ttItem.Price = ipdPrice.
    END METHOD.

END CLASS.
