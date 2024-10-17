**APEX ASSIGNMENTS:**


**QUESTION 1:**

Write a class and schedule it. Also, have test class with 100% coverage.

The class should create a new Task (to review the opportunity) for each of the open Opportunity present in the org and assign it to the opportunity owner.
Schedule the class to execute on every Monday at 9:00 AM.

**Files to check:** TaskCreator.cls, TaskCreatorTest.cls

--------------------------------------------------------------------------------------------------------

**QUESTION 2:**

Create a class with name 'Fitness' which has couple of methods to calculate human fitness.
> BMI Calculator Method
create a method with name 'calculateBMI' which accepts necessary paramters and return bmi value.

> Pace Calculator Method
Create a method with name 'calculatePace' which accepts necessary parameters and return km per hour.
> 
**Files to check:** Fitness.cls

--------------------------------------------------------------------------------------------------------


**QUESTION 3:**

Count the total number of contacts associated to an Account whenever a Contact is, 

Inserted, Updated or Deleted related to the Account.
Field Total_Contacts_Count__c should get updated with the latest count.

Pre-requisite: Create a Number field with API name “Total_Contacts_Count__c” on Account.


**Files to check:** ContactTrigger.trigger

--------------------------------------------------------------------------------------------------------


**QUESTION 4:**

**Task-1**

Write a batch class which will move all the records of A, B & C objects from Contact A to Contact B . 

**Files to check:**

**Task-2**

Create custom Object- Merge Contact. 

Create a picklist field- Status [New(default), Completed, Error]. 

To merge contact records from one field (Contact A) to another field (Contact B) using batch apex method. 

**Files to check:**

**Task-3** 

Create fields on Object A :- 

Request Status (Picklist) :-  New, Approved, Duplicate, Not Matched, Rejected, Completed, Match Found. 

Is Auto Approved (Checkbox) 

Email  

Roles (Multi-Select Picklist) :- Admin, Developer, Manager, CEO, Executive. 

When a record is created for the first time request status is new.  Also Check roles and email existence, if already exist then request status is Duplicate. 

Check if contact exists for the email id and if not then create a contact record respective to the email id and populate the id to the A object contact field. 

If the Request Status is Completed for the record created , then for another new record (with same email) the Request Status should be Approved and Checkbox true.

**Files to check:** 

**Task-4** 

Create fields on Object A :- 

Request Type (Picklist) :- Mentee, Mentor  

Language (Picklist) :- Hindi, English, Telugu, Marathi. 

Experience (Picklist) :- 1-2 yr, 2-3 yr, 4-5 yr, 6-10 yr 

Action (picklist) :- Find Mentor, Remove Mentor  

Match Found (checkbox) 

Create a record with request type Mentor, request Status Approved 

Create a Mentee record with only one role.  On Updating action to Find Mentor a mentor must be assigned to a mentee whose Experience of Mentor >= Experience of Mentee and Roles and language are same. 

On being assigned a mentor to a mentee update the status of both the records to Match Found and Match found checkbox true. 

**Files to check:** 

**Task-5** 

Create a Test Class for task-3 & 4. 

**Files to check:** 

--------------------------------------------------------------------------------------------------------


**QUESTION 5:**

Requirement: We need to add records to standard Account object using email service. Send an email with attached csv file and create records in Account object by data in csv file. 

Negative scenario:  
 
Remove one of the mandatory fields from csv file, the insertion of that record will fail, display the failure record in debug log.  

Hint:Use of Email services feature of SF. I have used bulk api to insert data to account object, another way is to create record of Account object and use insert dml operation. 

**Files to check:** Folder - CsvToAccountCreationByEmailService

The Apex class reads the csv attachment from the received email. It then reads the csv, processes it and then creates Accounts based on the csv data. 
Any row which does not have the required fields are added to the failed records list and is shown in the Debug Logs(Check Image).

--------------------------------------------------------------------------------------------------------

**QUESTION 6:**

Create custom field on Contact for ""Sequence Number"". Create trigger to manage sequence of Contacts on an Account. Handle all the events and cases.


Scenarios of insertion :-

1.When contact is inserted with null or blank sequence number , it should get last sequence number + 1
Example :- if account A1 has 5 related contacts and we are inserting one more than sequence number should be 6.
2. When contact is inserted with negative sequence number , It should get sequence number as 1 and other contact sequence number should be increased by 1.
  Example :- If account has 3 contacts (c1 with sequence number 1 , c2 with 2 and c3 with 3) and we are inserting new contact , let say c0(with sequence number -1)
		It should be inserted with sequence number 1 and the sequence number for other contacts should be increased by 1.
		After insertion [c0-1,c1-2,c2-3,c3-4].
3.If the contact is inserted with sequence number in between the sequence numbers of contacts, then the seq number of the contacts having sequence number = and > of inserted contact's seq number
	should be increased by 1.
Example :- If Account has 3 contacts with seq number as [c1-1,c2-2,c3-3] then and we are inserting contact c0 with sequence number as 2,
	Then seq number of c2 and c3 should be increased by 1.
	After insertion [c1-1,c0-2,c2-3,c3-4].
For more practice - create more use case , try it for updation(make sure to prevent recursive call of trigger)  , deletion , reparenting(change associated account of contact) but for assignment only insertion is in scope 
Test class coverage should be above 95%
- Create test sheet for all the test cases
- Create test methods for all the test cases.

**Files to check:** Folder - ContactSequenceNumber. (In Salesforce UI, Click on each Contact to edit/view the Sequence Number.

--------------------------------------------------------------------------------------------------------

**QUESTION 7:**

Create status field on Contact (Approved, Ready for Approval)
Write a batch to update status to "Ready for Approval" for those records which were created yesterday
Write a scheduler to email the CSV of those records to a user

CSV Should include Following fields
1) Date
2) DateTime
3) Boolean
4) Text area with comma

Test class coverage should be above 95%

**Files to check:** Folder - ContactCSVBatchAndScheduler


The Batch Class updates the status of contacts that were created yesterday to "Ready For Approval".
The Scheduler Class constructs the CSV with the expected fields and in the desirable format and sends the email to the specified Email ID.
The Anonymous code to schedule the class and the CSV that is emailed is attached in the folder.

--------------------------------------------------------------------------------------------------------


