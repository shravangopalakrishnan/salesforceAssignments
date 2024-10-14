public class AccountContactController {

    @AuraEnabled
    public static Id createAccount(String accountName, String phone, String website, String billingStreet, String billingCity) {
        System.debug('--- createAccount called ---');
        System.debug('Account Name: ' + accountName);
        System.debug('Phone: ' + phone);
        System.debug('Website: ' + website);
        System.debug('Billing Street: ' + billingStreet);
        System.debug('Billing City: ' + billingCity);

        try {
            Account acc = new Account(
                Name = accountName,
                Phone = phone,
                Website = website,
                BillingStreet = billingStreet,
                BillingCity = billingCity
            );
            insert acc;
            System.debug('Account Created with ID: ' + acc.Id);
            return acc.Id;
        } catch (DmlException e) {
            System.debug('DML Exception: ' + e.getMessage());
            throw new AuraHandledException('Account creation failed. Reason: ' + e.getDmlMessage(0));
        }
    }
     @AuraEnabled
    public static Id createContact(String firstName, String lastName, String email, String phone, Id accountId) {
        try {
            Contact con = new Contact(
                FirstName = firstName,
                LastName = lastName,
                Email = email,
                Phone = phone,
                AccountId = accountId
            );
            insert con;
            return con.Id;
        } catch (DmlException e) {
            if (e.getMessage().contains('DUPLICATES_DETECTED')) {
                throw new AuraHandledException('Duplicate detected: A Contact with similar information already exists.');
            } else {
                throw new AuraHandledException('Failed to create Contact. Error: ' + e.getMessage());
            }
        }
    }
}
