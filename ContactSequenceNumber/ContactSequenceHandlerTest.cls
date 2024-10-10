@isTest
public class ContactSequenceHandlerTest {
    
    @testSetup
    static void setup() {
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        Contact c1 = new Contact(LastName = 'Contact 1', AccountId = testAccount.Id, Sequence_Number__c = 1);
        Contact c2 = new Contact(LastName = 'Contact 2', AccountId = testAccount.Id, Sequence_Number__c = 2);
        Contact c3 = new Contact(LastName = 'Contact 3', AccountId = testAccount.Id, Sequence_Number__c = 3);
        insert new List<Contact>{c1, c2, c3};
    }
    
    @isTest
    static void testInsertWithNullSequenceNumber() {
        Account testAccount = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1];
        
        Contact newContact = new Contact(LastName = 'New Contact', AccountId = testAccount.Id, Sequence_Number__c = null);
        insert newContact;

        Contact insertedContact = [SELECT Sequence_Number__c FROM Contact WHERE LastName = 'New Contact' LIMIT 1];
        System.assertEquals(4, insertedContact.Sequence_Number__c, 'Expected sequence number of 4 for the new contact.');
    }

    @isTest
    static void testInsertWithNegativeSequenceNumber() {
        Account testAccount = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1];
        
        Contact newContact = new Contact(LastName = 'Negative Sequence Contact', AccountId = testAccount.Id, Sequence_Number__c = -1);
        insert newContact;

        List<Contact> contacts = [SELECT LastName, Sequence_Number__c FROM Contact WHERE AccountId = :testAccount.Id ORDER BY Sequence_Number__c];
        
        System.assertEquals('Negative Sequence Contact', contacts[0].LastName, 'First contact should be the one inserted with negative sequence.');
        System.assertEquals(1, contacts[0].Sequence_Number__c);
        System.assertEquals('Contact 1', contacts[1].LastName);
        System.assertEquals(2, contacts[1].Sequence_Number__c);
        System.assertEquals('Contact 2', contacts[2].LastName);
        System.assertEquals(3, contacts[2].Sequence_Number__c);
        System.assertEquals('Contact 3', contacts[3].LastName);
        System.assertEquals(4, contacts[3].Sequence_Number__c);
    }

    @isTest
    static void testInsertWithInBetweenSequenceNumber() {
        Account testAccount = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1];
        
        Contact newContact = new Contact(LastName = 'In-Between Sequence Contact', AccountId = testAccount.Id, Sequence_Number__c = 2);
        insert newContact;

        List<Contact> contacts = [SELECT LastName, Sequence_Number__c FROM Contact WHERE AccountId = :testAccount.Id ORDER BY Sequence_Number__c];
        
        System.assertEquals('Contact 1', contacts[0].LastName);
        System.assertEquals(1, contacts[0].Sequence_Number__c);
        System.assertEquals('In-Between Sequence Contact', contacts[1].LastName, 'Inserted contact should have shifted others.');
        System.assertEquals(2, contacts[1].Sequence_Number__c);
        System.assertEquals('Contact 2', contacts[2].LastName);
        System.assertEquals(3, contacts[2].Sequence_Number__c);
        System.assertEquals('Contact 3', contacts[3].LastName);
        System.assertEquals(4, contacts[3].Sequence_Number__c);
    }

    @isTest
    static void testInsertMultipleContactsWithNullSequenceNumbers() {
        Account testAccount = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1];
        
        Contact newContact1 = new Contact(LastName = 'Bulk Contact 1', AccountId = testAccount.Id);
        Contact newContact2 = new Contact(LastName = 'Bulk Contact 2', AccountId = testAccount.Id);
        insert new List<Contact> {newContact1, newContact2};

        List<Contact> contacts = [SELECT LastName, Sequence_Number__c FROM Contact WHERE AccountId = :testAccount.Id ORDER BY Sequence_Number__c];
        
        System.assertEquals(4, contacts[3].Sequence_Number__c);
        System.assertEquals('Bulk Contact 1', contacts[3].LastName);
        System.assertEquals(5, contacts[4].Sequence_Number__c);
        System.assertEquals('Bulk Contact 2', contacts[4].LastName);
    }
}
