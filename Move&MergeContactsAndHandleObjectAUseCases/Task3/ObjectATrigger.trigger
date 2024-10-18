trigger ObjectATrigger on Object_A__c (before insert, before update) {
    Set<String> emailSet = new Set<String>();
    Map<String, Contact> emailToContactMap = new Map<String, Contact>();
    Map<String, Object_A__c> emailToPreviousObjectMap = new Map<String, Object_A__c>();

    for (Object_A__c record : Trigger.new) {
        if (record.Email__c != null) {
            emailSet.add(record.Email__c);
        }
    }

    if (!emailSet.isEmpty()) {
        for (Contact contact : [SELECT Id, Email FROM Contact WHERE Email IN :emailSet]) {
            emailToContactMap.put(contact.Email, contact);
        }

        for (Object_A__c obj : [SELECT Id, Email__c, Request_Status__c FROM Object_A__c WHERE Email__c IN :emailSet]) {
            emailToPreviousObjectMap.put(obj.Email__c, obj);
        }
    }

    List<Contact> contactsToCreate = new List<Contact>();

    for (Object_A__c record : Trigger.new) {
        if (emailToPreviousObjectMap.containsKey(record.Email__c)) {
            Object_A__c previousRecord = emailToPreviousObjectMap.get(record.Email__c);
            if (previousRecord.Request_Status__c == 'Completed') {
                record.Request_Status__c = 'Approved';
                record.Is_Auto_Approved__c = true;
                System.debug('Auto-approved record for email: ' + record.Email__c);
                continue; 
            }
        }

        if (emailToContactMap.containsKey(record.Email__c) || emailToPreviousObjectMap.containsKey(record.Email__c)) {
            record.Request_Status__c = 'Duplicate';
            System.debug('Duplicate detected for email: ' + record.Email__c);
        } else {
            if (record.Email__c != null && !emailToContactMap.containsKey(record.Email__c)) {
                Contact newContact = new Contact(
                    LastName = 'AutoCreated', 
                    Email = record.Email__c
                );
                contactsToCreate.add(newContact);
                emailToContactMap.put(record.Email__c, newContact);
            }

            if (record.Request_Status__c == null) {
                record.Request_Status__c = 'New';
            }
        }
    }

    if (!contactsToCreate.isEmpty()) {
        insert contactsToCreate;
    }

    for (Contact contact : contactsToCreate) {
        for (Object_A__c record : Trigger.new) {
            if (record.Email__c == contact.Email) {
                record.Contact__c = contact.Id;  
                System.debug('Linked new Contact to Object_A__c record for email: ' + record.Email__c);
            }
        }
    }

    for (Object_A__c record : Trigger.new) {
        if (record.Email__c != null && emailToContactMap.containsKey(record.Email__c) && record.Contact__c == null) {
            record.Contact__c = emailToContactMap.get(record.Email__c).Id; 
        }
    }
}
