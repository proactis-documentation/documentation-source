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
<grs:NominalPeriod grs:Year="2017" grs:Period="1" grs:YearPeriodGUID="{3A8D2AC2-6287-41DF-817A-F77B0551D80D}" grs:Value="120.12" grs:Home1Value="120.12" grs:Home2Value="120.12" grs:NonRecoverableTax="0" grs:NonRecoverableTaxHome1="0" grs:NonRecoverableTaxHome2="0">
<grs:Nominal grs:Coding="SALES.CONF.MARKET" grs:Element1="SALES" grs:Element2="CONF" grs:Element3="MARKET" grs:Element4="" grs:Element5="" grs:Element6="" grs:Element7="" grs:Element8=""></grs:Nominal>
</grs:NominalPeriod>
</grs:NominalPeriods>

</grs:CommitmentLookup>
```

The __NominalPeriods__ element is repeated for each nominal line on the purchase order.



---

