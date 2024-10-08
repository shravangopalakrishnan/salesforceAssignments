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

**Files to check:**

Task-2 

Set up SSO in org and authenticate the salesforce login page through SSO. 

On login page, Create a SSO login + Plus username/password flow. 

**Files to check:** Login Page of Target Org - Users would find an option to login with Identity Provider (Source Org).

Task-3 

Using SOAP API, check for insert, update and delete for account object in an org. 

**Files to check:** Tools such as Postman can be used to make SOAP API callouts to the Account object in the org.

Task-4 

Create a Case submission form with google reCAPTCHA and case should be created in salesforce. 

**Files to check:** Visualforces Page - caseSubmissionForm in the Org

Task-5 

Call Future method from batch class (Using Integration). 

**Files to check:** API-Q5/Task5 Folder: AccountBatch, AccountFutureService, AccountQueueableService, BatchExecutor, AccountBatchTest

Since Future classes cannot be called directly by Batch classes as it is not possible to call an asynchronous class from another asynchronous class, I have used the help of a Queueable class as a liaison between the batch class and future class. The Batch Executor runs the Batch class, which invokes the schedulable class, which in turn calls the future class to create new records.


--------------------------------------------------------------------------------------------------------




**NEW SET OF QUESTIONS**





**QUESTION 1:**

Make a callout to 'https://dog.ceo/api/breeds/image/random' and display the result (including the image) in the UI using LWC

**Files to check:** Folder - DogImageAPI (Check DogAPI tab in Org A)

--------------------------------------------------------------------------------------------------------

**QUESTION 2:**

Make a callout to NEWS API and display only the image and the URL from the response using LWC

**Files to check:** Folder - newsAPI (Check News tab in Org A)

--------------------------------------------------------------------------------------------------------

**QUESTION 3:**

Consider two Salesforce Orgs - Org_A and Org_B. Write an Apex Class to retreive any newly created User record from Org_A and create a copy of it in Org_B. Schedule this class to run every two hours.


**Files to check:** Folder - UserSyncScheduler (Check Apex Jobs from Setup to see the scheduled job that occurs every 2 hours)

--------------------------------------------------------------------------------------------------------

**QUESTION 4:**

Consider two Salesforce Orgs - Org-A and Org_B. In Org_A, create a Lightning Button called "Fetch Contacts". Whenever this button is clicked, write a logic to fetch all the    Contacts from Org_B that are not already in Org_A, i.e., If the Org_B Contact's email address is not present for any of the existing Contacts in Org_A then that Contact should be created in Org_A

**Files to check:** Folder - fetchContactsFromOrgB (Check any contact record - Fetch Contacts button appears as an element on the page and as a Quick Action)

--------------------------------------------------------------------------------------------------------


**QUESTION 5:**

1.) I have to Integrate 2 salesforce orgs through rest api 

2.) In which i have to send the object name through one org and in response i want object schema and soql 

3.) In Another org i find the object name and get its related field with comma seprated make soql and using them and for schema part i have to check its label , type , length and nullability and use all of them in a formate 

string sch = '<' + 'label=' syntax for fetching field label + 'length' =syntax + 'type' = syntax for findinf field type + 'nullability=' syntax for nullability +'>' 

            for sool >>> 

'Select ' + fields with comma seprated + 'from' + Object name 


**Files to check:** 

--------------------------------------------------------------------------------------------------------

**QUESTION 6:**

Salesforce Integration with WhatsApp Using Twilio App

**Files to check:** Folder - TwilioWhatsApp

--------------------------------------------------------------------------------------------------------


**QUESTION 7:**

Account Data is listed in CSV, upload csv to files and develop code/flow to read file and upload bulk data from file to Salesforce org. (Hint: Use Bulk API)

**Files to check:** Folder - TwilioWhatsApp

--------------------------------------------------------------------------------------------------------

**QUESTION 8:**

Integrate two SF orgs, to consume Account and it's childs (Contact, Opportunity and Case data) in one callout. (Hint: Use composite API)

**Files to check:** Folder - AccountAndChildrenSync

The AccountDataSync apex class makes callouts from Org A  with Composite API and fetches data of a particular Account in Org B according to the Account ID passed. Based on the response received, existence of the account in Org A is checked and the children(Contact, Opportunity and Case data) are upserted(updated or created) accordingly.

--------------------------------------------------------------------------------------------------------
