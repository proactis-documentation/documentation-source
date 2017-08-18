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

---

## Order Based Invoices

This section of the document walks you through the creation of a simple order based invoice. 

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

The next section contains the details of the invoices to be imported.  The gateway allows multiple documents to be included in a single xml document.  At least one invoice must be included.

```xml
<pro:Invoice  InvoiceDate='2003-08-27'              
              SupplierInvoiceNumber='PR-234' 
              Template='PINV' 
              Tray='Standard' 
              GrossValue='1'
              Supplier='510632'
              ImageReference='10'/>
```

####  Notes
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

#### Notes
* The items refer to the item lines on the orders, not the nominal period lines.  Quantities will be allocated to the nominals on a first-come-first-severed basis if the details are not specified in the import document.
* Depending on the type of item, either the Price plus Quantity should be provided or the Value.
* The position is used to specify the item on the purchase order or an order amendment. For example, if the order has three lines, and has an amendment for an additional line, then a position of 4 would refer to the new line on the order amendment.
* If no parent orders are specified then the invoice can only be registered.  In this case, the supplier must set.
* In additional to the nominal coding, a commitment date can also be specified to help identify the order nominal to invoice.

### Tax
As well as the purchase orders, the invoice must also include the tax details.

```xml
<pro:TaxDetails>
  <pro:Tax Band='VAT' BandNumber='1' Code='STD' GrossValue='1.18' TaxValue='0.18'/>
 </pro:TaxDetails>
```

#### Notes
* If the TaxValue is missing, then it will be automatically calculated.
* The Band can be identified by either its name (Band) or number (BandNumber). If neither is specified then the first band is assumed.

### Supplier
If the supplier is a one-off supplier, then their address details must also be set.

```xml
<pro:SupplierAddress  Name='Accounts' 
                      Line1='12 The close' 
                      Line2='East Kettlewell' 
                      Line3='' 
                      Line4='' 
                      Town='YORK' 
                      County='North Yorkshire' 
                      Country='UK'/>
```
#### Notes
* The address is ignored if it is not a one-off supplier


### Comments
It is possible to add one or more comments to an invoice
 
```xml
<pro:Comments>
  <pro:Comment>Please pay quickly</pro:Comment>
</pro:Comments>
```

#### Notes
* It is not currently possible to view comments from within the PROACTIS website.
 
### References
It is also possible to set the reference fields on the invoice

```xml
<pro:References>
          <pro:Reference Caption='Bar code' 
                         Value='345-223-33'
          <pro:Reference Position='2' 
                         Value='BACS'
          <pro:Reference Code='Colour' 
                         Value='Red'
</pro:References>
```
#### Notes
* Any mandatory reference fields without default values must be set.
* Either the code, caption or the position can be specified

The invoice then finishes with a closing tag:

```xml
</pro:Invoice>
```

Finally the XML must be closed as follows:
```xml
</pro:Import>
```

---

## Standalone Invoices

This section of the document walks you through the creation of a simple standalone invoice. This is a type of invoices which is not matched to parent purchase orders.

The gateway assumes the invoice is a standalone invoice if 
* One or more non-order items are supplied
* A standalone purchase invoice is specified.
* The authorisation pool is specified

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

The next section contains the details of the invoices to be imported.  The gateway allows multiple documents to be included in a single xml document.  At least one invoice must be included.

```xml
<pro:Invoice InvoiceDate="2003-08-27"              
            SupplierInvoiceNumber="PR-234" 
            Template="PINV" 
            Tray="Standard" 
            GrossValue="1"
            AuthorisationPool="PISA"
            Supplier="510632"
ImageReference="10"/>
```

#### Notes
* The template must be a standalone invoicing template, which the user has access to.
* If the template is not provided, then the gateway attempts to automatically select one.  This is only possible if the user only has access to a single template. 
* The tray must an invoicing tray, which the user has access to.
* If the tray is missing, then the user’s default tray is used.
* The supplier invoice number must unique for this supplier
* The invoice date should be in the format yyyy-mm-dd
* The ImageReference value also supports Settlement Discount, so if you have settlement discount switched on; use this field to enter the percentage discount – this must be a number only if settlement discount is active.
* Post-match authorisation is supported by the invoice XML gateway – simply activate this property on the supplier and set the supplier on the invoice… post-match authorisation will be adopted.
* The Supplier attribute must be supplied for standalone invoices.
* The authorisation pool must be supplied if the template is used for standalone invoices and the company level setting is configured to use pools for authorisation.  (This is no longer recommended)

