# Acceptances Gateway

## Summary

This section describes the structure of the XML file used for importing Purchase Order Acceptances into PROACTIS 3.  It is assumed that the reader of the document is familiar both with XML and PROACTIS acceptances.

The document also describes the validation rules, which must be passed in order for the order to be imported, and the current limitations of the acceptances gateway.

This document should be used in conjunction with the __ImportAcceptances.xsd__ xml schema

## Process Overview

The process of importing acceptances is very similar to the existing master-data (suppliers/items/nominals) and purchase document xml gateways.

First the user generates an xml document containing the details of the acceptances(s) to be imported.  This xml must conform to the ImportAcceptances.xsd schema document.

The user then calls a method on the grsAccGateway.Core object with in the grsAccGateway dll.  This method takes the supplied acceptance xml as its only argument.

The xml is then validated, first to ensure it conforms to the schema and then to check the supplied data is valid.  For instance does the template exist?

The document is then created within PROACTIS using the existing purchasing engine.  This allows the gateway to use the existing PROACTIS functionality.

## Limitations of the Gateway

Although the Acceptance XML gateway mimics the PROACTIS web application wherever possible, it is subject to the following limitations.

### Stock

It is not currently possible to book items into stock.

### Recoding

It is not possible to recode the nominals on the acceptance.

### Companies

As with the other XML gateways, an XML document can only contain documents for a single company.

### Departments

As with the other XML gateways, an XML document can only contain documents for a single department.

### Language

The schema, documentation and error messages are all written in English.

### Actions

This XML gateway only supports the creation and submission of acceptances.  It does not allow users to amended, authorise or cancel acceptances.

## Using the gateway

For maximum flexibility, the gateway has been implemented within a single COM DLL.  This allows the gateway to be used from any programming language which supports the use of COM objects.  These include, Visual Basic, dotNet, C and C++.

The grsWebService DLL contains a single creatable object called Service, which has a single method called Import.  The Import method takes an xml string containing the invoice to be imported and then returns an xml string containing the results.

For example, to call the gateway from visual basic 6, the following code could be used.

```vb
'Declare variables
Dim objGateway As object
Dim strResultsXML As String

'Create the PROACTIS XML gateway.

'Note, the object is created using the createobject command rather
'than the new command,  to make sure the gateway is under the
'control of COM+
Set objGateway = CreateObject("grsWebService.Service")

'Pass the data to be imported into the gateway and receive the results.
strResultsXML = objGateway.ImportDocument(strDataXML)
```

## Worked Example

This section of the document walks you through the creation of a simple document.  All the available fields are described in complete detail, within the next section.

### XML Document

The xml document must start with the following to lines

```xml
<?xml version="1.0" ?>

<pro:Import xmlns:pro=" [http://www.proactis.com/xml/xml-ns](http://www.proactis.com/xml/xml-ns)">
```

And finish with

```xml
</pro:Import>
```

### Control Block

A control block must then be included so that the gateway knows which database and company to import the orders into.  This has the same structure as the control block for the other XML gateways.

An example control block is shown below.

```xml
 <pro:Control           DatabaseName="PROACTIS\_LIVE"

                           UserName="ORDER"

                          Password="mysecret"

                                Company="MAIN"

                                Department="SALES"

                                 Version="1.0.0" />
```

The XML gateway supports NT authentication, an example is shown below.

```xml
 <pro:Control    DatabaseName="PROACTIS\_LIVE"

                     AuthenticationMethod="WINDOWS"

                   Company="MAIN"

                    Department="SALES"

                         Version="1.0.0" />
```

NB: The value of the "AuthenticationMethod" field can be WINDOWS or PROACTIS (which must be expressed in Upper Case).  If this field is missing, the gateway will default to PROACTIS and work as before.

### Acceptances

The next section contains the details of the acceptance documents to be imported.  The gateway allows multiple acceptances to be included in a single xml document.  At least one acceptance document must be included.

```xml
<pro:Acceptance Template=" **ACC**" DateReceived=" **2006-01-01**" AcceptedAt=" **MAIN**" SupplierDeliveryNote=" **Delivery11**">
```

### @Template

This attribute is optional if the user only has access to a single template.  However, it is recommended that a value is explicitly supplied where possible.

### @DateReceived

This attribute is optional and will default to today's date if missing.  Must be in the format yyyy-mm-dd

### @AcceptedAt

This attribute is optional and will default to the user's default location if missing

Specifies the location at which the goods have been accepted.  The user must have access to the location.

### @SupplierDeliveryNote

