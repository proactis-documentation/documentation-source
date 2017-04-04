# Add-ins

P2P supports the concept of 'Add-ins' which are additional custom links which can be added to any page within the core website.



---

# Setup

1. Ensure that a sub-folder called __Addins__ exists within the Customer virtual directory in the root of the web site. 

2. If the folder doesn't already contain a file called __Addins.xml__ then create the following file.  If the file does already exist then add your new page to it.

```xml
<AddIns>
	<Page Name="Purchasing/Orders/Plus/MultiLineEntry.asp">
		<Link AddInURL="SampleOrderAddIn.aspx" WindowWidth="900" WindowHeight="600" WindowName="OrderTaxReset">Sample Order AddIn</Link>
	</Page>
</AddIns>
```

In the example above,  a link captioned __Sample Order Addin__ will be added to the __MultiLineEntry.asp__ page.  When this link is clicked a new window will open (900x600) which will display the URL __SampleOrderAddIn.aspx__

3. In the same folder create your add-in page.   (_For example SampleOrderAddIn.aspx_)

4. If you wish your add-in to interact with the main site,  then please read the following _Javascript_ section.

---

# CSS

In order to pick up some of the styling from the main site (such as the default font-family and font size for the page) the __CustomSupport/Site.css__ style-sheet should be referenced.

```html
<link rel="stylesheet" type="text/css" href="../../CustomSupport/Site.css" />
```

---

# Javascript 
An add-in page can communicate with the parent P2P application via javaScript calls exposed by the addInClient library.


## Includes 
The main web site has a __CustomSupport__ folder that contains the files that need to be included (some optionally) in each add-in page.

__AddInClient.js__:  mandatory for communication between the add-in page and the owning main P2P page in the client’s browser (which can in turn communicate with the server)

__jquery-xxx.im.js__: mandatory  

__jquery.filerNode.js__: mandatory if you wish to use the xml services exposed by the AddInClient class, for manipulating order/invoice xml. Otherwise can be left out. 

__kendo.xxx.min.js__, Notifications.inc, Site.css: mandatory if you wish to use the same notification services and styling as the main web site for info, alert and error messages. Otherwise can be left out. 

```html
    <script src="../../CustomSupport/jquery-2.2.4.min.js"></script>
    <script src="../../CustomSupport/jquery.filerNode.js"></script>
    <script src="../../CustomSupport/AddInClient.js"></script>
    <script src="../../CustomSupport/kendo.core.min.js"></script>
    <script src="../../CustomSupport/kendo.notification.min.js"></script>
    <script src="../../CustomSupport/kendo.popup.min.js"></script>
```
---
 
## __addInClient__ 
A core deliverable for any javaScript add-in solution, is the recognition that any single add-in page may need to make numerous AJAX calls in order to retrieve all the data it requires in order to function. Since those AJAX calls are asynchronous, the challenge is how to co-ordinate and handle their callbacks.

The addInClient javaScript class solves the callback challenge. Through the use of jQuery Deferred/Promise functionality, it can accept any number of AJAX calls as input, will manage their respective callbacks, combine the data retrieved and make that data available to the caller. 

The __addInClient__ class exposes the following AJAX methods. Understand that these calls are asynchronous. The return values described below are not returned directly but rather indirectly via the __MonitorAjaxCalls__ method. The methods below directly return a jQuery Promise object. 
 

### GetSessionID()
- Returns the current session-id.

### GetSessionParm(keyName)
- Returns the session value (as a string) stored against the specified key-name. 
- Returns null if the session value is not present.

### GetSessionParms(keyNames) 
Accepts an array of key-names and returns the corresponding session values (or null values if the session value does not exist) Return value is a JSON array of key/value pairs First entry in return array is always the session-id. 

### GetOrderInEdit() 
- Returns the full order xml (including all lines) for the order currently in edit in the current session. 
- Returns an error if no order is currently in edit.

### GetOrderInEditWithoutLines() 
- Returns the order xml with an empty LineSet xml node (i.e. order header and footer only). 
- Returns an error if no order is currently in edit 

### GetInvoiceInEdit() 
- Returns the full invoice xml (including all lines) for the invoice currently in edit in the current session. 

### GetInvoiceInEditHeader()
- Returns the invoice header xml for the invoice currently in edit in the current session. 

### GetInvoiceInEditFooter() 
- Returns the invoice footer xml for the invoice currently in edit in the current session. 

### MonitorAjaxCalls(ajaxCalls) 

- Accepts an array of any combination of the above AJAX “Get…” methods. Since each of the above “Get…” methods actually returns a jQuery Promise object, the input to this method is actually an array of those Promise objects to be monitored.  
- Returns a single jQuery Promise object to which resolve/fail events can be attached 
- If all input “Get…” methods succeed then  
    - All “resolve” events attached to the returned Promise, are triggered (in the order in which they were attached) 
    - Each “resolve” event is passed the following parameters 
    -    __Results__: an array of return values, matching the AJAX calls that were input. The array entries will be simple strings, JSON key/value arrays or xml strings, as per the return types from the above “Get…” methods.  
    -    __AlertMessages__: an array of all alert messages output by the AJAX “Get…” messages
    -    __InfoMessages__: an array of all info messages output by the AJAX “Get…” messages
- If any of input AJAX “Get…” methods fail then 
    - All “fail” events attached to the returned Promise, are triggered (in the order in which they were attached) 
    - Each “fail” event is passed an array of error messages. 
    - Even if some of the input AJAX “Get…” events succeed, no “resolve” events are triggered. 

### HandleError(errorMessages)

Will test for the presence of notification services and output formal error notifications if possible. Otherwise will issue alerts for each error message. 

---

## XMLServices 
Exposes a set of helper methods for working with document xml (i.e. xml with the “grs” namespace). The following methods are available 

### loadDOM(xml) 
- Accepts an xml string and returns a jQuery DOM object 

### getNode(parentNode, nodeName) 
- Accepts a parent node (or the DOM) and the name of an immediate child element. 
- Returns the child element 
- nodeName can be an array of element names. Where each name corresponds to an element that is a child of the previous name (element).  

### attr(node, attributeName) 
- Returns the given attribute of the given element. 

### getNodeAttr(parentNode, nodeName, attributeName) 
- Finds the specified immediate child element of the parent node and returns the specified attribute value. 

### filterNodeAttr(parentNode, nodeName, attributeName, attributeName) 
- Finds the specified immediate child element of the parent node, which also has an attribute with the specified name and value. 
- Returns the text value of that child element. 
 
---

# Sample Add-In 
There is a sample add-in and xml file available [here](https://github.com/proactis-documentation/ExampleApplications/tree/master/P2P/Addins).

The sample is available from the multi-line orders page and shows how order information can be retrieved and displayed. 