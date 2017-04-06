# Custom Imaging DLLs

## Overview
The PROACTIS P2P product has been designed so that it can be easily integrated with a number of different Document Management Systems (DMS).

A typical PROACTIS imaging solution requires the following integration points:-

1.	The scanned image needs to be associated with an invoice within PROACTIS.
2.	Users need to be able to see the original scanned image by clicking a link within the PROACTIS web site.

Although there are many different possible methods available (as different DMS and customers have different requirements) a generic imaging DLL has been written which meets the majority of customer’s requirements.

For the cases where neither the built-in PROACTIS imaging solution or the Generic Imaging DLLs meet your requirements a completely custom DLL can be written.

---

## Viewing Images

+ Create a new C# Class Library project called xyzImaging. ( _xyz_ can be anything)

+ Add a reference to __Purchasing Server\bin\PROACTIS.P2P.grsImagingIface.dll__

+ Add a class called __Imaging__ which implements the __grsImageIface.IImaging__ interface.

+ Write an implementation of the following methods.
    -   GetImage
    -   GetImageInfo
    -   HasImage

---

### HasImage
Controls if the View Image link is available when looking at a transaction within P2P

```C#
bool IImaging.HasImage(string DocumentDetailsXML)
```

#### Arguments

| Argument      | Direction | Description
| ------------- | --------- | ------------ |
| DocumentDetailsXML   | In        | An xml document containing the details of the document currently being displayed. |

#### Return Value
The function should return True if an image is available.

---

### GetImageInfo
Returns basic information (MimeType and NumberOfPages) for an image held against a document.

```C#
int IImaging.GetImageInfo(string DocumentDetailsXML, ref string MIMEType)
```

#### Arguments

| Argument      | Direction | Description
| ------------- | --------- | ------------ |
| DocumentDetailsXML   | In        | An xml document containing the details of the document currently being displayed. |
| MIMEType | Out | Mime type of the document

#### MIMEType
This should be set to the MIME type of the image.    If image will be display via an URL to another system this must be set to text/url.

#### Return Value
The function should return the name of pages within the document.  Normally 1

---

### GetImage
Used to return either the bytes which make up the image of the URL for the image if it's in a DMS.

```c#
bool IImaging.GetImage(string DocumentDetailsXML, ref string MIMEType, ref byte[] Image, ref string URL)
```

#### MIMEType
This should be set to the MIME type of the image.    If image will be display via an URL to another system this must be set to text/url.

#### Image
The image file as an array of bytes.  This will be steamed to the client's browser

#### URL
The URL of image in a DMS.

!!! notes

    Either the Image _or_ URL argument should be used.

---

### DocumentDetailsXML
The xml in the DocumentDetailsXML argument is made up from some context specific details based on the document being display and the settings you have defined in the imaging settings table.

```xml
<?xml version="1.0"?><grs:ImagingSettings xmlns:grs="http://www.getrealsystems.com/xml/xml-ns">
<grs:SessionID>eb89c444-0270-4f06-b8b6-ec0303b00117#dbserver2008r2\qa#DavidB_94#en-gb</grs:SessionID>
<grs:DocumentType>I</grs:DocumentType>
<grs:DocumentGUID>{D79D1EE8-4B87-414B-8512-92590DFBE2E8</grs:DocumentGUID>
<grs:ImageNumber>0</grs:ImageNumber>
<grs:CompanyGUID>{A2FEEDC5-978F-11D5-8C5E-0001021ABF9B</grs:CompanyGUID>

<grs:InvoiceImageIdentifier>DisplayNumber</grs:InvoiceImageIdentifier>
<grs:DefaultImageSource>URL</grs:DefaultImageSource>
<grs:DefaultURL>https://sp-db01/imaging/{{ImageID}}.bmp</grs:DefaultURL></grs:ImagingSettings>
```

The standard fields which are always supplied as:-
* SessionID - in the format {uniqueID} # {database server} # {database name} # {user's language}
* DocumentType - 'I' for Invoice,  'C' for Credit note',  'E' for Expense Claim and 'A' For Acceptance 
* DocumentGUID - GUID to identify the document being displayed
* ImageNumber
* CompanyGUID - GUID of the company in which the document belongs

In the above example the remain fields (below) are from the __DSDBA.ImagingSettings__ table.

* InvoiceImageIdentifier
* DefaultImageSource
* DefaultURL

---