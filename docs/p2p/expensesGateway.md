# Expenses Gateway

## Summary

This document describes the structure of the XML file used for importing Expense Claims into PROACTIS.  It is assumed that the reader of the document is familiar both with XML and PROACTIS expense claims.

The document also describes the validation rules, which must be passed in order for the claim to be imported, and the current limitations of the expense claim gateway.

This document should be used in conjunction with the __ImportExpenseClaims.xsd__ xml schema.


## Process Overview

The process of importing expense claims is very similar to the existing master-data (suppliers/items/nominals) and purchase invoice and order xml gateways.

First the user generates an xml document containing the details of the expense claim(s) to be imported.  This xml must conform to the __ImportExpenseClaims.xsd__ schema document.

The xml is then validated, first to ensure it conforms to the schema and then to check the supplied data is valid.  For instance does the template exist?

The expense claim is then created within PROACTIS using the existing expenses engine.  This allows the gateway to use the existing PROACTIS functionality.


## Limitations of the Gateway

Although the Expense Claim XML gateway mimics the PROACTIS web application wherever possible, it is subject to the following limitations.

### Companies

As with the other XML gateways, an XML document can only contain documents for a single company.

### Departments

As with the other XML gateways, an XML document can only contain documents for a single department.

### Language

The schema, documentation and error messages are all written in English.

### Actions

This XML gateway only supports the creation and submission of expense claims.  It does not allow users to amend, authorise or cancel expense claims.

## Worked Example

This section of the document walks you through the creation of a simple document.  All the available fields are described in complete detail, within the next section.

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

### Expense Claims

The next section contains the details of the expense claims to be imported.  The gateway allows multiple claims to be included in a single xml document.  At least one expense claim must be included.

```xml
<pro:ExpenseClaim Template = "EXP"
                  Title = "Pen and Paper" 
                  ClaimDate="2017-08-18"
                  ClaimFor="Anderson"
                  SaveMethod="SUBMIT" />  
```

### @Template

This attribute is optional if the user only has access to a single template.  However, it is recommended that a value is explicitly supplied where possible.

### @ClaimDate

This attribute is optional and will default to today's date if missing.  Must be in the format yyyy-mm-dd

### Comments
Any number of comments may be added onto the claim.

```xml
<pro:Comments>
  <pro:Comment>"Please pay quickly"</pro:Comment>
  <pro:Comment>"BarCode: 1232" </pro:Comment>
</pro:Comments>
```

### Items
The claim must contain one or more item lines.

```xml
<pro:Items>
  <pro:Item PROACTISCode='LTP001'
            Price='1002.35'
            Quantity='1'
            Description='Laptop'
            Receipt='YES'
            TaxReceipt='YES'
            TaxCode='C1' />
<pro:Items>
```

### Nominals

Each item on the claim must contain one or more nominals

```xml
<pro:Nominals>
  <pro:Nominal AccountingElement1='113'
               NominalMask='Advertising'
               Ratio='1'/>
</pro:Nominals>
```


## Error Handling
 
By default the import routine will return the XML amended to include status and error information.

When a piece of data has been processed, then an extra attribute called status will be added to the node, this will contain either OK or FAILED.  

Note: Nodes without this attribute have not been processed.

The supplied XML is first validated against the __ImportExpenseClaims.XSD__ schema.  If the xml fails validation then the details are of the failure are appended to the supplied xml in the form of an errors block


An example errors block is shown below

```xml
<pro:Errors>
  <pro:Error Number='-1072898030' 
             Message='XML is not valid according to the schema. Element content is incomplete according to the DTD/Schema. Expecting: {http://www.proactis.com/xml/xml-ns}ExpenseClaim'/>
</ pro:Errors>
```

### Errors/Error
| Attribute Name | Description |
----------------|:------------: |
| Number | Internal Error Number - this may change between releases |
| Message | The error message (in English) | 
| Source | Optional attribute describing where the error occurred.

#### Notes
* The error block may occur anywhere within the document.  For example, if a line is invalid, the errors block will be appended to that line.

* It is possible for an errors block to contain more than one error.
