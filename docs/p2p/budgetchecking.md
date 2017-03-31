# Budget Checking

## Overview

PROACTIS P2P allows budgets to be checking against an external source when a purchase order is being submitted.

The preferred method is to configure budget checking using the __Generic Budget Checking__ snapin and the module keeps all the settings in the P2P database and automatically provides additional functions such as caching.

---

## Implementation

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

## Process
+ Create a new C# Class Library project called xyzBudgetChecking. ( _xyz_ can be anything)

+ Add a reference to __Purchasing Server\bin\PROACTIS.P2P.grsCustInterfaces.dll__

+ Add a class called __Services__ which implements the __grsCustInterfaces.IOverSpend__ and __grsCustInterfaces.ICustCommit__ interfaces.

+ Write an implementation of the __grsCustInterfaces.ICustCommit.CommitmentReport__ method.

```C#
string grsCustInterfaces.ICustCommit.CommitmentReport(string NominalsXML, string POXML)
```

+ Write an implementation of the __grsCustInterfaces.ICustCommit.CommitmentCheck__ method.

```C#
bool grsCustInterfaces.ICustCommit.CommitmentCheck(string NominalsXML, string POXML)
```

+ (Optionally) Write an implementation of the __grsCustInterfaces.IOverSpend.GetOverspend__ method.

```C#
decimal grsCustInterfaces.IOverSpend.GetOverspend(string NominalsXML, string POXML)
```