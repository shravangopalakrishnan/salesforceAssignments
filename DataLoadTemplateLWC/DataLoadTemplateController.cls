public with sharing class DataLoadTemplateController {
    @AuraEnabled
    public static Id saveDataLoadTemplate(String templateName, String dmlType, String fieldLabels, String apiNames) {
        try {
            System.debug('Template Name: ' + templateName);
            System.debug('DML Type: ' + dmlType);
            System.debug('Field Labels: ' + fieldLabels);
            System.debug('API Names: ' + apiNames);  

            if (apiNames == null || apiNames.trim() == '') {
                throw new AuraHandledException('API_Names__c is required but was not provided.');
            }

            Data_Load_Template__c template = new Data_Load_Template__c();
            template.Name = templateName;
            template.DML_Type__c = dmlType;
            template.Field_Labels__c = fieldLabels;
            template.API_Names__c = apiNames; 
            template.Status__c = 'In Progress'; 

            insert template;

            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
            req.setObjectId(template.Id);

            Approval.ProcessResult result = Approval.process(req);

            return template.Id;
        } catch (Exception e) {

            System.debug('Error in saveDataLoadTemplate: ' + e.getMessage());
            throw new AuraHandledException('Error creating template: ' + e.getMessage());
        }
    }
}
