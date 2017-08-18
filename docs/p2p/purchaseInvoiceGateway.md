# Purchase Invoice Gateway

## Summary

This document describes the structure of the XML file used for importing Purchase Invoices into PROACTIS.  It is assumed that the reader of the document is familiar both with XML and PROACTIS invoicing.

The document also describes the validation rules, which must be passed in order for the invoice to be imported, and the current limitations of the invoice matching gateway.

This document should be used in conjunction with the **ImportPurchaseInvoices.xsd** xml schema


## Limitations of the Gateway

The current release of the invoice gateway is subjected to the following invoice matching limitations.  

* It is not possible to set the supplier’s branch on the invoice.  The default invoicing branch will be selected.
* The imported invoice cannot contain items which are not on the original orders.  Unexpected items are NOT supported.
* The quantity on the invoice cannot exceed the quantity expected from the order unless complete nominal information is included in the import file.
* The Invoice Gateway only supports the import of external invoices.  To import internal invoices, use the Internal Invoice Gateway.
* If the quantity on an order exceeds the quantity on the invoice, then the quantity will be allocated to the line nominals in a first-come-first-served basis.
* Withholding tax is not supported
* As with the other XML gateways, an XML document can only contain documents for a single company.
* As with the other XML gateways, an XML document can only contain documents for a single department.
* The schema, documentation and error messages are all written in English.


## Order Based Invoices - Worked Example

This section of the document walks you through the creation of a simple document. 

### XML Document

The xml document must start with the following to lines

```xml
<?xml version="1.0" ?>
<pro:Import xmlns:pro="[http://www.proactis.com/xml/xml-ns](http://www.proactis.com/xml/xml-ns)">
```

And finish with

```xml
</pro:Import>
```

### Control Block

A control block must then be included so that the gateway knows which database and company to import the documents into.  This has the same structure as the control block for the other XML gateways.

An example control block is shown below.

```xml
 <pro:Control DatabaseName="PROACTIS"
              UserName="DAVIDBETTERIDGE"
              Password="mysecret"
              Company="MAIN"
              Department="SOLUTIONS"
              Version="1.0.0" />
```

The XML gateway supports NT authentication, an example is shown below.

```xml
 <pro:Control    DatabaseName="PROACTIS\_LIVE"
                 AuthenticationMethod="WINDOWS"
                 Company="MAIN"
                 Department="SOLUTIONS"
                 Version="1.0.0" />
```

NB: The value of the __AuthenticationMethod__ field can be WINDOWS or PROACTIS (which must be expressed in Upper Case).  If this field is missing, the gateway will default to PROACTIS and work as before.

### Invoice

The next section contains the details of the invoices to be imported.  The gateway allows multiple claims to be included in a single xml document.  At least one invoice must be included.

```xml
<pro:Invoice  InvoiceDate='2003-08-27'              
              SupplierInvoiceNumber='PR-234' 
              Template='PINV' 
              Tray='Standard' 
              GrossValue='1'
              Supplier='510632'
              ImageReference='10'/>
```

###  Notes
* The template must be an invoicing template, which the user has access to.
* If the template is not provided, then the gateway attempts to automatically select one.  This is only possible if the user only has access to a single template.  In order to pick a template, the gateway must first determine if the invoice is a stand-alone or order based.
* The gateway assumes the invoice is a standalone invoice if either
  * One or more non-order items are supplied
  * The authorisation pool is specified

  Otherwise, the invoice is treated as an order based invoice.
  
* The tray must an invoicing tray, which the user has access to.
* If the tray is missing, then the user’s default tray is used.
* The supplier invoice number must unique for this supplier
* The invoice date should be in the format yyyy-mm-dd
* The ImageReference value also supports Settlement Discount, so if you have settlement discount switched on; use this field to enter the percentage discount – this must be a number only if settlement discount is active.
* Post-match authorisation is supported by the invoice XML gateway – simply activate this property on the supplier and set the supplier on the invoice… post-match authorisation will be adopted.
* The Supplier attribute must be set if the invoice has no related purchase orders, or the supplier is a one-off supplier.
* The authorisation pool must be supplied if the template is used for standalone invoices.  (The pool can’t be supplied if the template isn’t used for standalone invoices).

### Invoice Items
Then the orders and items against which the invoice will be matched are listed.

```xml
<pro:ParentOrders>                   
  <pro:ParentOrder    OrderNumber='PORD10034'>
    <pro:Item    Position='1'   Value='1'/>
    <pro:Item    Position='2'   Price='1'  Quantity='1'>
              <pro:Nominals>
                      <pro:Nominal   Code='ABC.XYZ'   Quantity='1' CommitmentDate='2005-12-18' />
              </pro:Nominals>
    </pro:Item> 
</pro:ParentOrder>
</pro:ParentOrders>
```

### Notes
* The items refer to the item lines on the orders, not the nominal period lines.  Quantities will be allocated to the nominals on a first-come-first-severed basis if the details are not specified in the import document.
* Depending on the type of item, either the Price plus Quantity should be provided or the Value.
* The position is used to specify the item on the purchase order or an order amendment. For example, if the order has three lines, and has an amendment for an additional line, then a position of 4 would refer to the new line on the order amendment.
* If no parent orders are specified then the invoice can only be registered.  In this case, the supplier must set.
* In additional to the nominal coding, a commitment date can also be specified to help identify the order nominal to invoice.

