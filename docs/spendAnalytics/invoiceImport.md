# Invoice Import

Invoices can be imported as a CSV file,  where each row in the file represents one line on the invoice.
Alternatively,  invoices can be imported from an Excel workbook,  containing separate worksheets for the Header, Lines and Finance Coding information.


## Importing invoices from an Excel Workbook
The workbook must contain a minimum of three worksheets called : Invoices,  Lines and Coding


### Invoices Sheet
Each invoice must have a single row in the Invoice sheet.   The row has to be uniquely identified by the value in the ExternalID column.

|   Column Name   | Description | Required    |
| ----------------|------------ |------------ |
| BuyersCodeForSupplier | The code which uniquely identifies the supplier in the p2p system. | Yes |
| BuyersInvoiceNumber | |  |
| CompanyCode | |  |
| CreatedDate | |  |
| CurrencyCode | |  |
| DepartmentCode | |  |
| EnteredByUserID | |  |
| ExternalID | |  |
| ExternalSupplierID | |  |
| InvoiceDate | |  |
| IsInvoice | |  |
| IsOrderBased | |  |
| PaidDate | |  |
| PostedDate | |  |
| ReceivedDate | |  |
| SupplierInvoiceNumber | |  |
| SupplierTitle | |  |
| TotalNetValue | |  |
| TotalTaxValue | |  |
| Region | |  |
| InvoiceSource | |  |
| InvoiceStatus | |  |
| AddressLine1 | |  |
| AddressLine2 | |  |
| AddressLine3 | |  |
| AddressLine4 | |  |
| Country | |  |
| County | |  |
| PostCode | |  |
| PostTown | |  |