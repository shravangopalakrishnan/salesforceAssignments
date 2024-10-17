global class ContactCSVScheduler implements Schedulable {
    private Boolean testMode = false;

    global ContactCSVScheduler() {}

    global ContactCSVScheduler(Boolean testMode) {
        this.testMode = testMode;
    }

    global void execute(SchedulableContext sc) {
        String query = 'SELECT Id, Name, CreatedDate, Is_Active__c, Status__c, Description FROM Contact WHERE Status__c = \'Ready for Approval\'';
        if (!testMode) {
            query += ' AND CreatedDate = YESTERDAY';
        }
        
        List<Contact> contacts = Database.query(query);

        if (contacts.isEmpty()) {
            System.debug('No contacts found with status "Ready for Approval" created yesterday.');
            return;
        }

        String csvData = 'Id,Name,Date,DateTime,BooleanField,Status,TextAreaWithComma\n';
        for (Contact c : contacts) {
            String createdDateStr = c.CreatedDate != null ? c.CreatedDate.date().format() : '';
            String createdDateTimeStr = c.CreatedDate != null ? c.CreatedDate.format('MM/dd/yyyy') + ' | ' + c.CreatedDate.format('HH:mm a') : '';
            String isActiveStr = c.Is_Active__c != null ? String.valueOf(c.Is_Active__c) : '';
            String statusStr = c.Status__c != null ? c.Status__c : '';
            String descriptionStr = c.Description != null ? '"' + c.Description.replace('"', '""') + '"' : '';

            csvData += c.Id + ',' +
                       c.Name + ',' +
                       createdDateStr + ',' +
                       createdDateTimeStr + ',' +
                       isActiveStr + ',' +
                       statusStr + ',' +
                       descriptionStr + '\n';
        }

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setSubject('Contacts Ready for Approval');
        mail.setToAddresses(new List<String>{'shravgop@gmail.com'});
        mail.setPlainTextBody('Please find the attached CSV of contacts ready for approval.');

        Blob csvBlob = Blob.valueOf(csvData);
        Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
        attachment.setFileName('Contact_Report.csv');
        attachment.setBody(csvBlob);
        attachment.setContentType('text/csv');
        mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attachment });

        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

        System.debug('Email sent with attachment Contact_Report.csv.');
    }
}
