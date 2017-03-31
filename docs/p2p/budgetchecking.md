# Budget Checking

## Overview

PROACTIS P2P allows budgets to be checking against an external source when a purchase order is being submitted.

The preferred method is to configure budget checking using the __Generic Budget Checking__ snapin and the module keeps all the settings in the P2P database and automatically provides additional functions such as caching.

---

## Custom DLL

To write a custom budget checking DLL,  the following methods must be implemented.

+ __CommitmentCheck__  
Given a set of nominal lines from a purchase order returns False if at least one line on the order has failed budget checking

+ __CommitmentReport__  
Given a set of nominal lines from a purchase order returns a custom table showing the available funds calculation for each.  For example the table might have columns for Original Budget,  Spend To Date,  Accruals and Remaining Budget.

+ __GetOverspend__  
Given a set of nominal lines from a purchase order returns the total amount that the document exceeds the available budget.   This figure can be used in your authorisation workflow to route an document to the correct approver.

!!! Note

    You are not required to implement the __GetOverspend__ method but it is recommended.


---

## Implementation
+ Create a new C# Class Library project called xyzBudgetChecking. ( _xyz_ can be anything)

+ Add a reference to __Purchasing Server\bin\PROACTIS.P2P.grsCustInterfaces.dll__

+ Add a class called __Services__ which implements the __grsCustInterfaces.IOverSpend__ and __grsCustInterfaces.ICustCommit__ interfaces.

+ Write an implementation of the __grsCustInterfaces.ICustCommit.CommitmentCheck__ method.

```C#
bool grsCustInterfaces.ICustCommit.CommitmentCheck(string NominalsXML, string POXML)
```
+ Write an implementation of the __grsCustInterfaces.ICustCommit.CommitmentReport__ method.

```C#
string grsCustInterfaces.ICustCommit.CommitmentReport(string NominalsXML, string POXML)
```

+ (Optionally) Write an implementation of the __grsCustInterfaces.IOverSpend.GetOverspend__ method.

```C#
decimal grsCustInterfaces.IOverSpend.GetOverspend(string NominalsXML, string POXML)
```

---

## ICustCommit.CommitmentCheck

### Arguments

| Argument      | Direction | Description
| ------------- | --------- | ------------ |
| NominalsXML   | In        | An xml document containing the nominals which need to be budget checked.  This also includes details of the database,  company and user. |
| POXML         | In        | An xml document containing the entire purchase order to check.  By default this argument is blank unless the company-wide setting is enabled. |

### Return Value
The function should return True if all the lines pass budget checking and False if at least one line fails the check.

### Nominals XML
Below is an example of the xml passed to the __NominalsXML__ argument.
```xml
<grs:CommitmentLookup xmlns:grs="http://www.getrealsystems.com/xml/xml-ns">
<grs:Database grs:Server="localhost" grs:DatabaseName="PROACTIS" />
<grs:General grs:UserGUID="{3A8D2AC2-6287-41DF-817A-F77B0551D80D}" grs:CompanyGUID="{3A8D2AC2-6287-41DF-817A-F77B0551D80D}" />
<grs:Currencies><grs:Currency grs:CurrencyGUID="{2E67C438-9012-415B-AED4-8809F0012A78}" grs:Status="H1" grs:Symbol="£" grs:DecimalPlaces="2" /></grs:Currencies>

<grs:NominalPeriods>
    <grs:NominalPeriod grs:Year="2017" grs:Period="1" grs:YearPeriodGUID="{3A8D2AC2-6287-41DF-817A-F77B0551D80D}" grs:Value="120.12" 
    grs:Home1Value="120.12" grs:Home2Value="120.12" grs:NonRecoverableTax="0" grs:NonRecoverableTaxHome1="0" grs:NonRecoverableTaxHome2="0">
        <grs:Nominal grs:Coding="SALES.CONF.MARKET" grs:Element1="SALES" grs:Element2="CONF" grs:Element3="MARKET" grs:Element4="" 
        grs:Element5="" grs:Element6="" grs:Element7="" grs:Element8=""></grs:Nominal>
    </grs:NominalPeriod>
</grs:NominalPeriods>

</grs:CommitmentLookup>
```

The __NominalPeriods__ element is repeated for each nominal line on the purchase order.

