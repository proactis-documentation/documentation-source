# Invoice Export
To allow the real time posting of documents into external systems; typically finance systems a custom export DLL can be written which to responds to new documents being placed in the __dbo.DocumentsForPosting__ database table.

The format of document xml which is stored in this table is defined by the various document export application hooks.  (These are detailed separately.)

!!! note

    Although titled _Invoice Export_ this process also applied to other document types such as Credit Notes and Expense Claims


## Implementation
+ Create a new C# Class Library project called xyzExportProcessor. ( _xyz_ can be anything)

+ Add a reference to __Purchasing Server\bin\PROACTIS.P2P.grsCustInterfaces.dll__

+ Add a class called __Services__ which implements the __grsCustInterfaces.IExportProcessor__ interface.

+ Write implementations of the following methods:
    - __grsCustInterfaces.IExportProcessor.Initialise__.
    - __grsCustInterfaces.IExportProcessor.ProcessDocument__.
    - __grsCustInterfaces.IExportProcessor.PostingComplete__.

!!! note

    The methods are called in the order listed above.

    1. The documents are retrieved from the database
    2. Initialise is called just once
    3. ProcessDocument is then called one for each document
    4. PostingComplete is called just once after all calls to ProcessDocument.

---


## Initialise Method

This method is called first after the pending documents have been retrieved from the database.  This method is typically used to make connections to external systems (databases) and to specify the transaction handling model to be used.

### Signature
```
ExportProcessorInitialiseResult Initialise(int numberOfDocuments, string databaseTitle, string databaseName, string databaseServer)
```

### Arguments

| Argument      | Direction | Description
| ------------- | --------- | ------------ |
| numberOfDocuments    | In        | The number of pending documents in the __dbo.DocumentsForPosting__ table. Will always be > 0|
| databaseTitle  | In        | Title of the p2p database |
| databaseName  | In        | Name of the p2p database |
| databaseServer  | In        | Name of the p2p database server |


### Returns

Returns a value from the __ExportProcessorInitialiseResult__ enumeration

0. OneTransactionPerDocument - used for posting documents individually
1. SingleTransactionForAllDocuments - used for posting all the documents in bulk

---

## ProcessDocument Method

This method is called once for each document to be processed.

### Signature
```csharp
ExportProcessorExportResult ProcessDocument(Guid guid, string documentNumber, string documentXml, Guid documentGuid, string documentType, string description);
```

### Arguments

| Argument      | Direction | Description
| ------------- | --------- | ------------ |
| Guid    | In        | GUID which identifies the unique entry in __dbo.DocumentsForPosting__ |
| documentNumber  | In        | The Document Number,  for example PINV1234 |
| documentXml  | In        | The XML as generated by the application hook |
| documentGuid  | In        | The GUID of the document which is being exported. (For example GUID from __dsdba.Invoices__) |
| documentType  | In        | The type of the document which is being exported. (For example INVOICE) |
| description  | In        | Name of the target system.  Always EXTERNAL in practice. |


### Returns

Returns a value from the __ExportProcessorExportResult__ enumeration

0. Success - The document was successfully posted and it's status should be updated to Posted and it's commitments released.
1. Skipped - This interface doesn't wish to post this document.
2. SuccessButDoNotMarkAsPosted - The document was successfully posted but it's status should NOT be updated to Posted and it's commitments should NOT be released. 
3. SecondarySuccess - This is not the primary document generated by an application hook.

---

## PostingComplete Method

This method is called last,  after __ProcessDocument__ has been called for each pending document.


### Signature
```csharp
void PostingComplete();
```

### Arguments

None

### Returns

Void

---


## Transaction Handling

There are two transaction handling modes available depending on the type of system you are interfacing with.


### OneTransactionPerDocument 
This is the more traditional model where each document is process in it's own transaction.

1. The documents are retrieved from the database
2. Initialise is called and returns a value of __OneTransactionPerDocument__
3. Each call to ProcessDocument is in it's own transaction
4. The final call to PostingComplete is not in a transaction.

If an exception is thrown by __ProcessDocument__ then the error message is record in the __dbo.DocumentsForPosting__ table and process continues with the next document.


### SingleTransactionForAllDocuments 
This means that either all documents will be exported or none of them.  This is typically used when writing to flat files.

1. The documents are retrieved from the database
2. Initialise is called and returns a value of __SingleTransactionForAllDocuments__
3. A transaction scope is then created
    - Each call to ProcessDocument is then within this transaction
    - The final call to PostingComplete is also within this transaction.

If an exception is thrown by either __ProcessDocument__ or __PostingComplete__ then entire process is rolled back and the error is recorded in the windows event log.

### No Transactions

By default your code will run in the transaction provided by the calling service.  If you wish your database code to run outside of this transaction scope,  then the following code maybe used

```csharp
using (var tx = new TransactionScope(TransactionScopeOption.Suppress))
{
    // ... your database code here...
}
```

---

## Example

See the [example applications](https://github.com/proactis-documentation/ExampleApplications/tree/master/P2P/Exports) for complete implementations.

---

## Deployment

Edit the file __"ConfigurationFolder\PROACTIS.P2P.AccountingExportService.exe.config"__ and ensure that the value for __VBProgID__ is set to blank.

```xml
<add key="VBProgID" value=""/>
```

Your dll should be complied (and named xyzExportProcessor.dll) and then copied into your __PROACTIS P2P/Plugins__  (or __Plugins/[database-title]__) folder.

## Database

The pending documents are held in the database table __dbo.DocumentsForPosting__.  In order to maintain compatibility with legacy code there is a view of this table called __dbo.InvoicesForPosting__.  For all new development the use of the base table is preferred. 