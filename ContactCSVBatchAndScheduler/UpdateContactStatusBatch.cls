public class UpdateContactStatusBatch implements Database.Batchable<sObject> {
    private Boolean testMode;

    public UpdateContactStatusBatch() {
        this.testMode = false;
    }

    public UpdateContactStatusBatch(Boolean testMode) {
        this.testMode = testMode;
    }

    public Database.QueryLocator start(Database.BatchableContext bc) {
        String query = 'SELECT Id, Status__c FROM Contact WHERE Status__c != \'Ready for Approval\'';
        
        if (!testMode) {
            query += ' AND CreatedDate = YESTERDAY';
        }
        
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext bc, List<Contact> scope) {
        for (Contact con : scope) {
            con.Status__c = 'Ready for Approval';
        }
        update scope;
    }

    public void finish(Database.BatchableContext bc) {
        System.debug('UpdateContactStatusBatch finished execution.');
    }
}
