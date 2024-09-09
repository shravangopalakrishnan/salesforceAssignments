@isTest
public class ContactCalloutServiceTest {
    
    @isTest
    static void testContactCalloutCreateSuccess() {
        
        Test.startTest();

        Contact testContact = new Contact(FirstName = 'Test', LastName = 'User');
        insert testContact;

        Test.stopTest();

        Contact insertedContact = [SELECT Id FROM Contact WHERE Id = :testContact.Id LIMIT 1];
        System.assertNotEquals(null, insertedContact);

    }

    @isTest
    static void testContactCalloutDeleteSuccess(){
        
        Test.startTest();

        Contact testContact = new Contact(FirstName = 'Test', LastName = 'User');
        insert testContact;

        delete testContact;

        Test.stopTest();

        Integer contactCount = [SELECT Count() FROM Contact WHERE Id = :testContact.Id];
        System.assertEquals(0, contactCount);
    }

    @isTest
    static void testContactCalloutCreateFailure() {
        Test.setMock(HttpCalloutMock.class, new MockHttpErrorResponse());
        
        Test.startTest();
        
        Contact testContact = new Contact(FirstName = 'Test', LastName = 'User');
        insert testContact;
        
        Test.stopTest();
        
        Contact insertedContact = [SELECT Id FROM Contact WHERE Id = :testContact.Id LIMIT 1];
        System.assertNotEquals(null, insertedContact);
    }
    
    @isTest
    static void testContactCalloutDeleteFailure() {

        Test.setMock(HttpCalloutMock.class, new MockHttpErrorResponse());
        
        Test.startTest();
        
        Contact testContact = new Contact(FirstName = 'Test', LastName = 'User');
        insert testContact;
        delete testContact;
        
        Test.stopTest();
        
        Integer contactCount = [SELECT COUNT() FROM Contact WHERE Id = :testContact.Id];
        System.assertEquals(0, contactCount);
    }
}
