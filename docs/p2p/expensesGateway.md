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

## Success
If a claim has been successfully imported, then two new attributes will be added the ExpenseClaim node.
1. The first attribute is Status, and will have a value of OK
2. The second attribute is DocumentNumber, and this will contain the claims internal number.


#### Note
* If the XML contains multiple expense claims, then as long as the control block is valid, it is possible for some expense claims to be imported and other claims to be rejected.

Example
```xml
<pro:ExpenseClaim  Template='EXP' Status='OK' DocumentNumber='exp 52487'>
```
---

## Control Block
The attributes supported by the control block element within the xml are listed below:

| Attribute Name  | Description                                                                                |
|-----------------|--------------------------------------------------------------------------------------------|
| DatabaseName    | This is the title of the database as shown to the user on the logon screen.                |
| UserName        | The LoginID of the,PROACTIS user. This user must have,permission to create expense claims. |
| Password        | Password for above user.                                                                   |
| EncodedPassword | Encoded version of the password.  (No longer supported)                                    |
| Company | The user must have access to the company.  If missing, the user’s default company will be used.    |
| Department | The user must have access to the department.  If missing, the user’s default department will be used. |
| Version | Must be 1.0.0 |
| WriteErrorsToDatabase | Not currently used. |
| AuthenticationMethod | PROACTIS or WINDOWS.  For WINDOWS authentication, the username and password must not be supplied. |
| ErrorHandlingMode | Describes how error messages will be handled.  See the error handling section for details. |

### Notes
1. The control block must be provided

---

## Import/ExpenseClaim
The attributes supported by the ExpenseClaim element within the xml are listed below:

| Attribute Name  | Description                                                                                |
|-----------------|--------------------------------------------------------------------------------------------|
| Template | The expense claims template’s code used to create the claim.  The user must have permission to use this template. |
| Title | The title of the expense claim. |
| ClaimDate | The date of the claim.  If missing the date will default to today.  All dates are in the format yyyy-mm-dd |
| ClaimFor | The LoginID of the user we are entering the claim for. The user must have permission to enter claims for this user. If missing the claim is entered for the user as specified in the control block. |
| SaveMethod | How will the Expense claim be saved to the database.  If missing, it will default to submit. Possible settings are </br>  SAVE.  Allows the user to manually edit the claim <br/> SUMBIT. Submits the claim for authorisation. This option is not available if the ‘Must submit claim for completion’ user property is set. <br/> CODING. Submits the claim for coding.  A user must be defined for this user for this option to be available.

### Notes
1. At least one claim must be provided

---