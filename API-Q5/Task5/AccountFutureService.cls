public class AccountFutureService {
    
    @future
    public static void createAccounts(Set<String> accountNames) {
        List<Account> accountsToInsert = new List<Account>();
        
        for (String name : accountNames) {
            accountsToInsert.add(new Account(Name = name));
        }
        
        try {
            insert accountsToInsert;
        } catch (DmlException e) {
            System.debug('Error occurred while creating accounts: ' + e.getMessage());
        }
    }
}
