global class CsvAccountEmailHandler implements Messaging.InboundEmailHandler {
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
        List<String> failedRecords = new List<String>();

        if (email.textAttachments != null && !email.textAttachments.isEmpty()) {
            for (Messaging.InboundEmail.TextAttachment attachment : email.textAttachments) {
                    processCsvAttachment(attachment.body, failedRecords);
            }
        }

        result.success = true;
        return result;
    }

    private void processCsvAttachment(String csvContent, List<String> failedRecords) {
        List<Account> accountsToInsert = new List<Account>();
        
        String[] lines = csvContent.split('\n');

        for (Integer i = 1; i < lines.size(); i++) {
            String line = lines[i].trim(); 
            if (String.isEmpty(line)) {
                continue; 
            }
            String[] columns = line.split(',');

            if (columns.size() < 2 || String.isEmpty(columns[0])) {
                failedRecords.add(line);
                continue; 
            }

            Account account = new Account();
            account.Name = columns[0]; 
            if (columns.size() > 1) {
                account.Phone = columns[1]; 
            }

            accountsToInsert.add(account);
        }

        if (!accountsToInsert.isEmpty()) {
            try {
                insert accountsToInsert;
            } catch (DmlException e) {
                System.debug('Error inserting accounts: ' + e.getMessage());
                for (Account acc : accountsToInsert) {
                    if (acc.Id == null) {
                        failedRecords.add(acc.Name); 
                    }
                }
            }
        }

        if (!failedRecords.isEmpty()) {
            System.debug('Failed to insert records: ' + String.join(failedRecords, ', '));
        }
    }
}
