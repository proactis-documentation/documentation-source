# Addins

This document summaries the add-in functionality available in P2P-2016 to Professional Services. Specifically it discusses the “addInClient” javaScript library that is expected to be included in each add-in page that needs to communicate with the main P2P session. 
 
---

# Background 
It is assumed that add-in pages will live in AddIns sub-folder of the Customer virtual directory in the root of the web site. Indeed, the system will not function if they reside anywhere else. 
 
 
 
An add-in page will communicate with the parent P2P application via javaScript calls exposed by the addInClient library. 
 
The main web site has a CustomSupport folder that contains the files that need to be included (some optionally) in each add-in page. 
 
 
AddInClient.js:  mandatory for communication between the add-in page and the owning main P2P page in the client’s browser (which can in turn communicate with the server) 
jquery-xxx.im.js: mandatory  
jquery.filerNode.js: mandatory if you wish to use the xml services exposed by the AddInClient class, for manipulating order/invoice xml. Otherwise can be left out. 
kendo.xxx.min.js, Notifications.inc, Site.css: mandatory if you wish to use the same notification services and styling as the main web site for info, alert and error messages. Otherwise can be left out. 
Site.css: As well as notification styling mentioned above, sets the default font-family and font size for the page. 
 
  
addInClient  
A core deliverable for any javaScript add-in solution, is the recognition that any single add-in page may need to make numerous AJAX calls in order to retrieve all the data it requires in order to function. Since those AJAX calls are asynchronous, the challenge is how to co-ordinate and handle their callbacks. 
 
The addInClient javaScript class solves the callback challenge. Through the use of jQuery Deferred/Promise functionality, it can accept any number of AJAX calls as input, will manage their respective callbacks, combine the data retrieved and make that data available to the caller.  
 
The addInClient class exposes the following AJAX methods. Understand that these calls are asynchronous. The return values described below are not returned directly but rather indirectly via the “MonitorAjaxCalls” method. The methods below directly return a jQuery Promise object. 
 
* GetSessionID() 
o Returns the current session-id 
* GetSessionParm(keyName) 
o Returns the session value (as a string) stored against the specified key-name. 
o Returns null if the session value is not present 
* GetSessionParms(keyNames) 
o Accepts an array of key-names and returns the corresponding session values (or null values if the session value does not exist) 
o Return value is a JSON array of key/value pairs 
o First entry in return array is always the session-id. 
* GetOrderInEdit() 
o Returns the full order xml (including all lines) for the order currently in edit in the current session. 
o Returns an error if no order is currently in edit 
* GetOrderInEditWithoutLines() 
o Returns the order xml with an empty LineSet xml node (i.e. order header and footer only) 
o Returns an error if no order is currently in edit 
* GetInvoiceInEdit() 
o Returns the full invoice xml (including all lines) for the invoice currently in edit in the current session. 
* GetInvoiceInEditHeader() 
o Returns the invoice header xml for the invoice currently in edit in the current session. 
* GetInvoiceInEditFooter 
o Returns the invoice footer xml for the invoice currently in edit in the current session. 
 
 
* MonitorAjaxCalls(ajaxCalls) 
o Accepts an array of any combination of the above AJAX “Get…” methods. Since each of the above “Get…” methods actually returns a jQuery Promise object, the input to this method is actually an array of those Promise objects to be monitored.  
o Returns a single jQuery Promise object to which resolve/fail events can be attached 
o If all input “Get…” methods succeed then  
* All “resolve” events attached to the returned Promise, are triggered (in the order in which they were attached) 
* Each “resolve” event is passed the following parameters 
* Results: an array of return values, matching the AJAX calls that were input. The array entries will be simple strings, JSON key/value arrays or xml strings, as per the return types from the above “Get…” methods.  
* AlertMessages: an array of all alert messages output by the AJAX “Get…” messages (I don’t think there are any…. Yet!) 
* InfoMessages: an array of all info messages output by the AJAX “Get…” messages (I don’t think there are any…. Yet!) 
o If any of input AJAX “Get…” methods fail then 
* All “fail” events attached to the returned Promise, are triggered (in the order in which they were attached) 
* Each “fail” event is passed an array of error messages. 
* Even if some of the input AJAX “Get…” events succeed, no “resolve” events are triggered. 
* HandleError(errorMessages) 
o Will test for the presence of notification services and output formal error notifications if possible. Otherwise will issue alerts for each error message. 
* XMLServices 
o Exposes a set of helper methods for working with document xml (i.e. xml with the “grs” namespace). 
o The following methods are available 
* loadDOM(xml) 
* Accepts an xml string and returns a jQuery DOM object 
* getNode(parentNode, nodeName) 
* Accepts a parent node (or the DOM) and the name of an immediate child element. 
* Returns the child element 
* nodeName can be an array of element names. Where each name corresponds to an element that is a child of the previous name (element).  
* attr(node, attributeName) 
* Returns the given attribute of the given element. 
* getNodeAttr(parentNode, nodeName, attributeName) 
* Finds the specified immediate child element of the parent node and returns the specified attribute value. 
* filterNodeAttr(parentNode, nodeName, attributeName, attributeName) 
* Finds the specified immediate child element of the parent node, which also has an attribute with the specified name and value. Returns the text value of that child element. 
 
Sample Add-In 
There is a sample add-in and xml file in Custom section of the Documentation folder on the build-CD. 
The sample is available from the multi-line orders page and shows how order information can be retrieved and displayed. 