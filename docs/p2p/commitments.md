# Commitment Posting


## Implementation
+ Create a new C# Class Library project called xyzCommitmentProcessor. ( _xyz_ can be anything)

+ Add a reference to __Purchasing Server\bin\PROACTIS.P2P.grsCustInterfaces.dll__

+ Add a class called __Services__ which implements the __grsCustInterfaces.ICommitmentProcessor__ interface.

+ Write an implementation of the __grsCustInterfaces.ICommitmentProcessor.ProcessCommitment__ method.

---

## ICommitmentProcessor.ProcessCommitment

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


### Transaction Handling


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