### Standalone Tax Details

The next section contains the summary Tax information.

```xml
 <pro:TaxDetails>
                  <pro:Tax Band="UKVAT" 
                           BandNumber="1"
                           Code="ST"
                           GrossValue="11.75"/>
          </pro:TaxDetails> 
```

#### Notes
* The Band can be identified by either its name (Band) or number (BandNumber). If neither is specified then the first band is assumed.



### Standalone Line Detail

The line details can now be specified.  

```xml
            <pro:NonOrderItems>
                  <pro:NonOrderItem SelectUsingPROACTISCode='TEST' 
                                    SelectUsingDescription='A test item' 
                                    SelectUsingSupplierItemCode='TEST001'
                                    Price='1' 
                                    Quantity='10'
                                    Description='my  test item'
                                    NetValue=''
                                    UnitOfMeasure='each'
                                  ShortCutEntry='ABC'>
```
 
#### Notes

1. Items are identified using a combination of the following attributes.  At least one attribute must be supplied, and the item must be uniquely identified.
    * SelectUsingPROACTISCode
    * SelectUsingDescription
    * SelectUsingSupplierItemCode

2. For goods items the Price and Quantity can be specified.
3. For service items (data-entry-by-value) the net value can be specified.
4. The description and unit of measure can be replaced on all items regardless of the item master settings.
5. The short cut entry can be used to default the coding on all nominal lines.  The short cut list must be specified on the invoice template.

### Standalone Line Nominals

A line can optionally have its nominal coding specified.

```xml
                <pro:NonOrderItemNominals>
                        <pro:NonOrderItemNominal AccountingElement1='1111'                                                                 
                                                 AccountingElement2='AAAA' 
                                                 NominalMask='DEFAULT' 
                                                 ShortCutEntry='My entry' 
                                                 Quantity='10'>
```

#### Notes
* If no nominals are specified, then a single nominal line will automatically be created. It’s coding will be provided by PROACTIS.
* The NominalMask must refer to a nominal mask attached to the item master.
* The quantities must sum to the quantities set against the parent item.

---
## Error Handling


By default the import routine will return the XML amended to include status and error information.

When a piece of data has been processed, then an extra attribute called status will be added to the node, this will contain the value OK, FAILED or REGISTERED.  OK means the invoice was fully imported successfully.  FAILED means the invoice could not be imported.  REGISTERED means the initial values of the invoice have been successfully imported but a problem occurred when trying to set specific item details requiring the invoice to be matched manually.

Note: Nodes without this attribute have not been processed.

he supplied XML is first validated against the **ImportPurchaseInvoices.xsd** schema.  If the invoice fails validation then the details are of the failure are appended to the supplied xml in the form of an errors block

An example errors block is shown below

```xml
<pro:Errors>
  <pro:Error Number='-1072898030' 
             Message='XML is not valid according to the schema. Element content is incomplete according to the DTD/Schema. Expecting: {http://www.proactis.com/xml/xml-ns}Invoice'/>
</pro:Errors>
```

### Errors/Error
| Attribute Name | Description |
----------------|------------ |
| Number | Internal Error Number - this may change between releases |
| Message | The error message (in English) | 
| Source | Optional attribute describing where the error occurred.

#### Notes
* The error block may occur anywhere within the document.  For example, if a line is invalid, the errors block will be appended to that line.

* It is possible for an errors block to contain more than one error.

### ErrorHandlingModes
The reporting of errors can be configured by setting the **ErrorHandlingMode** attribute within the control block.  The table below describes the available modes

| Mode | Description |
----------------|------------ |
| EMBED | The processed XML is returned, but we the error message stored in additional **pro:Errors/pro:Error** nodes. This is the default mode if the attribute is not supplied. |
| THROWERRORS | The errors are thrown as SOAP exceptions back to the calling code, the message is an xml document describing the errors |
| THROWXML | The errors are thrown as SOAP exceptions back to the calling code; the message is the processed xml document, which contains all the errors. |
| THROWTEXT | The errors are thrown as OAP exceptions back to the calling code, the message is an human readable text describing the errors. |

## Successful Response
If a document has been successfully imported, then two new attributes will be added the documents's node.
1. The first attribute is Status, and will have a value of OK
2. The second attribute is DocumentNumber, and this will contain the invoices generated number.


#### Note
* If the XML contains multiple documents, then as long as the control block is valid, it is possible for some documents to be imported and other to be rejected.

