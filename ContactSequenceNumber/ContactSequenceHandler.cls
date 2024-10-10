public class ContactSequenceHandler {
    
    public static void assignSequenceNumbers(List<Contact> newContacts) {
        Map<Id, List<Contact>> accountContactMap = new Map<Id, List<Contact>>();
        
        for (Contact con : newContacts) {
            if (con.AccountId != null) {
                if (!accountContactMap.containsKey(con.AccountId)) {
                    accountContactMap.put(con.AccountId, new List<Contact>());
                }
                accountContactMap.get(con.AccountId).add(con);
            }
        }
        
        Map<Id, Contact> contactsToUpdateMap = new Map<Id, Contact>();

        for (Id accountId : accountContactMap.keySet()) {
            List<Contact> existingContacts = [SELECT Id, Sequence_Number__c 
                                              FROM Contact 
                                              WHERE AccountId = :accountId 
                                              ORDER BY Sequence_Number__c ASC];
            
            Decimal maxSequenceNumber = existingContacts.isEmpty() ? 0 : existingContacts[existingContacts.size() - 1].Sequence_Number__c;

            for (Contact newContact : accountContactMap.get(accountId)) {
                Decimal targetSequence = newContact.Sequence_Number__c;
                
                if (targetSequence == null) {
                    newContact.Sequence_Number__c = maxSequenceNumber + 1;
                    maxSequenceNumber++;
                } else if (targetSequence <= 0) {
                    newContact.Sequence_Number__c = 1;

                    for (Contact existingContact : existingContacts) {
                        existingContact.Sequence_Number__c += 1;
                        contactsToUpdateMap.put(existingContact.Id, existingContact);
                    }
                } else {
                    for (Contact existingContact : existingContacts) {
                        if (existingContact.Sequence_Number__c >= targetSequence) {
                            existingContact.Sequence_Number__c += 1;
                            contactsToUpdateMap.put(existingContact.Id, existingContact);
                        }
                    }
                    newContact.Sequence_Number__c = targetSequence;
                }
            }
        }

        if (!contactsToUpdateMap.isEmpty()) {
            update contactsToUpdateMap.values();
        }
    }
}
