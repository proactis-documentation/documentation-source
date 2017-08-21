# Cancel Purchase Order Gateway

## Summary

This document describes how to cancel purchase orders using the PROACTIS web services.

It is assumed that the reader of the document is familiar both with XML and PROACTIS ordering.

The document also describes the validation rules, which must be passed in order for the order to be cancelled and any current limitations of the gateway.

This document should be used in conjunction with the **AuthenticateUser.xsd** xml schema


---

## Process Overview

The following information is passed to the web service call

* An xml control block, which authenticates the user onto a PROACTIS database.
* The purchase order to cancel
* The reason why the order is being cancelled
* Any additional comments.
 
As with the front end, not all orders are in a state where they can be cancelled.  For example, a fully invoiced order can not be cancelled.
 
---

## Worked Example
 
This section of the document walks you through the cancellation of a purchase order.

 
### AuthenticateUser XML Document
The xml document must start with the following to lines

```xml
<?xml version=”1.0” ?>  
  <pro:AuthenticateUser xmlns:pro=”http://www.proactis.com/xml/xml-ns”>
```

And finish with

```xml
</pro: AuthenticateUser >
```
 
### Control Block
A control block must then be included so that the gateway knows which database and company to log into.  This has the same structure as the control block for the other XML gateways.

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

### Web Services

There are two different web services available depending on how the purchase order will be identified.

#### CancelOrderByGUID
If you know the order's internal GUID; then the **CancelOrderByGUID** method should be used.
This method takes the following arguments:

+ ControlXML
+ OrderGUID
+ CancellationReason
+ Comments

#### CancelOrder
If you only know the order's document number; then the **CancelOrder** method should be used.
This method takes the following arguments:

+ ControlXML
+ TemplateLabel
+ OrderNumber
+ DisplayNumber
+ CancellationReason
+ Comments

!!! Note

    The order can be identified by either of the following arguments:
    
      1. TemplateLabel and numeric Number
      
      2. The DisplayNumber

    If the DisplayNumber is supplied, then the TemplateLabel and Number are ignored.

### Cancellation Reason
The reason for cancellation the order must be supplied.  Reasons are defined in the List snap-in within the PROACTIS management console.

### Comments
Finally, any additional comments can be supplied.

## Errors
If the order does not exist,  or is not in a state where it can be cancelled then the gateway will throw the following fault:
**The order is not available for cancellation**

## Example Code

See the following example applications:

* [Cancel Order](https://github.com/proactis-documentation/ExampleApplications/tree/master/P2P/Gateways/PROACTIS.ExampleApplication.CancelOrder)

* [Cancel Order by GUID](https://github.com/proactis-documentation/ExampleApplications/tree/master/P2P/Gateways/PROACTIS.ExampleApplication.CancelOrderByGUID)