### POXML
!!! Warning

    The POXML argument is populated with an xml document based on a internal product structure which may change over time from release to release.  It is recommended that you only extract information that you cannot obtain from elsewhere,  and also code defensively. 

---

## ICustCommit.CommitmentReport

### Arguments

| Argument      | Direction | Description
| ------------- | --------- | ------------ |
| NominalsXML   | In        | An xml document containing the nominals which need to be budget checked.  This also includes details of the database,  company and user. |
| POXML         | In        | An xml document containing the entire purchase order to check.  By default this argument is blank unless the company-wide setting is enabled. |

### Return Value
The function should return a table (in xml format) which describes the budget calculation for each line on the order.

### Nominals XML
Below is an example of the xml passed to the __NominalsXML__ argument.
```xml
<grs:CommitmentLookup xmlns:grs="http://www.getrealsystems.com/xml/xml-ns">
<grs:Database grs:Server="localhost" grs:DatabaseName="PROACTIS" />
<grs:General grs:UserGUID="{3A8D2AC2-6287-41DF-817A-F77B0551D80D}" grs:CompanyGUID="{3A8D2AC2-6287-41DF-817A-F77B0551D80D}" />
<grs:Currencies><grs:Currency grs:CurrencyGUID="{2E67C438-9012-415B-AED4-8809F0012A78}" grs:Status="H1" grs:Symbol="£" grs:DecimalPlaces="2" /></grs:Currencies>

<grs:NominalPeriods>
    <grs:NominalPeriod grs:Year="2017" grs:Period="1" grs:YearPeriodGUID="{3A8D2AC2-6287-41DF-817A-F77B0551D80D}" grs:Value="120.12" 
    grs:Home1Value="120.12" grs:Home2Value="120.12" grs:NonRecoverableTax="0" grs:NonRecoverableTaxHome1="0" grs:NonRecoverableTaxHome2="0">
        <grs:Nominal grs:Coding="SALES.CONF.MARKET" grs:Element1="SALES" grs:Element2="CONF" grs:Element3="MARKET" grs:Element4="" 
        grs:Element5="" grs:Element6="" grs:Element7="" grs:Element8=""></grs:Nominal>
    </grs:NominalPeriod>
</grs:NominalPeriods>

</grs:CommitmentLookup>
```
The __NominalPeriods__ element is repeated for each nominal line on the purchase order.

### POXML
!!! Warning

    The POXML argument is populated with an xml document based on a internal product structure which may change over time from release to release.  It is recommended that you only extract information that you cannot obtain from elsewhere,  and also code defensively. 

### Returned XML
The function needs to return XML with the following structure

```xml
<grs:HeadedList xmlns:grs='http://www.getrealsystems.com/xml/xml-ns'>

<grs:Headings>
    <grs:Column grs:Number='1' grs:Type=''          grs:BudgetType=''>Nominal Coding</grs:Column>
    <grs:Column grs:Number='2' grs:Type='Currency'  grs:BudgetType='Budget'>Budget For Year</grs:Column>
    <grs:Column grs:Number='3' grs:Type='Currency'  grs:BudgetType='Cost'>Spend To Date</grs:Column>
    <grs:Column grs:Number='4' grs:Type='Currency'  grs:BudgetType='Cost'>Accruals</grs:Column>
    <grs:Column grs:Number='5' grs:Type='Currency'  grs:BudgetType='Cost'>This Document</grs:Column>
    <grs:Column grs:Number='6' grs:Type='Currency'  grs:BudgetType=''>Remaining Budget</grs:Column>
    <grs:Column grs:Number='7' grs:Type='Highlight' grs:BudgetType=''>Highlight</grs:Column>
</grs:Headings>

<grs:Items>
    <grs:Item grs:GUID='{3A8D2AC2-6287-41DF-817A-F77B0551D80D}' >
        <grs:Column grs:Number='1' grs:Type='Standard'>SALES.CONF.MARKETING</grs:Column>
        <grs:Column grs:Number='2' grs:CurrencySymbol='£' grs:DecimalPlaces='0' grs:Type='Currency'>100000</grs:Column>
        <grs:Column grs:Number='3' grs:CurrencySymbol='£' grs:DecimalPlaces='0' grs:Type='Currency'>60000</grs:Column>
        <grs:Column grs:Number='4' grs:CurrencySymbol='£' grs:DecimalPlaces='0' grs:Type='Currency' Hyperlink='/CommitmentReport.html'>50000</grs:Column>
        <grs:Column grs:Number='5' grs:CurrencySymbol='£' grs:DecimalPlaces='0' grs:Type='Currency'>20000</grs:Column>
        <grs:Column grs:Number='6' grs:CurrencySymbol='£' grs:DecimalPlaces='0' grs:Type='Currency'>-10000</grs:Column>
        <grs:Column grs:Number='7' grs:Type='Highlight'>true</grs:Column>
    </grs:Item>
</grs:Items>

</grs:HeadedList>
``` 

