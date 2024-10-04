global class AccountBatch implements Database.Batchable<SObject> {

    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator('SELECT Id, Name FROM Account WHERE Name LIKE \'Test%\'');
    }

    global void execute(Database.BatchableContext BC, List<SObject> scope) {
        Set<String> accountNames = new Set<String>();

        for (SObject sObj : scope) {
            Account existingAccount = (Account) sObj;
            accountNames.add(existingAccount.Name + ' - Copy');
        }

        if (!accountNames.isEmpty()) {
            System.enqueueJob(new AccountQueueableService(accountNames));
        }
    }

    global void finish(Database.BatchableContext BC) {
        System.debug('Batch process completed.');
    }
}
