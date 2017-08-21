# Cancel Purchase Order Gateway

## Summary

This document describes how to cancel purchase orders using the PROACTIS web services.

It is assumed that the reader of the document is familiar both with XML and PROACTIS ordering.

The document also describes the validation rules, which must be passed in order for the order to be cancelled and any current limitations of the gateway.

This document should be used in conjunction with the AuthenticateUser.xsd xml schema


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

### Order Identification
There are two ways in which the purchase order to cancel can be identified. 


Either supply the order’s
1. TemplateLabel and numeric Number
Or
2. The DisplayNumber

 
If the DisplayNumber is supplied, then the TemplateLabel and Number are ignored.

An error will be reported if either the order doesn’t exist, or it’s not in a state to be cancelled.


### Cancellation Reason
The reason for cancellation the order must be supplied.  Reasons are defined in the List snapin within the PROACTIS management console.

### Comments
Finally, any additional comments can be supplied.