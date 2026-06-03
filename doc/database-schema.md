# Sports2000 Database Schema

## Overview

This document provides a summary of the Sports2000 database schema used in this project. The full schema definition is available in `dump/sports2000.df`.

## Key Tables

### Customer
- **Purpose**: Stores customer information including balance and address
- **Key Fields**:
  - `CustNum` (INTEGER) - Primary key, customer number
  - `Name` (CHARACTER) - Customer name
  - `Address` (CHARACTER) - Street address
  - `City` (CHARACTER) - City
  - `State` (CHARACTER) - State/Province
  - `Country` (CHARACTER) - Country (default: USA)
  - `PostalCode` (CHARACTER) - Postal/ZIP code
  - `Phone` (CHARACTER) - Phone number
  - `Contact` (CHARACTER) - Contact person
  - `SalesRep` (CHARACTER) - Sales representative
  - `CreditLimit` (DECIMAL) - Credit limit (default: 1500)
  - `Balance` (DECIMAL) - Account balance
  - `Terms` (CHARACTER) - Payment terms (default: Net30)
  - `Discount` (INTEGER) - Discount percentage

### Item
- **Purpose**: Stores inventory item information
- **Key Fields**:
  - `ItemNum` (INTEGER) - Primary key, item number
  - `ItemName` (CHARACTER) - Item description
  - `Price` (DECIMAL) - Unit price
  - `Onhand` (INTEGER) - Quantity on hand
  - `Allocated` (INTEGER) - Quantity allocated
  - `ReOrder` (INTEGER) - Reorder point
  - `OnOrder` (INTEGER) - Quantity on order

### Order
- **Purpose**: Stores customer orders
- **Key Fields**:
  - `OrderNum` (INTEGER) - Primary key, order number
  - `CustNum` (INTEGER) - Foreign key to Customer
  - `OrderDate` (DATE) - Order date
  - `ShipDate` (DATE) - Ship date
  - `PromiseDate` (DATE) - Promised delivery date

### OrderLine
- **Purpose**: Stores line items for orders
- **Key Fields**:
  - `OrderNum` (INTEGER) - Foreign key to Order
  - `LineNum` (INTEGER) - Line number
  - `ItemNum` (INTEGER) - Foreign key to Item
  - `Quantity` (INTEGER) - Quantity ordered
  - `UnitPrice` (DECIMAL) - Unit price

### SalesRep
- **Purpose**: Stores sales representative information
- **Key Fields**:
  - `RepCode` (CHARACTER) - Primary key, sales rep code
  - `RepName` (CHARACTER) - Sales rep name
  - `Region` (CHARACTER) - Sales region

## Sequences

The database includes several sequences for auto-generating key values:
- `NextCustNum` - For customer numbers (starts at 1000)
- `NextOrdNum` - For order numbers (starts at 1000)
- `NextItemNum` - For item numbers (starts at 100)
- `NextInvNum` - For invoice numbers (starts at 1000)

## Relationships

- Customer → Orders (One-to-Many via CustNum)
- Order → OrderLine (One-to-Many via OrderNum)
- Item → OrderLine (One-to-Many via ItemNum)
- SalesRep → Customer (One-to-Many via RepCode)

## Usage in This Project

This schema is used by the business entity classes:
- `CustomerEntity` works with the Customer table
- `ItemEntity` works with the Item table
- Dataset definitions in `src/business/` map to these tables

The schema file (`dump/sports2000.df`) can be used to create the database in your OpenEdge environment using the `prodb` utility.