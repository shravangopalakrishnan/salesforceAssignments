@isTest
private class AccountBatchTest {
    
    @isTest
    static void testAccountBatch() {
        List<Account> testAccounts = new List<Account>();
        for (Integer i = 0; i < 5; i++) {
            testAccounts.add(new Account(Name = 'Test Account ' + i));
        }
        insert testAccounts; 

        AccountBatch accountBatch = new AccountBatch();
        
        Database.executeBatch(accountBatch, 10); 

        List<Account> newAccounts = [SELECT Id, Name FROM Account WHERE Name LIKE 'Test Account% - Copy'];
        
        System.assertEquals(5, newAccounts.size(), 'Expected 5 new accounts to be created.');
        
        for (Account acc : newAccounts) {
            System.assert(acc.Name.startsWith('Test Account') && acc.Name.endsWith('- Copy'), 
                           'New account name should be in the format "Test Account - Copy".');
        }
    }
}
