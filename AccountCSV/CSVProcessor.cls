public with sharing class CSVProcessor {

    @AuraEnabled
    public static void processCSV(String contentDocumentId) {
        ContentVersion contentVersion = [SELECT Id, VersionData FROM ContentVersion WHERE ContentDocumentId = :contentDocumentId LIMIT 1];
        Blob csvFile = contentVersion.VersionData;
        String csvData = csvFile.toString();
        List<Account> accountsToInsert = new List<Account>();
        List<String> errorMessages = new List<String>();

        List<String> csvLines = csvData.split('\n');
        Set<String> existingAccountNames = new Set<String>();
        for (String line : csvLines) {
            List<String> fields = line.split(',');

            if (fields.size() < 3 || String.isBlank(fields[0]) || String.isBlank(fields[1])) {
                errorMessages.add('Missing mandatory fields (Name or Phone) on line: ' + line);
                continue; 
            }
            
            String name = fields[0].trim();
            String phone = fields[1].trim();
            String billingCity = fields[2].trim();

            if (existingAccountNames.contains(name)) {
                errorMessages.add('Duplicate entry found in the CSV for Account: ' + name);
                continue; 
            } else {
                existingAccountNames.add(name);
            }
            
            List<Account> existingAccounts = [SELECT Id FROM Account WHERE Name = :name LIMIT 1];
            if (!existingAccounts.isEmpty()) {
                errorMessages.add('Duplicate Account found in Salesforce for: ' + name);
                continue; 
            }

            Account acc = new Account();
            acc.Name = name;
            acc.Phone = phone;
            acc.BillingCity = billingCity;

            accountsToInsert.add(acc);
        }

        if (accountsToInsert.size() > 0) {
            Database.SaveResult[] results = Database.insert(accountsToInsert, false); 

            for (Integer i = 0; i < results.size(); i++) {
                if (!results[i].isSuccess()) {
                    errorMessages.add('Error inserting record for Account: ' + accountsToInsert[i].Name + ' - ' + results[i].getErrors()[0].getMessage());
                }
            }
        }

        if (errorMessages.size() > 0) {
            System.debug('Errors occurred during CSV processing: ' + errorMessages);
        }
    }
}
