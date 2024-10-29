public class OpportunityFileSyncService {

    public class CustomException extends Exception {}

    @AuraEnabled
    public static void shareOpportunityAndFile(Id opportunityId, List<Id> fileIds) {
        Opportunity oppA = [SELECT Name, StageName, CloseDate, Amount, OrgB_OppId__c 
                            FROM Opportunity 
                            WHERE Id = :opportunityId LIMIT 1];

        try {
            String closeDateStr = Datetime.newInstance(oppA.CloseDate, Time.newInstance(0, 0, 0, 0)).formatGmt('yyyy-MM-dd');
            
            Map<String, Object> requestParams = new Map<String, Object>{
                'opportunityName' => oppA.Name,
                'details' => new Map<String, Object>{
                    'name' => oppA.Name,
                    'stage' => oppA.StageName,
                    'closeDate' => Date.valueOf(closeDateStr),
                    'amount' => oppA.Amount
                },
                'files' => new List<Map<String, Object>>()  
            };

            List<Map<String, Object>> filesList = (List<Map<String, Object>>) requestParams.get('files');
            for (Id fileId : fileIds) {
                List<ContentVersion> cvList = [SELECT Title, VersionData, PathOnClient 
                                                FROM ContentVersion 
                                                WHERE Id = :fileId LIMIT 1];

                if (!cvList.isEmpty()) {
                    ContentVersion cv = cvList[0];
                    filesList.add(new Map<String, Object>{
                        'Title' => cv.Title,
                        'VersionData' => EncodingUtil.base64Encode(cv.VersionData),
                        'PathOnClient' => cv.PathOnClient
                    });
                } else {
                    System.debug('ContentVersion with Id ' + fileId + ' not found or not accessible.');
                }
            }

            HttpRequest req = new HttpRequest();
            req.setEndpoint('callout:myNamedCred/services/apexrest/OpportunityService');
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/json');
            req.setBody(JSON.serialize(requestParams));

            Http http = new Http();
            HttpResponse res = http.send(req);

            if (res.getStatusCode() == 200) {
                Map<String, Object> responseBody = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                String orgBOppId = (String) responseBody.get('opportunityId');
                
                oppA.OrgB_OppId__c = orgBOppId;
                update oppA;
                
                System.debug('Sync successful. Org B Opportunity ID: ' + orgBOppId);
                
            } else {
                throw new CustomException('Failed to sync Opportunity and files. Status: ' + res.getStatusCode() + 
                                          ', Response: ' + res.getBody());
            }

        } catch (Exception e) {
            throw new CustomException('Error syncing opportunity and files: ' + e.getMessage());
        }
    }
}
