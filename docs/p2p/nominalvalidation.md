# Nominal Validation

## Overview
The core PROACTIS P2P product includes the functionality for complex nominal rules to be defined using the concept of nominal groups.

In some situations there might be a requirement to also validate the nominal coding entered against a purchase order line against an external source,  such as a finance system.

In a lot of cases this can be configured using the __Generic Nominal Validation__ snapin directly within the product.  This is the preferred approach as all the configuration is held within the database and the generic nominal validation module automatically provides extra features such as caching.

If __Generic Nominal Validation__ is not suitable for your needs then a custom DLL can be implemented providing you with complete control of the process.

---

## Getting Started

+ Create a new C# Class Library project called xyzNominalCheck. ( _xyz_ can be anything)

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

### Sample Nominal XML
```xml
<grs:NominalCheck>
    <grs:Database grs:Server="Develop07" grs:DatabaseName="PROACTISIII"/>
    
    <grs:General grs:UserGUID="{02E0D6D9-B655-11D5-91D6-000629864A98}" grs:CompanyGUID="{A2FEEDC5-978F-11D5-8C5E-0001021ABF9B}"/>

    <grs:Nominals xmlns:grs="http://www.getrealsystems.com/xml/xml-ns">
        <grs:Nominal grs:Coding="1720" grs:Element1="1720" grs:Element2="" grs:Element3="" grs:Element4="" grs:Element5="" grs:Element6="" grs:Element7="" grs:Element8="" grs:ValidNominal="False"/>
   
        <grs:Nominal grs:Coding="4744.1100" grs:Element1="4744" grs:Element2="1100" grs:Element3="" grs:Element4="" grs:Element5="" grs:Element6="" grs:Element7="" grs:Element8="" grs:ValidNominal="False"/>
    </grs:Nominals>
</grs:NominalCheck>
```

---

## Deployment

You dll should be complied (and named xyzNominalCheck.dll) and then copied into your __PROACTIS P2P/Plugins__  (or __Plugins/[database-title]__) folder.



