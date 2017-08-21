# Purchase Credit Note Gateway

## Summary

This document describes the structure of the XML file used for importing Purchase Credit Notes into PROACTIS.  It is assumed that the reader of the document is familiar both with XML and PROACTIS invoicing.

The document also describes the validation rules, which must be passed in order for the credit note to be imported, and the current limitations of the credit note gateway.

This document should be used in conjunction with the **ImportPurchaseCreditNotes.xsd** xml schema


!!! Limitations of the Gateway

The initial release of the credit note gateway is subjected to the following limitations.  
* It is not possible to set the supplier’s branch on the credit note.  The default invoicing branch will be selected.
* The quantity on the credit note cannot exceed the quantity expected from the credit note unless the complete nominal details are specified in the import file.
* If the quantity expected exceeds the quantity on the credit note, then the quantity will be allocated to the line nominals in a first-come-first-served basis.

###
For example:

If the parent credit note has a single line, with a quantity of 6 split equally across two nominals, and a credit note is imported containing a quantity of 4.
* The first nominal will be allocated a quantity of 3 
* The second nominal will be allocated the remaining quantity of 1


---

## Worked Example

This section of the document walks you through the creation of a simple credit note. 

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

### Credit Note

The next section contains the details of the Credit Notes to be imported.  The gateway allows multiple documents to be included in a single xml document.  At least one credit note must be included.

```xml
          <pro:CreditNote CreditNoteDate="2005-01-27"              
                          SupplierCreditNoteNumber="PR-234" 
                          Template="CRED" 
                          Tray="Standard" 
                          GrossValue="100">

```

!!! Note
* The template must be a credit note template, which the user has access to.
* The tray must an invoicing tray, which the user has access to.
* If the tray is missing, then the user’s default tray is used.
* The supplier credit note number must unique for this supplier
* The credit note date should be in the format yyyy-mm-dd


### Credit Note Items
Then the parent documents (credit notes and/or credit notes) and items against which the credit note will be matched are listed.

```xml
 <pro:ParentDocuments>                       
  <pro:ParentDocument DocumentNumber="PORD10034">
    <pro:Item Position="1" Value="1"/>
    <pro:Item Position="2" Price="1" Quantity="1">
      <pro:Nominals>
        <pro:Nominal Code="ABC.XYZ" Quantity="1"/>
      </pro:Nominals>
    </pro:Item> 
  </pro:ParentDocument>
</pro:ParentDocuments>
```

#### Notes
* The items refer to the item lines on the parent documents, not the nominal period lines.  Quantities will be allocated to the nominals on a first-come-first-severed basis if the details are not specified in the import document.
* Depending on the type of item, either the Price plus Quantity should be provided or the Value.
* The position is used to specify the item on the purchase credit note or credit note.
* If no parent documents are specified then the credit note can only be registered.  In this case, the supplier must set.


### Tax
As well as the parent documents, the credit note must also include the tax details.

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
It is possible to add one or more comments to an credit note
 
```xml
<pro:Comments>
  <pro:Comment>Please pay quickly</pro:Comment>
</pro:Comments>
```

#### Notes
* It is not currently possible to view comments from within the PROACTIS website.
 
### References
It is also possible to set the reference fields on the credit

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

The credit then finishes with a closing tag:

```xml
</pro:CreditNote>
```

Finally the XML must be closed as follows:
```xml
</pro:Import>
```

---

## Error Handling


By default the import routine will return the XML amended to include status and error information.

When a piece of data has been processed, then an extra attribute called status will be added to the node, this will contain the value OK, FAILED or REGISTERED.  OK means the credit note was fully imported successfully.  FAILED means the credit note could not be imported.  REGISTERED means the initial values of the credit note have been successfully imported but a problem occurred when trying to set specific item details requiring the credit note to be matched manually.

Note: Nodes without this attribute have not been processed.

he supplied XML is first validated against the **ImportPurchaseCreditNotes.xsd** schema.  If the credit note fails validation then the details are of the failure are appended to the supplied xml in the form of an errors block

An example errors block is shown below

```xml
<pro:Errors>
  <pro:Error Number='-1072898030' 
             Message='XML is not valid according to the schema. Element content is incomplete according to the DTD/Schema. Expecting: {http://www.proactis.com/xml/xml-ns}ParentDocument'/>
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
If a document has been successfully imported, then two new attributes will be added the document's node.
1. The first attribute is Status, and will have a value of OK
2. The second attribute is DocumentNumber, and this will contain the Credit Notes generated number.


#### Note
* If the XML contains multiple documents, then as long as the control block is valid, it is possible for some documents to be imported and other to be rejected.

---
## Example XML
 
The example below shows a basic single credit note being imported.  The credit note will be matched against the purchase invoice PINV10034. 

```xml
<?xml version="1.0"?>
<pro:Import xmlns:pro="http://www.proactis.com/xml/xml-ns">
          <pro:Control   Version="1.0.0" 
                         DatabaseName="DEMO"
                         UserName="sysadmin"
                         Password="mypassword"/>
          <pro:CreditNote CreditNoteDate="2005-01-27"              
                          SupplierCreditNoteNumber="CN-234" 
                          Template="CRED" 
                          GrossValue="1">
                          <pro:ParentDocument>
                            <pro:ParentDocument DocumentNumber="PINV10034">
                                    <pro:Item         Position="1" 
                                                         Price="1" 
                                                        Quantity="1"/>
                            </pro:ParentDocument>
                          </pro:ParentDocuments>

                          <pro:TaxDetails>
                                    <pro:Tax Band="VAT" 
                                             Code="Z" 
                                             GrossValue="1"/>
                          </pro:TaxDetails>
          </pro:CreditNote>
</pro:Import>
```

---

## Troubleshooting

**Error**
You must have at least one tax code.  If there is no tax, then use a zero-rated or exempt code. 

**Solution**
Check the name of the tax band has been specified correctly.

 
 
**Error**
The XML returned by the gateway is blank. 

**Solution**
An error has occurred which could not be handled by the gateway.  Please check the Windows Event Log for additional details.

 
 
**Error**
Element content is invalid according to the DTD/Schema.

**Solution**
The supplied credit note XML is not in the required format.   Check that the structure of the XML matches the xsd schema.
