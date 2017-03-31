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

## grsCustInterfaces.ICustCommit.CommitmentCheck

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
<grs:NominalCheck xmlns:grs="http://www.getrealsystems.com/xml/xml-ns">
    <grs:Database grs:Server="Develop07" grs:DatabaseName="PROACTISIII"/>
    
    <grs:General grs:UserGUID="{02E0D6D9-B655-11D5-91D6-000629864A98}" grs:CompanyGUID="{A2FEEDC5-978F-11D5-8C5E-0001021ABF9B}"/>

    <grs:Currencies></grs:Currencies>

    <grs:NominalPeriods>
    <grs:NominalPeriod grs:Coding="1720" grs:Element1="1720" grs:Element2="" grs:Element3="" grs:Element4="" grs:Element5="" grs:Element6="" grs:Element7="" grs:El
    ement8="" />
   
        <grs:NominalPeriod grs:Coding="4744.1100" grs:Element1="4744" grs:Element2="1100" grs:Element3="" grs:Element4="" grs:Element5="" grs:Element6="" grs:Element7="" grs:Element8="" />
    </grs:NominalPeriods>
</grs:NominalCheck>


---

