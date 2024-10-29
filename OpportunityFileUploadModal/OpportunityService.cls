@RestResource(urlMapping='/OpportunityService')
global with sharing class OpportunityService {

    @HttpPost
    global static void handlePost() {
        try {
            String requestBody = RestContext.request.requestBody.toString();
            System.debug('Received payload in Org B: ' + requestBody);

            Map<String, Object> requestParams = (Map<String, Object>) JSON.deserializeUntyped(requestBody);
            String opportunityName = (String) requestParams.get('opportunityName');
            Map<String, Object> details = (Map<String, Object>) requestParams.get('details');
            String stage = (String) details.get('stage');

            Date closeDate;
            if (details.containsKey('closeDate')) {
                closeDate = Date.valueOf((String) details.get('closeDate'));
            }

            Decimal amount = (Decimal) details.get('amount');
            List<Map<String, Object>> files = new List<Map<String, Object>>();

            if (requestParams.containsKey('files') && requestParams.get('files') instanceof List<Object>) {
                List<Object> rawFiles = (List<Object>) requestParams.get('files');
                for (Object rawFile : rawFiles) {
                    if (rawFile instanceof Map<String, Object>) {
                        files.add((Map<String, Object>) rawFile);
                    }
                }
            }

            List<Opportunity> opps = [SELECT Id FROM Opportunity WHERE Name = :opportunityName LIMIT 1];
            Opportunity oppB;
            if (!opps.isEmpty()) {
                oppB = opps[0];
                System.debug('Existing Opportunity found with ID: ' + oppB.Id);
            } else {
                oppB = new Opportunity(
                    Name = opportunityName,
                    StageName = stage,
                    CloseDate = closeDate,
                    Amount = amount
                );
                insert oppB;
                System.debug('Created new Opportunity in Org B with ID: ' + oppB.Id);
            }

            for (Map<String, Object> fileData : files) {
                if (fileData != null && fileData.containsKey('Title') && fileData.containsKey('VersionData')) {
                    String fileName = (String) fileData.get('Title');
                    Blob fileBody = EncodingUtil.base64Decode((String) fileData.get('VersionData'));
                    System.debug('Attempting to create Attachment with title: ' + fileName);

                    Attachment attachment = new Attachment(
                        ParentId = oppB.Id,
                        Name = fileName,
                        Body = fileBody,
                        ContentType = 'application/octet-stream'
                    );
                    try {
                        insert attachment;
                        System.debug('Attachment created with ID: ' + attachment.Id + ' and linked to Opportunity with ID: ' + oppB.Id);
                    } catch (DmlException dmle) {
                        System.debug('Failed to insert Attachment: ' + dmle.getMessage());
                    }
                } else {
                    System.debug('Skipping file entry due to missing Title or VersionData fields.');
                }
            }

            RestResponse res = RestContext.response;
            res.addHeader('Content-Type', 'application/json');
            res.responseBody = Blob.valueOf('{"opportunityId": "' + oppB.Id + '"}');
            res.statusCode = 200;

        } catch (DmlException dmlEx) {
            System.debug('DML Error: ' + dmlEx.getMessage());
            RestContext.response.statusCode = 500;
            RestContext.response.responseBody = Blob.valueOf('{"errorCode": "DML_ERROR", "message": "' + dmlEx.getMessage() + '"}');
        } catch (Exception ex) {
            System.debug('Unexpected Error: ' + ex.getMessage());
            RestContext.response.statusCode = 500;
            RestContext.response.responseBody = Blob.valueOf('{"errorCode": "APEX_ERROR", "message": "' + ex.getMessage() + '"}');
        }
    }
}