!!! Note

    + You need to define one __grs:Column__ element for each column you wish to appear in the commitment report.
        -   The grs:Number attribute should sequentially number the columns 1...
        -   The grs:Type attribute can be "" (blank),  Currency (for a monetary value) or Highlight (failure indicator)
        -   The grs:BudgetType columns is used by the budget graphic.  It can be "" (blank),  Budget or Cost  

    + You need to add one __grs:Item__ for each line that you wish to appear on the report.  Within each __Item__ element a __Column__ element must be added for each column you defined in the __Headings__ element.
        -   The grs:Number attribute should match the number of the column.
        -   The grs:Type attribute can be "" (blank),  Currency (for a monetary value) or Highlight (failure indicator)
        -   If the Type is currency,  then the CurrencySymbol and DecimalPlaces attributes should also be provided
        -   Optionally a hyperlink attribute can be provided.  The renders the value as an HTML 'a' link.




## IOverSpend.GetOverspend

### Arguments

| Argument      | Direction | Description
| ------------- | --------- | ------------ |
| NominalsXML   | In        | An xml document containing the nominals which need to be budget checked.  This also includes details of the database,  company and user. |
| POXML         | In        | An xml document containing the entire purchase order to check.  By default this argument is blank unless the company-wide setting is enabled. |

### Return Value
The function should return the total amount (as a decimal) that the lines on the order exceed their budget.  For example if the first line exceeded by £10 and the second by £20 then you should return 30.

### Nominals XML
Below is an example of the xml passed to the __NominalsXML__ argument.

```xml
<grs:CommitmentLookup xmlns:grs="http://www.getrealsystems.com/xml/xml-ns">
<grs:Database grs:Server="localhost" grs:DatabaseName="PROACTIS" />
<grs:General grs:UserGUID="{3A8D2AC2-6287-41DF-817A-F77B0551D80D}" grs:CompanyGUID="{3A8D2AC2-6287-41DF-817A-F77B0551D80D}" />
<grs:Currencies><grs:Currency grs:CurrencyGUID="{2E67C438-9012-415B-AED4-8809F0012A78}" grs:Status="H1" grs:Symbol="£" grs:DecimalPlaces="2" /></grs:Currencies>

<grs:NominalPeriods>
    <grs:NominalPeriod grs:Year="2017" grs:Period="1" grs:YearPeriodGUID="{3A8D2AC2-6287-41DF-817A-F77B0551D80D}" grs:Value="120.12" 
    grs:Home1Value="120.12" grs:Home2Value="120.12" grs:NonRecoverableTax="0" grs:NonRecoverableTaxHome1="0" grs:NonRecoverableTaxHome2="0">
        <grs:Nominal grs:Coding="SALES.CONF.MARKET" grs:Element1="SALES" grs:Element2="CONF" grs:Element3="MARKET" grs:Element4="" 
        grs:Element5="" grs:Element6="" grs:Element7="" grs:Element8=""></grs:Nominal>
    </grs:NominalPeriod>
</grs:NominalPeriods>
```

### POXML
!!! Warning

    The POXML argument is populated with an xml document based on a internal product structure which may change over time from release to release.  It is recommended that you only extract information that you cannot obtain from elsewhere,  and also code defensively. 

---
## Example

See the [example application](https://github.com/proactis-documentation/ExampleApplications/tree/master/P2P/Budget%20Checking) for a complete implementation.

---

## Deployment

You dll should be complied (and named xyzBudgetChecking.dll) and then copied into your __PROACTIS P2P/Plugins__  (or __Plugins/[database-title]__) folder.
