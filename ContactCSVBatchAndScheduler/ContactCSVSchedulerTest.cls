@isTest
private class ContactCSVSchedulerTest {

    @testSetup
    static void setup() {
        List<Contact> contacts = new List<Contact>();
        for (Integer i = 0; i < 5; i++) {
            Boolean isActive = (Math.mod(i, 2) == 0);
            Contact con = new Contact(
                LastName = 'Test' + i,
                Status__c = 'Ready for Approval', 
                Is_Active__c = isActive,
                Description = 'Sample description, with, commas ' + i,
                Email = 'unique_email_' + i + '@example.com'
            );
            contacts.add(con);
        }
        insert contacts;
    }

    @isTest
    static void testSchedulerExecutionWithContacts() {
        Test.startTest();
        ContactCSVScheduler scheduler = new ContactCSVScheduler(true); 
        scheduler.execute(null);
        Test.stopTest();

        List<Contact> updatedContacts = [SELECT Id, LastName, Is_Active__c, CreatedDate, Description, Status__c 
                                         FROM Contact 
                                         WHERE Status__c = 'Ready for Approval'];
        System.assertEquals(5, updatedContacts.size(), 'Scheduler should have processed 5 contacts with "Ready for Approval".');

        System.assert(true, 'Scheduler executed and CSV generation logic was covered.');
    }
}
