# Nominal Validation

## Overview
The core PROACTIS P2P product includes the functionality for complex nominal rules to be defined using the concept of nominal groups.

In some situations there might be a requirement to also validate the nominal coding entered against a purchase order line against an external source,  such as a finance system.

In a lot of cases this can be configured using the __Generic Nominal Validation__ snapin directly within the product.  This is the preferred approach as all the configuration is held within the database and the generic nominal validation module automatically provides extra features such as caching.

If __Generic Nominal Validation__ is not suitable for your needs then a custom DLL can be implemented providing you with complete control of the process.

---

## Implementation Steps

+ Create a new C# Class Library project called xyzNominalValidation. ( _xyz_ can be anything)

+ Add a reference to __Purchasing Server\bin\PROACTIS.P2P.grsCustInterfaces.dll__

+ Add a class called __Services__ which implements the __grsCustInterfaces.INominals__ interface.

+ Write an implementation of the __grsCustInterfaces.INominals.NominalCheck__ method.

```C#
bool grsCustInterfaces.INominals.NominalCheck(string NominalsXML, string POXML, ref string ErrorNominals)
```

### Arguments

| Argument      | Direction | Description
| ------------- | --------- | ------------ |
| NominalsXML   | In        | An xml document containing the nominals which need to be validated.  This also includes details of the database,  company and user. |
| POXML         | In        | An xml document containing the entire purchase order to validate.  By default this argument is blank unless the company-wide setting is enabled. |
| ErrorNominals | Out       | If the nominals fail validation,  then you should return an xml document listing the failing nominals. |

### Return Value
The function should return True if all nominals are valid and False if one or more nominals are invalid.

### Nominals XML
Below is an example of the xml passed to the __NominalsXML__ argument.
```xml
<grs:NominalCheck xmlns:grs="http://www.getrealsystems.com/xml/xml-ns">
    <grs:Database grs:Server="Develop07" grs:DatabaseName="PROACTISIII"/>
    
    <grs:General grs:UserGUID="{02E0D6D9-B655-11D5-91D6-000629864A98}" grs:CompanyGUID="{A2FEEDC5-978F-11D5-8C5E-0001021ABF9B}"/>

    <grs:Nominals>
    <grs:Nominal grs:Coding="1720" grs:Element1="1720" grs:Element2="" grs:Element3="" grs:Element4="" grs:Element5="" grs:Element6="" grs:Element7="" grs:El
    ement8="" grs:ValidNominal="False"/>
   
        <grs:Nominal grs:Coding="4744.1100" grs:Element1="4744" grs:Element2="1100" grs:Element3="" grs:Element4="" grs:Element5="" grs:Element6="" grs:Element7="" grs:Element8="" grs:ValidNominal="False"/>
    </grs:Nominals>
</grs:NominalCheck>
```

### POXML

!!! Warning

    The POXML argument is populated with an xml document based on a internal product structure which may change over time from release to release.  It is recommended that you only extract information that you cannot obtain from elsewhere,  and also code defensively. 

### Error Nominals
The xml for the returned invalid nominals takes a similar structure to the NominalsXML argument.  For example:

```xml
<grs:Nominals xmlns:grs="http://www.getrealsystems.com/xml/xml-ns">
   <grs:Nominal grs:Coding="1720" grs:Element1="1720" grs:Element2="" grs:Element3="" grs:Element4="" grs:Element5="" grs:Element6="" grs:Element7="" grs:Element8="" grs:ValidNominal="False"/>
   <grs:Nominal grs:Coding="4744.1100" grs:Element1="4744" grs:Element2="1100" grs:Element3="" grs:Element4="" grs:Element5="" grs:Element6="" grs:Element7="" grs:Element8="" grs:ValidNominal="False"/>
</grs:Nominals>
```
---
## Example

See the [example application](https://github.com/proactis-documentation/ExampleApplications/tree/master/P2P/Nominal%20Validation) for a complete implementation.

---

## Deployment

Your dll should be complied (and named xyzNominalValidation.dll) and then copied into your __PROACTIS P2P/Plugins__  (or __Plugins/[database-title]__) folder.



