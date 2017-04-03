# Custom Tab

The P2P website can be extended by creating additional "custom" tabs.  

!!! Note

    In order to display a custom tab you will first need a licence file which includes the name of the tab.  Please contact your account manager for assistance with this.

# Process
Custom tab are developed as independent websites which are then displayed as part of the core site within an iFrame.

By convention the custom sites are placed within the WebSite\Custom folder and are mapped as a virtual application with in IIS.   

Once the licence file has been applied then the name of the new tab will appear in the menu bar along the top of the screen.

Clicking on the new tab will open the your landing page (configured in app config) within a new iframe.

---

# Session Details
As the custom tab is running in a different website to the main site it is not possible to share the session state within IIS.

Instead the following steps must be followed in order to obtain the details of the current user.

+ Before the main site opens your landing page it first generates a unique session token which is stored in the database within the __dsdba.LoginTokens__ table.  This table also holds who the current user is. 

+ When the landing page is opened,  it is passed the following information as query string parameters
    - Token  (the unique token)
    - Title  (the name of the tab)
    - URL    (the url of the tab)

    The token argument is made up of the {Database's Title} @ {The unique generated session token}

+ The custom tab should then connect to the P2P database and call the __DSDBA.usp_cust_GetSessionDetailsFromToken__ stored procedure supplying the full token.  This stored procedure will return with a single row containing the following columns:

    - UserGUID
    - LoginID
    - CompanyGUID
    - CompanyCode
    - DepartmentGUID
    - DepartmentCode
    - StoreGUID
    - StoreCode
    - SessionID  (the internal P2P session ID)
    - Expires  (when the login token will expiry)

!!! warning

    The stored procedure will return a row even when the session ID is not valid.  In this case however all the values will be NULL.

---
# Please Wait Spinner
Whilst your tab is first loading the main site will be displaying the please wait spinner.  In order to remove the spinner the following javascript code should be added to the end of your first page

```javascript
    <script type="text/javascript">
        //Hide the spinner in the main window.
        $().ready(function () {
            parent.hideSpinner();
        });
    </script>
```    

---

# User Role Security
By default all users have access to the new tab.  If you wish to restrict access to our certain users then the name of a user role (or a custom role) can be specified for the tab within the licence file.

If you wish to create a custom role,  then you will also need to insert an entry into the __DSDBA.Roles__ table with the same name.

```sql
INSERT INTO DSDBA.Roles (GUID, Code, Description, Properties, CompanyGUID)
SELECT newID(), 'MyCustomRole', 'Users may use custom tab', '', C.GUID
  FROM DSDBA.Companies C
```  

