public with sharing class ContactSyncController {

    @AuraEnabled
    public static List<Contact> fetchContacts() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:myNamedCred/services/apexrest/contacts');  // Named Credential URL
        request.setMethod('GET');
        
        HttpResponse response = http.send(request);
        
        if (response.getStatusCode() == 302) {
            String redirectUrl = response.getHeader('Location'); 
            request.setEndpoint(redirectUrl); 
            response = http.send(request); 
        }
        
        List<Contact> newContacts = new List<Contact>(); 
        if (response.getStatusCode() == 200) {
            List<Contact> orgBContacts = (List<Contact>) JSON.deserialize(response.getBody(), List<Contact>.class);
            newContacts = syncContacts(orgBContacts); 
        } else {
            throw new CalloutException('Failed to fetch contacts from Org B: ' + response.getStatusCode());
        }
        
        return newContacts; 
    }
    
    private static List<Contact> syncContacts(List<Contact> orgBContacts) {
        Set<String> existingEmails = new Set<String>();
        for (Contact c : [SELECT Email FROM Contact WHERE Email != NULL]) {
            existingEmails.add(c.Email);
        }
        
        List<Contact> newContacts = new List<Contact>();
        for (Contact orgBContact : orgBContacts) {
            if (!existingEmails.contains(orgBContact.Email)) {
                Contact newContact = new Contact(
                    FirstName = orgBContact.FirstName,
                    LastName = orgBContact.LastName,
                    Email = orgBContact.Email,
                    Phone = orgBContact.Phone
                );
                newContacts.add(newContact);
            }
        }
        
        if (!newContacts.isEmpty()) {
            insert newContacts;
        }
        
        return newContacts; 
    }
}
