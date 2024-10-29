public with sharing class OpportunityFileController {
    @AuraEnabled
    public static void uploadAndLinkFiles(Id opportunityId, List<Map<String, Object>> fileWrapperList) {
        if (opportunityId == null || fileWrapperList.isEmpty()) {
            throw new IllegalArgumentException('Opportunity ID and Files cannot be null or empty.');
        }
        
        for (Map<String, Object> fileWrapper : fileWrapperList) {
            Id contentDocumentId = (Id) fileWrapper.get('contentDocumentId');

            ContentDocumentLink cdl = new ContentDocumentLink();
            cdl.LinkedEntityId = opportunityId; 
            cdl.ContentDocumentId = contentDocumentId;
            cdl.ShareType = 'I'; 
            cdl.Visibility = 'AllUsers'; 
            insert cdl;
        }
    }
}
