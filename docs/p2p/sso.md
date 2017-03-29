# Single-Sign-On (SSO)


## Windows Authentication


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



## Custom
