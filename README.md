**LWC ASSIGNMENTS:**


**QUESTION 1:**

Create UI to upload file on a opportunity record and share the opportunity and file with external app. Both source and destination orgs are salesforce orgs. 
Step 1: Create 2 Orgs. 
Step 2: Create a Button on Opportunity Record. The Button should open a Modal. 
Step 3: The Modal should have 2 buttons: Upload Files, Send. The Send Button is Disabled by Default. 
Step 4: Whenever upload is clicked, the file will get saved in the related Opportunity record. 
Step 5: After file upload is successful, the Send button will be enabled. 
Step 6: If the Send Button is clicked, the uploaded file will be sent to 2nd Org. If Opportunity record absent in the 2nd Org, create the related Opportunity record and then save the file in 2nd Org. 

**Files to check:** Folder LWC-Q1

--------------------------------------------------------------------------------------------------------

**QUESTION 2:**

Create a Callout for http://restapi.adequateshop.com/api/Tourist?page=2 and generate the Response of Tourist Data and also generate a separate Tourist Email Response.  

1. How to make it Asynch for this Class.
2. How to schedule this class
3. Make a scheduled class for daily 8'oclock


**Files to check:** Folder LWC-Q2

--------------------------------------------------------------------------------------------------------

**QUESTION 3:**

1) I have to create a basic template which we have use for importing the records as Import Wizard i have to make custom 

2.) For that first i have make a drop down in which i have used only 4 Objects and while selecting one of from them there are 2 tables below there in which one table is for available  fields options and seconde is for selected  fields from first table. 

3.) Now there is an input block for Saving the Template Name there  

4.) There is another drop down in which i have to save the DML type like - Insert , Update and Delete 

5.) Now i make an An object name as Data Load Template in which i have 5 fields like  

Name is filled with Template name  

Dml for save the dml type 

Fieldable for save the selected field labels 

Api name for save the api name of selected fields 

status for check the status while go for approval like(In progress , Approved , Rejected) 

there is check box field which is checked when user select the USER object 

6.) There is a create template button when user click on it navigate the record view of newly created data load template and also go into the approval 

7.) There is a simple paragarph for Required field above the Template name as well as the Eror messag is shown there  

validations>>>  

1.)I make some validations over there like select option list should not be empty there should be atleast on field while create record 

2.) while Insert operation is selected the required field should be in selected filed option 

3.) When Update option is selected on drop down opens in which you have to select one unique option and the unique option lable and api nam eshould be saved with selected option label and api name  

4.) If more than 1 required field an u have select only 1 field than show error while insertion option selected 

5.) After approval an email should be send to approver 

6.) After Approval the status is changed as Approved or rejected 

7.) The record in get in approval directly when user click the button


**Files to check:** 

--------------------------------------------------------------------------------------------------------

**QUESTION 4:**

Create 3 screens using screen flow to display component. 

First screen should take input to create an Account(take any five fields). 

Validation of the inputs needs to be done . 

On click of a next button on this screen request to APEX should be made to create account  and also take us to the  next screen. 

Second screen should take input to create new contact for the account created in the previous screen  

And also the related account name should also be displayed as one of the fields on the contact screen. 

On click of a Next button ,request to create a new contact should be sent to APEX and take us to the third screen. 

On third screen display the newly created account and its related contact in separate sections I.e above section should show the account details and below that the related contacts should be shown . 

Write Test class for the apex part only . 


**Files to check:** 

--------------------------------------------------------------------------------------------------------

**QUESTION 5:**

Task1: Create custom objects for Country, Plans, Customer Details, Rating. 

and using LWC and flows, create search bar for auto-Complete search for country object 

where you find countries after typing for single keyword and result will be shown in lightning table. we have to achieve with connecting orgs. 

Task2: Screen (2) after selecting country we have shown the packages related to that country in lightning table form but with lightning cards. There will be lookup field for country and packages. we have to show packages according to country preference. 

Task3: Screen (3) There will be a form for customer details like Name, Phone Number, Country For booking purpose. 

Task4: Screen (4) There will be screen for customer rating for user experience 

Task5: Implementing Progress Indicator using LWC and flows. 

Task6: Fetch plans and details should be shown in customer details form using lookup or master detail field with LWC. 

Task7: Improve rating form for customer with some details as per requirement. 

Task8: Create Aura and Lightning Component and pass the information using LMS (Lightning Message Service) 


**Files to check:** 

--------------------------------------------------------------------------------------------------------

**QUESTION 6:**

Its a 2 screen project, At first Screen it will show the combobox that will display all the values from the picklist Industry of Account, based on the selection of industry by end user. It will render the DataTable below that combobox that will list Account Name, Phone Number, Email of the accounts that have industry that user has selected. Once the Account from the table is selected then it will open another screen that will list all the child opportunity(Opportunity name, amount, stage, closed date) of that Account. with a back button in top, as you click on back button they will redirect to first screen.

**Files to check:** Folder - IndustryInfo2Screens (Check Industry Info App tab in Salesforce UI)

First Screen - Displays a combobox with Industry options. Upon selection of an option, Accounts in that Industry will be displayed below along with the Phone number and Email columns. Along with these, the Accounts would contain a button "View Opportunities" which would take the user to the Second Screen

Second Screen - Upon clicking "View Opportunities" button on the First Screen, this Second Screen displays the Opportunity details of the selected Account, along with its Amount, Stage and Close Date details. Also contains the "Back" button on top to facilitate Navigation back to the First Screen.



--------------------------------------------------------------------------------------------------------

**QUESTION 7:**

Create a Generic component  that accepts two arrays
1) button name array
2) button type array (The array can contain two types of values a) button b) url)
 and whatever value we received render the those corresponding buttons on the UI
 For URL use navigation mixin

**Files to check:** Folder - GenerLWCButtonRenderer (Check Button Renderer Tab in Salesforce UI. To edit button names/types, Edit Button Renderer in Lightning App Builder)

--------------------------------------------------------------------------------------------------------

**QUESTION 8:**

Create a Kanban view for opportunity in LWC

1) Listed all the opportunities of org in that view
2) Use opportunity stages as a headers and it should be dynamically ex. if the stages count is 7 then create 7 headers
3) All the opportunities listed below under the stage column
4) It should be drag and drop capability if I move one opportunity from column one stage to another stage then update the stage value accordingly

**Files to check:** Folder LWC-Q3

--------------------------------------------------------------------------------------------------------
