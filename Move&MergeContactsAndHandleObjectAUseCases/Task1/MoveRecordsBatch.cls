global class MoveRecordsBatch implements Database.Batchable<SObject> {
    
    private Id contactAId = '003bm000004O9z7AAC';
    private Id contactBId = '003bm000004O9z8AAC';

    global Database.QueryLocator start(Database.BatchableContext bc) {
        String query = 'SELECT Id, Contact__c FROM Object_A__c WHERE Contact__c = :contactAId';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext bc, List<SObject> scope) {
        List<Object_A__c> recordsToUpdate = new List<Object_A__c>();
        
        for (Object_A__c obj : (List<Object_A__c>) scope) {
            obj.Contact__c = contactBId; 
            recordsToUpdate.add(obj);
        }

        update recordsToUpdate; 
    }

    global void finish(Database.BatchableContext bc) {
    }
}
