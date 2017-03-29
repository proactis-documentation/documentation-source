# P2P Single-Sign-On (SSO)


## Windows Authentication
If your PROACTIS P2P server is on the same domain as your users then the system can be configured so that they are automatically signed on without the need for them to re-enter their username and password.

1. Do this is IIS

2. Add this to the application configuaration file

3. Set the NTLogon flag to 1 against the users,  and ensure that their usernames are in the format DOMAIN\Username.  For example PROACTIS\DavidBetteridge



## SAML2
PROACTIS P2P has built in support for SSO using the industry standard SAML2 protocol.

1 First generate (or obtain) a certificate and provide the public part of this to your identity provider
2 With in your website's customer folder create a file called saml.config.   This should be based on the following template.


```xml
<?xml version="1.0"?>
<SAMLConfiguration xmlns="urn:componentspace:SAML:2.0:configuration">
   <ServiceProvider Name="service-provider-name"
                    AssertionConsumerServiceUrl="~/SystemLogon/AssertionConsumerService"
                    LocalCertificateFile="path-to-local-certificate-file"
                    LocalCertificatePassword="local-certificate-password"/>
 
 
   <!-- ADFS -->
   <PartnerIdentityProviders>
      <PartnerIdentityProvider Name="partner-identity-provider-name"
                Description="PROACTIS AD"
                               SignAuthnRequest="false"
                               WantSAMLResponseSigned="false"
                               WantAssertionSigned="true"
                               WantAssertionEncrypted="true"
                               PartnerCertificateFile="path-to-partner-certificate-file"
                               ClockSkew="00:03:00"
                               SingleSignOnServiceUrl="single-sign-on-service-url"/>
   </PartnerIdentityProviders>
 
</SAMLConfiguration>
```

3 Add the following settings to your application.configuration file
```xml
<Setting Name="SSOAttributeName">NameID</Setting>
```
The name of the attribute containing the user identifier in the attributes list returned from the ADFS server.
If not specified then no attribute lookup is made and user identification is based on the “username” returned from the ADFS server.
 
```xml
<Setting Name="SSOAttributeNameMask"></Setting>
```
An optional mask to be applied to the above user identifier value.
 
```xml
<Setting Name="SSOMatchP2PUserOnEmailAddress">False</Setting>
```
By default, P2P searches the database Users table to find a user whose “LoginID” matches the identifier value returned from the ADFS server.
This optional setting will cause the lookup to be made on “EmailAddress” rather than “LoginID”
 
```xml
<Setting Name="SSODatabaseTitle"></Setting>
```
An optional setting that only applies when a user who is already logged into a 3rd party system, initiates a logon to P2P via SSO. In this scenario, the user is not 
presented with a logon page. If the user has access to multiple databases, then this setting specifies the database title (in the database xml file) to log into.
If this setting is not present, P2P will select the default database in the databases xml file (or the first database if no default).
Obviously if only one database is available, then this setting is unnecessary.



## External
By default PROACTIS P2P validates the username and password entered by the user against the record in the dsdba.Users table.   It is however possible to customise PROACTIS so that users are validated against an external userstore such as LDAP.

The following steps should be followed in order to create an external validation DLL.

1. Create a new C# class library with a class called Services which implements the ILogin interface.  This interface can be found in the PROACTIS.P2P.grsCustInterfaces.DLL

2. Decide if your login process will be called asynchronously or not and implement the UseAsynchronousImplementation as required.

```C#
    public bool UseAsynchronousImplementation => false;
```
3. Implement the Login (or LoginAsync) method with your custom validate code.  This method should return True for a successfully login and False for a failure.  For security reasons it is recommended that exceptions aren't thrown informing the user why the login failed.  For example the username does not exist.

4. Compile your code,  and ensure that the resulting DLL is named *Login.DLL.   (* can be anything)

5. Copy the DLL into your PROACTIS P2P/Plugins folder.

7. Add the following setting into your applicationconfiguration.xml file.
```xml
<Setting Name="AuthenticationMethod">EXTERNAL</Setting>
```
