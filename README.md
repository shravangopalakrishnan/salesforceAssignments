**API ASSIGNMENTS:**


**QUESTION 1:**

When a contact is created/deleted, make a callout to third party system https://demo.com and send the contactId.

**Files to check:** ContactTrigger, ContactCalloutService, ContactCalloutServiceTest, MockHttpResponse

--------------------------------------------------------------------------------------------------------

**QUESTION 2:**

Connect two Salesforce Orgs, say Org_A and Org_B, in such a way that, whenever a Lead is created, a copy of it should be created in Org_B and when a Lead is updated/ deleted in Org_A, same action must be performed on the corresponding Lead in Org_B.

**Files to check:** LeadSyncTrigger, LeadSyncHandler, LeadSyncService

LeadSyncTrigger triggers the appropriate methods in LeadSyncHandler when a Lead is inserted/updated/deleted in Org A(Source Org). LeadSyncService is the REST Resource in Org B(Target Org) that handles callouts from Org A in order to sync the operations in Leads on Org B.

--------------------------------------------------------------------------------------------------------


**QUESTION 3:**

Write a custom REST API that returns the count of contacts, opportunities, cases associated with an account. 
AccountID will be passed as input

**Files to check:** AccountSummaryAPI

--------------------------------------------------------------------------------------------------------


**QUESTION 4:**

Task-1 

Sync two salesforce orgs and perform insertion and update on Contact Object using Named Credentials and auth Provider (without using Triggers). 

Task-2 

Set up SSO in org and authenticate the salesforce login page through SSO. 

On login page, Create a SSO login + Plus username/password flow. 

Task-3 

Using SOAP API, check for insert, update and delete for account object in an org. 

Task-4 

Create a Case submission form with google reCAPTCHA and case should be created in salesforce. 

Task-5 

Call Future method from batch class (Using Integration). 

**Files to check:**
