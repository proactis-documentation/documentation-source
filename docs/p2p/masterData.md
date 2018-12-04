# Import Master Data 

The Proactis XMLGateway allows users to maintain the following master data within P2P.

<!-- + [Addresses](#addresses)
+ [CompanyItemGroups](#companyitemgroups)
+ [Contracts](#contracts)
+ [Customers](#customers)
+ [ExchangeRates](#exchangerates)
+ [GlobalItems](#globalitems)
+ [HazardCodes](#hazardcodes)
+ [Items](#items)
+ [NominalGroupEntries](#nominalgroupentries)
+ [NominalGroups](#nominalgroups)
+ [ShortCuts](#shortcuts)
+ [StockItems](#stockitems)
+ [SupplierItemGroups](#supplierItemGroups)
+ [Suppliers](#suppliers)
+ [UNSPSCCodes](#unspsccodes)
+ [UOMFamilies](#uomfamilies)
+ [Users](#users)
-->

+ [Exchange Rates](#exchange-rates)
+ [Nominal Groups](#nominal-groups)
+ [Nominal Group Entries](#nominal-group-entries)
+ [Suppliers](#suppliers)


!!! note

    Not all master data types available for importing are fully documented yet. If you are interested in finding out more, please contact your Proactis account manager.


The XMLGateway web service is available at **http://***servername***/XMLGateway.asmx** (where *servername* is the root of your Proactis installation). The method to use is **ImportDocument**.

---

## XML structure


### Opening and closing tags

The XML must start with the following two lines in order to correctly declare the XML namespace to be used ...

```xml
<?xml version="1.0" ?>  
<pro:Import xmlns:pro="http://www.proactis.com/xml/xml-ns">
```

... and must be closed as follows ...

```xml
</pro:Import>
```

### Authentication

A control block must be immediately following the opening **&lt;pro:Import** tag so that the web service knows which database and company to use for the import.  The XMLGateway also supports WINDOWS NT authentication, depending on the authentication used different options will need to be specified.

The attributes for the control block are shown below. Please note that attributes in **bold** are mandatory.

| Attribute | Description |
|-----------|-------------|
|**Database** | The title of your P2P database as found in your PROACTIS_databases.xml. Hosted customers can contact support to find out their Proactis database title. |
|AuthenticationMethod |   Optional. The authentication type to use. Valid values are PROACTIS or WINDOWS. Omitting this value will assume PROACTIS. Customers using single sign on via SAML should setup a user account with PROACTIS authentication and provide the username and password.|
|UserName | The P2P user to make the request. Omitted if AuthenticationMethod is WINDOWS. |
|Password | The password of the P2P user. Omitted if AuthenticationMethod is WINDOWS. |
|**Company** | The P2P company code. |
|**Version** | Required. Must always be "1.0.0"   |
|ErrorHandlingMode| Possible values are EMBED where any errors are returned with the web service response, or THROWTEXT where the error message from P2P is thrown as an exception. Omitting the attribute assumes EMBED. |

An example of a control block for PROACTIS authentication is shown below.

```xml
<pro:Control Database="PROACTIS_LIVE" 
             UserName="IMPORT" 
             Password="mysecret" 
             Company="MAIN" 
             Version="1.0.0"
             ErrorHandlingMode="THROWTEXT"/>
```

An example of a control block for WINDOWS authentication is shown below.

```xml
 <pro:Control Database="PROACTIS_LIVE"
              AuthenticationMethod="WINDOWS"
              Company="MAIN"
              Version="1.0.0"
              ErrorHandlingMode="THROWTEXT"/>
```
   
The body of the request will depend on the object you want to maintain in Proactis. Examples for the various objects available are listed in the sections below. Please note that attributes in **bold** are mandatory.

Multiple objects may be passed as part of the request but be aware of potential performance impact if many objects are passed.

!!!note

    The P2P user must be a member of the DataImport role, in order to use the XMLGateway.


### Keys

The sections below include the possible attributes which may be used for each master data object. Key fields are highlighted in each object, these are the unique identifiers for the object in P2P. 

	
---
   
## Exchange Rates

### Quick start
The example below shows the xml required to load an exchange rate for a particular day. The currency code specified must exist as a valid currency in P2P for the target company.

```xml
<pro:ExchangeRates>
   <pro:ExchangeRate CurrencyCode="Euro" 
                     DateEffectiveFrom="2018-11-27" 
                     ExchangeRateHome1="0.6" />
</pro:ExchangeRates>
```

### Details

The description for the attributes available for the exchange rates request is shown below.

| Key | Attribute | Description |
|-----|-----------|--------------|
|| ACTION | Either STORE or REMOVE to add/update or delete the record. Default assumes STORE. |
|&#10004;| **CurrencyCode** | The currency code. |
|&#10004;| **DateEffectiveFrom** | The date the rate is effective from in the format yyyy-MM-dd. |
|| **ExchangeRateHome1** | The exchange rate to use. |

!!!note

    The way the rate is expressed (i.e. Home x Rate or Foreign x Rate) is determined by the setup of the currency in P2P. It is not possible to specify this on the request.

---

## Nominal Groups

### Quick start
The xml below shows an example of how to create a new nominal group.

```xml
<pro:NominalGroups>
    <pro:NominalGroup ACTION="STORE" 
                      Code="3_DEPT" 
                      Description="Department"/>
</pro:NominalGroups>
```

### Details

The description for the attributes available for the nominal groups request is shown below.

| Key | Attribute | Length |Description |
|-----|-----------|--------|------------|
|| ACTION    |  |Optional. Either STORE or REMOVE to add/update or delete the record. Default assumes STORE. |
|&#10004;| **Code** | 100 | The nominal group code. |
|| Description | 100 | The nominal group description. |
|| IsTopLevelGroup |  | YES indicates this the top level group. Default assumes NO. |
|| Reference1Caption | 50 | The caption to use for reference field 1 for this nomimal group. |
|| Reference2Caption | 50 | The caption to use for reference field 2 for this nomimal group. |
|| Reference3Caption | 50 | The caption to use for reference field 3 for this nomimal group. |
|| Reference4Caption | 50 | The caption to use for reference field 4 for this nomimal group. |
|| Reference5Caption | 50 | The caption to use for reference field 5 for this nomimal group. |
|| Reference6Caption | 50 | The caption to use for reference field 6 for this nomimal group. |


---

## Nominal Group Entries

### Quick start
The xml below shows an example of how to create a new nominal.

```xml
<pro:NominalGroupEntries>
    <pro:NominalGroupEntry ACTION="STORE" 
                           Code="00020" 
                           Description="Facilities" 
                           NominalGroup="3_DEPT" 
                           NominalSubGroup="4_COSTCENTRE"/>
</pro:NominalGroupEntries>
```

### Details

The description for the attributes available for the nominal entries request is shown below.

| Key | Attribute | Length |Description |
|-----|-----------|--------|------------|
|| ACTION    |  |Optional. Either STORE or REMOVE to add/update or delete the record. Default assumes STORE. |
|| Active | | Denotes whether the nominal is active or not, may be YES or NO. Default assumes YES. |
|&#10004;| **Code** | 30 | The nominal code. |
|| Description | 40 | The nominal description. |
|&#10004;| **NominalGroup** | 40 | The nominal group. |
|| NominalSubGroup | 40 | The nominal sub group. |
|| Band1DefaultTaxCode | | The default tax code for this nominal |
|| Reference1 | 50 | Reference 1 for this nominal. |
|| Reference2 | 50 | Reference 2 for this nominal. |
|| Reference3 | 50 | Reference 3 for this nominal. |
|| Reference4 | 50 | Reference 4 for this nominal. |
|| Reference5 | 50 | Reference 5 for this nominal. |
|| Reference6 | 50 | Reference 6 for this nominal. |


---

## Suppliers

### Quick start
The xml below shows an example of how to create a new supplier.

```xml
<pro:Suppliers>
   <pro:Supplier 
            Code="BOB001" 
            Title="Bob's Cleaning Company"
            External="YES"
            OneOffSupplier="NO"
            SalesTaxCountry="UK"
            SalesTaxNumber="1234567"
            SalesTaxRegistered="YES"
            DUNSNumber="123456789"
            CompanyRegistrationNumber="">
      <pro:SupplierBranches>
         <pro:SupplierBranch 
                   ACTION="STORE"
                   Active="YES"
                   AddressLine1="82 Roman Rd"
                   AddressLine2=""
                   AddressLine3=""
                   AddressLine4=""
                   Country="UK"
                   County="East Yorkshire"
                   Email="bob@cleanyerwindows.com"
                   Fax=""
                   Tag="default"
                   InvoiceAddress="YES"
                   OrderAddress="YES"
                   OutputType="email"      
                   PostCode="HU14 6JB"
                   PostTown="HULL"
                   Phone="07550872378"
                   Title="default" >
             <pro:SupplierBranchContacts>
                <pro:SupplierBranchContact 
                           ACTION="STORE"
                           Email="bob@cleanyerwindows.com"
                           Fax=""
                           Name="Bob Higgins"
                           Phone="07550872378"
                           Tag="bob"/>
             </pro:SupplierBranchContacts>
         </pro:SupplierBranch>
      </pro:SupplierBranches>
      <pro:CompanySupplier 
                 AccountingElement1=""
                 AccountingElement2=""
                 AccountingElement3="00020"
                 AccountingElement4=""
                 AccountingElement5=""
                 AccountingElement6=""
                 AccountingElement7=""
                 AccountingElement8=""
                 Active="YES"
                 AllowAutoInvoicing="NO"
                 AssessmentDate="2017-07-31"
                 AutoOutput="YES"   
                 Band1DefaultTaxCode="STD20"
                 BuyerMustReviewStockReplenishmentItems="YES"
                 CurrencyCode="GBP"
                 DefaultInvoiceBranchTag="default"
                 DefaultOrderBranchTag="default"
                 DocumentLevelValueMatching="NO"
                 InvoiceTray="Invoices"
                 InvoicingOnly="NO"
                 InvoicePriceToleranceAbs="10"
                 InvoicePriceTolerancePct="10"
                 InvoicesWithoutOrders="NO"
                 InvoicesWithoutReceipts="YES"
                 MandatoryOrderNumbersOnInvoice="YES"
                 NextAssessmentDate="2019-07-01"
                 PlazaOrganisationID=""
                 Reference1=""
                 Reference2=""
                 Reference3=""
                 Reference4=""
                 Reference5=""
                 Reference6=""
                 SupplierGrade="Standard">
         <pro:CompanySupplierGroups>
            <pro:CompanySupplierGroup ACTION="STORE" Group="Facilities-Yorkshire" />
            <pro:CompanySupplierGroup ACTION="STORE" Group="Facilities" />
         </pro:CompanySupplierGroups>
      </pro:CompanySupplier>
   </pro:Supplier>
</pro:Suppliers>
```

### Details

The description for the attributes available at the header lever a supplier record are shown below.


| Key | Attribute | Length | Description |
|-----|-----------|--------|-------------|
|&#10004;| **Code** | 25 | Supplier Code |
|| **Title** | 50 | Supplier name.  |
|| External |  | YES or NO. Default assumes NO. |
|| OneOffSupplier |  | YES or NO. Default assumes NO. |
|| **SalesTaxCountry** |  | Must be a valid country code in P2P. |
|| SalesTaxNumber | 17 | Supplier VAT or equivalent number. |
|| SalesTaxRegistered |  | YES or NO. Default assumes NO. |
|| DUNSNumber | 9 | If supplied must be nine numbers. |
|| CompanyRegistrationNumber | 8 | |

The supplier record is broken down into several sub sections listed below. 

#### Branches

Each supplier record must have one or more branches. The description for the attributes available for the supplier branches are shown below.


| Key | Attribute | Length | Description |
|-----|-----------|--------|-------------|
|| ACTION    |  | Either STORE or REMOVE to add/update or delete the record. Default assumes STORE. |
|&#10004;| **Tag** | 50 | A unique identifier for this branch. |
|| **Title** | 100 | A name for this branch. |
|| Active | | Denotes whether the nominal is active or not, may be YES or NO. Default assumes YES. |
|| AddressLine1 | 100 | |
|| AddressLine2 | 100 | |
|| AddressLine3 | 100 | |
|| AddressLine4 | 100 | |
|| Country | 100 | |
|| County | 100 | |
|| Email | 200 | |
|| Fax | 50 | |
|| Tag | 100 | |
|| InvoiceAddress | 100 | Indicates this the suppliers invoice address. YES or NO. Default assumes YES. |
|| OrderAddress | 100 | Indicates this the suppliers order address. YES or NO. Default assumes YES. |
|| OutputType | 100 | Indicates the default ouput type, permitted values are Email, Fax, Print or None. Default assumes None. |     
|| PostCode | 20 | |
|| PostTown | 100 | |
|| Phone | 20 |  |


##### Contacts

Each branch may have no, or many supplier branch contacts. If no supplier branches are required the **<pro:SupplierBranchContacts** tag can be omitted.

The description for the attributes available for the supplier branch contacts are shown below. 

| Key | Attribute | Length | Description |
|-----|-----------|--------|-------------|
|| ACTION    |  | Either STORE or REMOVE to add/update or delete the record. Default assumes STORE. |
|&#10004;| **Tag** | 50 | A unique identifier for this contact. |
|| Name | 30 | The name of the supplier branch contact. |
|| Email | 200 | |
|| Phone | 20 | |
|| Fax | 50 | |

#### Company Supplier

Each supplier must have a company supplier record. The company code is set in the [control block](#authentication), as such this object has no keys. 

The description for the attributes available for the company supplier settings are shown below. 


| Attribute | Length | Description |
|-----------|--------|-------------|
| ACTION    |  |Optional. Either STORE or REMOVE to add/update or delete the record. Default assumes STORE. |
|**SupplierGrade** | | The grade for this supplier. |
|**CurrencyCode** | | Default currency for this supplier. |
|**DefaultInvoiceBranchTag** |  | This indicates the default branch to use for invoicing. The value must match a valid branch tag from the [supplier branches](#branches) section. |
|**DefaultOrderBranchTag** | | This indicates the default branch to use for ordering. The value must match a valid branch tag from the [supplier branches](#branches) section. |
|Active | | Denotes whether the supplier is active in this company. Value may be YES or NO. Default is YES.|
|AccountingElement1|30| Accounting element 1 for this supplier. |
|AccountingElement2|30| Accounting element 2 for this supplier. |
|AccountingElement3|30| Accounting element 3 for this supplier. |
|AccountingElement4|30| Accounting element 4 for this supplier. |
|AccountingElement5|30| Accounting element 5 for this supplier. |
|AccountingElement6|30| Accounting element 6 for this supplier. |
|AccountingElement7|30| Accounting element 7 for this supplier. |
|AccountingElement8|30| Accounting element 8 for this supplier. |
|AllowAutoInvoicing | | Value may be YES or NO. Default is NO. |
|AssessmentDate | | Date of last assessment. Date must be in yyyy-MM-dd format. |
|AutoOutput | | Value may be YES or NO. Default is NO. |   
|Band1DefaultTaxCode | | Default tax code for supplier. |
|BuyerMustReviewStockReplenishmentItems | | Value may be YES or NO. Default is NO. |
|DocumentLevelValueMatching | | Value may be YES or NO. Default is NO. |
|InvoiceTray | | The default invoice tray for this supplier. |
|InvoicingOnly | | Value may be YES or NO. Default is NO. |
|InvoicePriceToleranceAbs | | Over-delivery tolerance value. |
|InvoicePriceTolerancePct | | Over-delivery tolerance percentage. |
|InvoicesWithoutOrders | | Value may be YES or NO. Default is NO. |
|InvoicesWithoutReceipts | | Value may be YES or NO. Default is NO. |
|MandatoryOrderNumbersOnInvoice | | Value may be YES or NO. Default is NO. |
|NextAssessmentDate | | Date of next assessment. Date must be in yyyy-MM-dd format |
|PlazaOrganisationID | 50 | S2C OrganisationID. Only required if integrating with Proactis Source to Contract. |
|Reference1 |100| Reference 1 for this supplier |
|Reference2 |100| Reference 2 for this supplier |
|Reference3 |100| Reference 3 for this supplier |
|Reference4 |100| Reference 4 for this supplier |
|Reference5 |100| Reference 5 for this supplier |
|Reference6 |100| Reference 6 for this supplier |


##### Groups

Each supplier may have no or many supplier groups within a company. If no supplier groups are required the **<pro:CompanySupplierGroups** tag can be omitted.

The description for the attributes available for the supplier groups are shown below. 

| Attribute | Length | Description |
|-----------|--------|-------------|
| ACTION    |  |Optional. Either STORE or REMOVE to add/update or delete the record. Default assumes STORE. |
|**Group** | | The supplier group. |