/*------------------------------------------------------------------------
  File        : ItemDataset.i
  Purpose     : Dataset definition for Item business entity
  Syntax      : 
  Description : Defines temp-table and dataset for Item operations
  Author(s)   : 
  Created     : Wed Jun 03 11:44:00 UTC 2026
  Notes       : Include file used by ItemEntity class
----------------------------------------------------------------------*/

DEFINE TEMP-TABLE ttItem NO-UNDO
    FIELD Itemnum       AS INTEGER
    FIELD ItemName      AS CHARACTER
    FIELD CatPage       AS INTEGER
    FIELD Price         AS DECIMAL
    FIELD CatDescription AS CHARACTER
    FIELD Onhand        AS INTEGER
    FIELD Allocated     AS INTEGER
    FIELD ReOrder       AS INTEGER
    FIELD OnOrder       AS INTEGER
    FIELD Category1     AS CHARACTER
    FIELD Category2     AS CHARACTER
    FIELD Special       AS CHARACTER
    FIELD Weight        AS DECIMAL
    FIELD Minqty        AS INTEGER
    INDEX idxItemNum IS PRIMARY UNIQUE Itemnum.

DEFINE DATASET dsItem
    FOR ttItem.

DEFINE DATA-SOURCE srcItem FOR Item.