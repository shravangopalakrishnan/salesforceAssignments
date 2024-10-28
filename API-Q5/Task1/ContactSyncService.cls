public with sharing class ContactSyncService {
    private static final String ENDPOINT = 'callout:myNamedCred/services/apexrest/ContactSync/';
    
    public static void syncContacts() {
        List<Contact> contactsToSync = [SELECT Id, FirstName, LastName, Email, Phone FROM Contact];
        for (Contact con : contactsToSync) {
            HttpRequest req = new HttpRequest();
            req.setEndpoint(ENDPOINT);
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/json');
            
            Map<String, String> payload = new Map<String, String>{
                'contactFirstName' => con.FirstName,
                'contactLastName' => con.LastName,
                'contactEmail' => con.Email,
                'phoneNumber' => con.Phone
            };
            req.setBody(JSON.serialize(payload));
            
            Http http = new Http();
            try {
                HttpResponse res = http.send(req);
                if (res.getStatusCode() == 200) {
                    System.debug('Sync successful for Contact ID: ' + con.Id);
                } else {
                    System.debug('Sync failed for Contact ID: ' + con.Id + ', Status: ' + res.getStatus());
                }
            } catch (Exception ex) {
                System.debug('Error occurred during sync: ' + ex.getMessage());
            }
        }
    }
}
