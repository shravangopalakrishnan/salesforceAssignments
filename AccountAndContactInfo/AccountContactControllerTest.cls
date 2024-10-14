@isTest
public class AccountContactControllerTest {

    @isTest
    static void testCreateAccount() {
        Test.startTest();
        Id accountId = AccountContactController.createAccount('Test Account', '1234567890', 'http://test.com', '123 Test St', 'Test City');
        Account acc = [SELECT Id, Name FROM Account WHERE Id = :accountId];
        System.assertEquals('Test Account', acc.Name);
        Test.stopTest();
    }

    @isTest
    static void testCreateContact() {
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        Test.startTest();
        Id contactId = AccountContactController.createContact('Test', 'User', 'test@example.com', '0987654321', testAccount.Id);
        Contact con = [SELECT Id, FirstName, LastName, AccountId FROM Contact WHERE Id = :contactId];
        System.assertEquals('User', con.LastName);
        System.assertEquals(testAccount.Id, con.AccountId);
        Test.stopTest();
    }
}