This attribute is optional/required as configured within PROACTIS.  PROACTIS may also encore the reference to be unique for a given supplier.



### References

Any mandatory reference fields must be supplied.  References fields are identified by their code.  A reference field can only be supplied if it is defined as editable on the document template.

```xml
<pro:References>

<pro:Reference SelectUsingCode="Bar code" Value="345-223-33"  />

</pro:References>
```

### Comments

Any number of comments may be added onto the acceptance document

```xml
<pro:Comments>

<pro:Comment>"Please pay quickly"</pro:Comment>

<pro:Comment>"BarCode: 1232" </pro:Comment>

</pro:Comments>
```

### Orders

The purchase orders to accept are specified next.

```xml
<pro:Orders>

        <pro:OrderSelectUsingTemplate='GENERIC' SelectUsingOrderNo='15'

                  ControlFullyReceiptOrder='YES' ControlItemCondition='OK'>
```
- .At least one purchase order document must be specified.

- .Each order can only be specified once.

- .An order can be identified in one of two ways.

-
  - .Supply its Template and OrderNo using the SelectUsingTemplate and SelectUsingOrderNo

-
  - .Supply its display number using the SelectUsingDisplayNo attribute.

- .If you wish to automatically receipt all items on the order then

-
  - .Set the ControlFullyReceiptOrder attribute to be YES

-
  - .If you wish to specify a delivery condition, then set the ControlItemCondition  attribute to be the desired condition. If a condition is not specified, then the default delivery condition will be used.

-
  - .Do not specify any delivery conditions or items for the order.



### Items

For each order, you then specify which items you would like to accept.

<pro:Items>

        <pro:ItemSelectUsingCode='0300'>

- .At least one item must be specified

- .Each item can only be specified once

- .An item can be identified in one of two ways.

-
  - .Supply its PROACTIS Code using the SelectUsingCode

-
  - .Supply its Description using the SelectUsingDiscriptionattribute.

-
  - .Supply its OrderItemGUID using the SelectUsingOrderItemGUIDattribute.

### ItemReferences

Any mandatory item level reference fields must be supplied.  References fields are identified by their code.  A reference field can only be supplied if it is defined as editable on the document template.

<pro:ItemReferences>

<pro:ItemReference SelectUsingCode="Bar code" Value="345-223-33"  />

</pro:ItemReferences>

### Item Comments

Any number of comments may be added onto an acceptance document line.

<pro:ItemComments>

<pro:ItemComment>"Please pay quickly"</pro:Comment>

<pro:ItemComment>"BarCode: 1232" </pro:Comment>

</pro:ItemComments>

### Conditions

The conditions element allows you define what the condition the receipts goods are in.  For example, OK, Damanged.

        <attributename="Receipted"type="pro:NonNegativeDecimal"/>

                <attributename="Condition"type="pro:Char50Type"/>

                <attributename="ControlFullyReceiptItem"type="pro:YesNoType"/>

- .At least one condition element must be supplied.

- .If the condition attribute is not supplied, then the default delivery condition will be used.

- .The receipted quantity must be supplied, even nominal information is provided for the condition.

- .If the receipted quantity exceeds the outstanding quantity for the item, it will be assumed that the item has been over delivered, and an over delivery will be generated.

- .If you wish to receipt the entire outstanding balance for the item then

-
  - .Don't supplied any nominal information

-
  - .Don't supplied the receipted attribute

-
  - .Set the ControlFullyReceiptItem attribute to YES.

-
  - .Don't supply any other delivery conditions for the line.

- .If no nominal information is provided, then the nominals will be receipted on a first-come-first-served basis.



### Nominals

If required, the receipted quantity can be allocated at nominal level.

<pro:Nominals>

<pro:NominalSelectUsingNominalCoding='0300.0990.0610.ACT'  Receipted='1'/>

</pro:Nominals>



- .A nominal can be identified in one of two ways.

-
  - .Supply its Nominal Coding using the SelectUsingNominalCoding attributes.

-
  - .Supply its CommitmentDate in the format yyyy-mm-dd using the SelectUsingCommitmentDate attribute.

At lease one of the two methods must be used.



- .The receipted quantity must be supplied, and should not exceed the outstanding quanitity from the original order.</Description>

```xml
			<UnitOfMeasure>EA</UnitOfMeasure>
			<UnitValue>28.70</UnitValue>
			<UNSPSCCode>44121604</UNSPSCCode>
		</Item>
	</PunchOutDetail>
</PurchaseOrder>  
```