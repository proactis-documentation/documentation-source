# Troubleshooting

## New Transaction Cannot Enlist in the Specified Transaction Coordinator 

###  Applies To 
New installs of PROACTIS and the Management Console Server component, where the application and database are on different servers.  

### References 
[http://msdn2.microsoft.com/en-us/library/ms679479.aspx](http://msdn2.microsoft.com/en-us/library/ms679479.aspx)

### Summary 
The user receives the error **“New transaction cannot enlist in specified transaction coordinator”** when they try to logon via the website.  The error is also received when they try to amend data using the PROACTIS Management Console (PMC). 

### Solutions 
There are various different causes to this error, the following should be checked. 

1.    Network DTC is enabled on the application server, and allows outbound transactions. The server may require a reboot for any changes to these settings to take effect. 
2.    Network DTC is enabled on the database server, and allows inbound transactions. The server may require a reboot for any changes to these settings to take effect. 
3.    The two servers can successfully ping each other using both their IP addresses and their names.  If they can’t ping by name, try adding an entry to the hosts file on the machine. 
4.    Check the windows event log (application) on both machines for any reported errors.  Sometimes an error will be reported prompted and you may need to reinstall MSDTC as below: 
    * Msdtc –uninstall 
    * Reboot the server 
    * Msdtc – install 
  This is sometimes required when both machines are from the same 'base images'. 

5.    Try the DTC ping utility available from [here](https://support.microsoft.com/en-gb/help/918331/how-to-troubleshoot-connectivity-issues-in-ms-dtc-by-using-the-dtcping).  
If the server reports a warning message saying that the CID values are the same on both machines, then again the two machines have originated from the same image and MSDTC will need to be reinstalled on one of the machines.
  
6.    If the machines are not in the same domain, or in a work group then try reducing the authentication level to **No Authentication Required**


### dcomcnfg.exe
Enable MSDTC to allow the network transaction. To do this, follow these steps: 

* Click Start, and then click Run. 
* In the Run dialog box, type **dcomcnfg.exe**, and then click OK. 
* In the Component Services window, expand Component Services, expand Computers, and then expand My Computer. 
* Right-click My Computer, and then click Properties. 
* In the My Computer Properties dialog box, click Security Configuration on the MSDTC tab.
* In the Security Configuration dialog box, click to select the Network DTC Access check box. 
* To allow the distributed transaction to run on this computer from a remote computer, click to select the Allow Inbound check box. 
* To allow the distributed transaction to run on a remote computer from this computer, click to select the Allow Outbound check box. 
* Under the Transaction Manager Communication group, click to select the No Authentication Required option. 
* In the Security Configuration dialog box, click OK. 
* In the My Computer Properties dialog box, click OK. 

---