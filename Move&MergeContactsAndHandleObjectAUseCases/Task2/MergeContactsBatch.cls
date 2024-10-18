global class MergeContactsBatch implements Database.Batchable<SObject> {

    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([
            SELECT Id, SourceContact__c, DestinationContact__c, Status__c 
            FROM Merge_Contact__c 
            WHERE Status__c = 'New'
        ]);
    }

    global void execute(Database.BatchableContext bc, List<SObject> scope) {
        List<Merge_Contact__c> mergeContactsToUpdate = new List<Merge_Contact__c>();
        Map<Id, Id> contactMergeMap = new Map<Id, Id>(); 

        for (Merge_Contact__c mergeRecord : (List<Merge_Contact__c>) scope) {
            if (mergeRecord.SourceContact__c != null && mergeRecord.DestinationContact__c != null) {
                contactMergeMap.put(mergeRecord.SourceContact__c, mergeRecord.DestinationContact__c);
                mergeRecord.Status__c = 'In Progress'; 
                mergeContactsToUpdate.add(mergeRecord);
                System.debug('Processing Merge Contact record for Source: ' + mergeRecord.SourceContact__c 
                             + ' to Destination: ' + mergeRecord.DestinationContact__c);
            } else {
                System.debug('Merge Contact record missing Source or Destination Contact.');
            }
        }

        cloneNotes(contactMergeMap);
        transferTasks(contactMergeMap);

        for (Merge_Contact__c mergeRecord : mergeContactsToUpdate) {
            mergeRecord.Status__c = 'Completed';
        }

        update mergeContactsToUpdate; 
    }

    private void cloneNotes(Map<Id, Id> contactMergeMap) {
        List<Note> notesToClone = [SELECT Id, Title, Body, ParentId FROM Note WHERE ParentId IN :contactMergeMap.keySet()];
        List<Note> newNotes = new List<Note>();
        
        for (Note note : notesToClone) {
            Id destinationContactId = contactMergeMap.get(note.ParentId);
            System.debug('Cloning Note Id: ' + note.Id + ' from Source Contact to Destination Contact: ' + destinationContactId);
            Note newNote = new Note(
                Title = note.Title,
                Body = note.Body,
                ParentId = destinationContactId
            );
            newNotes.add(newNote);
        }
        
        if (!newNotes.isEmpty()) {
            insert newNotes; 
            delete notesToClone; 
            System.debug('Cloned ' + newNotes.size() + ' Notes to Destination Contacts.');
        } else {
            System.debug('No Notes found for the Source Contacts.');
        }
    }

    private void transferTasks(Map<Id, Id> contactMergeMap) {
        List<Task> tasksToUpdate = new List<Task>();

        for (Task task : [SELECT Id, WhoId FROM Task WHERE WhoId IN :contactMergeMap.keySet()]) {
            Id destinationContactId = contactMergeMap.get(task.WhoId);
            System.debug('Transferring Task Id: ' + task.Id + ' from Source Contact to Destination Contact: ' + destinationContactId);
            task.WhoId = destinationContactId; 
            tasksToUpdate.add(task);
        }

        if (!tasksToUpdate.isEmpty()) {
            update tasksToUpdate; 
            System.debug('Transferred ' + tasksToUpdate.size() + ' Tasks to Destination Contacts.');
        } else {
            System.debug('No Tasks found for the Source Contacts.');
        }
    }

    global void finish(Database.BatchableContext bc) {
        System.debug('MergeContactsBatch processing is completed.');
    }
}
