# Assign Topics Unscoped

**As of:** Spring'25

**Authored By:** George Abboud

**Last Updated:** 3/20/2025

* * *


# Overview:

![image](https://user-images.githubusercontent.com/8514282/153294570-1b8183cb-9394-409f-99ea-f58899ab01e9.gif)

AppExchange Listing:
https://appexchange.salesforce.com/appxListingDetail?listingId=a0N3A00000FeGV5UAN

Open-Source Code:
https://github.com/salesforce-experiencecloud/AssignTopicsUnscoped



## Description:

Lightning component that can be placed on the detail page for any object which topics are enabled for. Component allows for assigning topics to records across both the internal org and external communities. Navigational, Featured, and Content topics are also highlighted. 

Pre-requisite: Chatter with Topics for Objects 
Note: When placing this component on an object record lightning page, please ensure that topics for objects is enabled for that specific object.

### Disclaimer:

This package is free to use, but is not an official [salesforce.com](http://salesforce.com/) product, and should be considered a community project. The functionality is not officially tested or documented, and does not come with any support, warrantees, or updates. It is offered as-is.

## What?

Lightning Component that allows users to assign topics from any community or the internal org, to a record.

## Why?

This alleviates some of the overhead and challenges of having to switch back and forth between the community and the internal org, in order to manage topics around records within the scope of a specific network. It will allow users to be able to manage topics across multiple scopes / networks from one place.

## Where?

Can be used on any lightning record detail page, as long as that object has topics enabled.

## How?

1. Ensure topics for objects is enabled for your object
2. Install unmanaged package
3. Update or create a lightning record page for your object
4. Drag the “Assign Topics Unscoped” component anywhere on the page and save it!



## Release Log:

### Version 1.2 - managed

Installation URL: https://login.salesforce.com/packaging/installPackage.apexp?p0=04t1U000007Y1Zz

* Updated Apex classes to most recent API version for compatibility with ICU Format enablement in orgs



### Version 1.1 - managed

Installation URL: https://login.salesforce.com/packaging/installPackage.apexp?p0=04t1U000003Bnj3 

* Added design property to be able to set default community



### Version 1.2 - Unmanaged

Installation URL: https://sfdc.co/AssignTopicsUnscoped

* Added CRED checks in apex controllers
* Fixed bug with 1 character followed by space character search

### Version 1.1 - Unmanaged

Installation URL: Deprecated

* Added icons and text to highlight navigational / featured topics

### Version 1.0 - Unmanaged

Installation URL: Deprecated

* Initial Release

