@RestResource(urlMapping='/contacts')
global with sharing class ContactService {

    @HttpGet
    global static List<Contact> doGet() {
        try {
            List<Contact> contacts = [SELECT FirstName, LastName, Email, Phone FROM Contact WHERE Email != NULL];

            if (contacts.isEmpty()) {
                throw new CustomException('No contacts found');
            }

            return contacts;
        } catch (Exception e) {
            throw new CalloutException('Error fetching contacts: ' + e.getMessage());
        }
    }

    global class CustomException extends Exception {}
}
