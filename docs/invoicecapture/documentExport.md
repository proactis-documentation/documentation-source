# Invoice Capture Document Export

The Invoice Capture document export API allows export of documents and images from the Invoice Capture "staging area" to third party systems using RESTful web services.  

Once processed, third-party systems can provide feedback to Invoice Capture to confirm successful export or record any relevant error messages.  If the document fails to export it can be corrected within Invoice Capture (if required) and then made available for export again.

The sections below show the various API calls available and their required parameters. Please note that parameters should be passed as URL parameters unless specified otherwise.  

The response sections included below all assume the web service call is successful, returning an HTTP 200 code. Requests which are unauthorised will return a 401 error code, all other unsuccessful web service calls will return a 400 error code along with a detailed description of the error.

---

##Authentication

Authentication with Invoice Capture is performed with the use of an API key. This key is a one-time generated key, which can be used by the third party to generate an access token prior to each API call.  Access tokens are valid for up to 3 hours, but expire after 10 minutes of inactivity.

You can get the API key for your Invoice Capture instance by contacting Proactis support.

All URLs given are relative to the root of your Invoice Capture instance.

###Request

**URL**

| Method | URL |
|--------|-----|
| **GET** | **/API/ExportStagingArea/Account/GetAccessToken** |


**Parameters**

| Mandatory | Parameter | Value |
|----------|-----|-----------|
| &#10004; | apiKey | API key from Proactis |

###Response

The web service will return an access token which can be used to call the other web services.

```xml
"54ece54e-98c2-432d-9c0d-b098e80f631d"
```

---

##Get Available Formats

Documents may be exported in a number of different formats. The GetAvailableFormats web service returns the formats available to your Invoice Capture instance. 

The format type is required when calling the Documents export web service

###Request

**URL**

| Method | URL |
|--------|-----|
| **GET** | **/API/ExportStagingArea/Documents/AvailableFormats** |

**Parameters**

| Mandatory | Parameter | Value |
|----------|-----|-----------|
| &#10004; | Token | The access token returned by the GetAccessToken web service |


###Response

The list of available formats is returned as a string array.

```json
[
    "JSON Invoice"
]
```

---

## Get Documents to Process

The ReferenceData web service returns a list of documents from Invoice Capture based on the parameters passed. You can search for all documents or just those pending processing and filter based on the date they were exported from Invoice Capture.

###Request

**URL**

| Method | URL |
|--------|-----|
| **GET** | **/API/ExportStagingArea/Documents/ReferenceData** |

**Parameters**

| Mandatory | Parameter | Value |
|----------|-----------|-------|
| &#10004; | Token | The access token returned by the GetAccessToken web service |
| &#10004; | State | Valid values are All or Pending. **All** returns all documents. **Pending** returns those which have not yet been confirmed as exported. |
| | StartDate | Optional. Only returns documents where the exported date is greater than or equal to the supplied date. Date must supplied in the format yyyy-MM-dd. |
| | EndDate | Optional. Only returns documents where the exported date is less than or equal to the supplied date. Date must supplied in the format yyyy-MM-dd. |


###Response

The list of documents is returned as a JSON array. An example of the response is shown below.  


```json
[
    {
        "DocumentId": "7eb8f4c5-e621-4d59-a054-9ef1c5bbffc5",
        "DocumentType": "INVOICE",
        "SubType": "INVOICE"
    },
    {
        "DocumentId": "012e155b-fec2-4936-b59f-c822f59a2e97",
        "DocumentType": "CREDITNOTE",
        "SubType": "CREDITNOTE"
    },
    {
        "DocumentId": "40e68445-bc76-446a-8423-f617c54db7f6",
        "DocumentType": "INVOICE",
        "SubType": "STOCK-INVOICE"
    }
]
```

| Parameter | Value |
|-----------|-------|
| DocumentId | The unique identifier for this document in Invoice Capture. |
| DocumentType | The Invoice Capture document type.  |
| SubType | The Invoice Capture batch class. |


--- 

##Export Document

The Documents web service can be used to download full details of a document from Invoice Capture.


###Request

**URL**

| Method | URL |
|--------|-----|
| **GET** | **/API/ExportStagingArea/Documents** |


**Parameters**

| Mandatory | Parameter | Value |
|----------|-----------|-------|
| &#10004; | Token | The access token returned by the GetAccessToken web service |
| &#10004; | DocumentId | The documentId to download. |
| &#10004; | DocumentFormat | The format returned you want the document to be returned in. This must be a valid value returned by the AvailableFormats web service. |

###Response

The response will depend on the on the DocumentFormat specified in the request. An example of a **JSON Invoice** document is shown below.

```json
{
    "DocumentId": "7eb8f8c5-e321-4d59-a054-9ef1c5bbffc5",
    "DocumentNo": "1",
    "DocumentReference": "9000000001",
    "DocumentType": "INVOICE",
    "DocumentNote": null,
    "DocumentCreatedDate": "2019-01-03T12:47:42",
    "BatchNo": "1",
    "BatchReference": "MAIL_CUST201913-12:47",
    "BatchClass": "INVOICE",
    "ScanReference": "Email:bob@cleanyerwindows.com",
    "Supplier": {
        "Code": "BOB001",
        "Name": "Bob's Cleaning Company",
        "AddressLine": "82 Roman Rd, HULL, East Yorkshire",
        "PostCode": "HU97 9JB",
        "AllowStandaloneInvoices": "False"
    },
    "INVOICENO": "B0011651",
    "INVOICEDATE": "2019-12-21T00:00:00",
    "PURCHASEORDERNO": "N",
    "INVOICENET": "590.20",
    "INVOICETAX": "0.00",
    "INVOICEGROSS": "590.20",
    "CURRENCY": "GBP",
    "InvoiceLines": []
}
```


--- 

##Download Document PDF

The DownloadAsPdf web service can be used to download the PDF associated with a document in Invoice Capture.


###Request

**URL**

| Method | URL |
|--------|-----|
| **GET** | **/API/ExportStagingArea/Documents/DownloadAsPdf** |


**Parameters**

| Mandatory | Parameter | Value |
|----------|-----------|-------|
| &#10004; | Token | The access token returned by the GetAccessToken web service |
| &#10004; | DocumentId | The documentId to download. |

###Response

The web service returns the pdf document as a byte array.

---

##Record Import Response

Once a document has been retrieved and processed, the RecordImportStatus web service can be called to update the status the document in Invoice Capture. Calling this web service will remove the document from the pending queue and can be marked either as sucessfully processed or in error. Optionally, a response message can be included which will be visible on the audit history of the document within Invoice Capture.

###Request

**URL**

| Method | URL |
|--------|-----|
| **POST** | **/API/ExportStagingArea/Documents/RecordImportResponse** |

**Parameters**

| Mandatory | Parameter | Value |
|----------|-----------|-------|
| &#10004; | Token | The access token returned by the GetAccessToken web service |
| &#10004; | DocumentId | The documentId to update.  |
| &#10004; | Response Flag | Records the success or failure of processing the document. Permitted values are 1 (success) or 2 (error). |
|  | ResponseMessage | Optional. A response message from the third party system. This will be visible on the audit history of the document in Invoice Capture. |

###Response

If this web service succesfully updates the document status the message below will be returned.

```json
"Response successful recorded."
```