# Internal Invoice Gateway

## Summary

This document describes the structure of the XML file used for importing Internal Invoices into PROACTIS.  It is assumed that the reader of the document is familiar both with XML and PROACTIS internal invoicing.

The document also describes the validation rules, which must be passed in order for the internal invoice to be imported, and the current limitations of the invoice matching gateway.

This document should be used in conjunction with the **ImportInternalInvoice.xsd** xml schema.

---

## Worked Example

This section of the document walks you through the creation of a simple internal invoice. 

### XML Document

The xml document must start with the following to lines

```xml
<?xml version="1.0" ?>
<pro:Import xmlns:pro="http://www.proactis.com/xml/xml-ns">
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

### Internal Invoice

The next section contains the details of the invoices to be imported.  The gateway allows multiple documents to be included in a single xml document.  At least one invoice must be included.

```xml
<pro:InternalInvoice>
```

### Order Items
Then the order's items (and item details) to which the internal invoice relates are listed.

```xml
<pro:OrderItems OrderNumber="PORD10035">                 
  <pro:OrderItem Position="1"
                 Price="7.99"
                 Quantity="5"
                 Description="Test Internal Order Item">
    <pro:OrderNominals>
      <pro:OrderNominal    Code="ABC.123"
          Quantity="3"
          Price="7.99"/>
      </pro:OrderNominals>
  </pro:OrderItem>
</pro:OrderItems>
```

#### Notes
* The OrderNumber must relate to an order with an internal supplier,
* The Price, Quantity and Description can be used to override the values set on the order.
* For DataEntryByValue items, the NetValue should be supplied instead of the Price and Quantity.
* The Nominal elements can reallocate the order items to different nominals.

### Invoice Items
The invoice items are listed next in a similar format

```xml
<pro:InvoiceItems>                   
  <pro:InvoiceItem BuyerItemCode="ABC"
                   SupplierItemCode="123"
                   Description="Test Internal Order Item"
                   Quantity="5"
                   Price="7.99">
    <pro:InvoiceNominals>
      <pro:InvoiceNominal Code="ABC.123" Value="3"/>
    </pro:InvoiceNominals>
   </pro:InvoiceItem>
</pro:InvoiceItems>
```


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
</pro:InternalInvoice>
```

Finally the XML must be closed as follows:
```xml
</pro:InternalInvoice>
```

---
## Error Handling


The import routine will return the XML amended to include status and error information.

When a piece of data has been processed, then an extra attribute called status will be added to the node, this will contain the value OK or FAILED.  OK means the invoice was fully imported successfully.  FAILED means the invoice could not be imported. Note: Nodes without this attribute have not been processed.

The supplied XML is first validated against the **ImportInternalInvoices.XSD** schema.  If the invoice fails validation then the details are of the failure are appended to the supplied xml in the form of an errors block.


An example errors block is shown below

```xml
<pro:Errors>
  <pro:Error Message='XML is not valid according to the schema. Element content is incomplete according to the DTD/Schema. Expecting: {http://www.proactis.com/xml/xml-ns}OrderItems'/>
</pro:Errors>
```

### Errors/Error
| Attribute Name | Description |
----------------|------------ |
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
If a document has been successfully imported, then two new attributes will be added the document's node.

1. The first attribute is Status, and will have a value of OK
2. The second attribute is DocumentNumber, and this will contain the invoices generated number.


#### Note
* If the XML contains multiple documents, then as long as the control block is valid, it is possible for some documents to be imported and other to be rejected.

## Example Code

See the following example applications:

* [Create Standalone Invoice](https://github.com/proactis-documentation/ExampleApplications/tree/master/P2P/Gateways/PROACTIS.ExampleApplication.CreateInvoice)