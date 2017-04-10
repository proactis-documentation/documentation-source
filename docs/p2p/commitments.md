# Commitment Posting


## Implementation
+ Create a new C# Class Library project called xyzCommitmentProcessor. ( _xyz_ can be anything)

+ Add a reference to __Purchasing Server\bin\PROACTIS.P2P.grsCustInterfaces.dll__

+ Add a class called __Services__ which implements the __grsCustInterfaces.ICommitmentProcessor__ interface.

+ Write an implementation of the __grsCustInterfaces.ICommitmentProcessor.ProcessCommitment__ method.

---

## ProcessCommitment Method

### Signature
```
void ICommitmentProcessor.ProcessCommitment(Guid commitmentGUID, string commitmentXML, string database, string databaseServer)
```

### Arguments

| Argument      | Direction | Description
| ------------- | --------- | ------------ |
| commitmentGUID    | In        | GUID for the entry in __dbo.CommitmentsForPosting__. |
| commitmentXML  | In        | The XML generated for the commitment by the Grouped Commitments application hook |
| database  | In        | Name of the p2p database |
| databaseServer  | In        | Name of the p2p database server |

### Error Handling

If your DLL fails to process the commitment entry then it can throw an exception up to the calling service.

_For example_
```csharp
    throw new Exception("Failed to connect to the finance system");
```

This will be recorded in the __ErrorMessage__ column of the __dbo.CommitmentsForPosting__ table and the message queue entry will be moved from the __proactis3commitmentslink__ queue into the __proactis3commitmentslinkFailed__ queue.

The error message may also be viewed from the windows event log viewer on the application server.


### Transaction Handling

By default your code will run in a database transaction provided by the calling service.  If you wish your database code to run outside of this transaction scope,  then the following code maybe used

```csharp
using (var tx = new TransactionScope(TransactionScopeOption.Suppress))
{
    // ... your database code here...
}
```

---

## Example
<!--
See the [example application](https://github.com/proactis-documentation/ExampleApplications/tree/master/P2P/Nominal%20Validation) for a complete implementation.-->

---

## Deployment

Edit the file __"ConfigurationFolder\PROACTIS.P2P.ClientCommitmentsService.exe.config"__ and ensure that the value for __ClassName__ is set to blank.

```xml
<add key="ClassName" value=""/>
```

Your dll should be complied (and named xyzCommitmentProcessor.dll) and then copied into your __PROACTIS P2P/Plugins__  (or __Plugins/[database-title]__) folder.

