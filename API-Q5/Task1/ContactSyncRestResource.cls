@RestResource(urlMapping='/ContactSync/*')
global with sharing class ContactSyncRestResource {
    
    @HttpPost
    global static String syncContact(String contactFirstName, String contactLastName, String contactEmail, String phoneNumber) {
        try {
            // Store query results in a list to check if any records are found
            List<Contact> contacts = [SELECT Id FROM Contact WHERE Email = :contactEmail LIMIT 1];
            Contact contact;
            
            if (contacts.isEmpty()) {
                // Insert new Contact if not exists
                contact = new Contact(FirstName = contactFirstName, LastName = contactLastName, Email = contactEmail, Phone = phoneNumber);
                insert contact;
                return 'Contact inserted with ID: ' + contact.Id;
            } else {
                // Update existing Contact
                contact = contacts[0];
                contact.FirstName = contactFirstName;
                contact.LastName = contactLastName;
                contact.Phone = phoneNumber;
                update contact;
                return 'Contact updated with ID: ' + contact.Id;
            }
        } catch (Exception e) {
            System.debug('Error syncing contact: ' + e.getMessage());
            return 'Error syncing contact: ' + e.getMessage();  
        }
    }
}
