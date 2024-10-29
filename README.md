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

**Files to check:** Folder API-Q5/Task1: ContactSyncService, ContactSyncScheduler, ContactSyncRestResource, ContactSyncServiceTest

ContactSyncService class handles the syncing of contacts between Source Org and target Org. When a new contact is created or an existing contact is updated in Org A, the contacts in Org B will be synced accordingly.
Sync happens with the help of the Scheduler class (ContactSyncScheduler) that schedules the sync for every one hour.


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


**Files to check:**  Folder - SchemaAndSOQLFromTargetOrg

When the REST API Callout is made from the ObjectInfoService class from Source Org, the ObjectMetadataService class from Target Org returns the JSON in a Map format, such that SOQL and Schema of the Object are Keys and the response are their respective values.
The code to execute from the Anonymous window and the Response is stored in the folder for reference.

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

**QUESTION 9:**

Create UI to upload file on a opportunity record and share the opportunity and file with external app. Both source and destination orgs are salesforce orgs. 
Step 1: Create 2 Orgs. 
Step 2: Create a Button on Opportunity Record. The Button should open a Modal. 
Step 3: The Modal should have 2 buttons: Upload Files, Send. The Send Button is Disabled by Default. 
Step 4: Whenever upload is clicked, the file will get saved in the related Opportunity record. 
Step 5: After file upload is successful, the Send button will be enabled. 
Step 6: If the Send Button is clicked, the uploaded file will be sent to 2nd Org. If Opportunity record absent in the 2nd Org, create the related Opportunity record and then save the file in 2nd Org. 

**Files to check:** Folder OpportunityFileUploadModal (Click on any Opportunity record in Org A and you can find the Upload File button on the NavBar)

Clicking on Upload File button in any opportunity will open a modal that has two buttons - "Upload" and "Send", out which Send is disabled by default.
Upload lets the user browse and select files for upload. Upon successful upload of the file, Send button gets enabled.
Clicking the Send button syncs the opportunity snd the uploaded files with Org B. (Checks for existing opportunity in Org B and updates if it exists. If the opportunity does not exist, Creates a new opportunitty with the details same as the one in Org A and uploads the file).
