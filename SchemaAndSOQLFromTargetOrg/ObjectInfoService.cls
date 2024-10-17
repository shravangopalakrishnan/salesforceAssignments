@RestResource(urlMapping='/GetObjectInfo/*')
global with sharing class ObjectInfoService {
    @HttpPost
    global static String getObjectInfo() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        try {
            String objectName = req.requestBody.toString();
            if (String.isEmpty(objectName)) {
                throw new StringException('Object name is empty or null');
            }

            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('callout:myNamedCred/services/apexrest/ObjectMetadata');
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json');
            request.setBody('{"objectName":"' + objectName + '"}');

            HttpResponse response = http.send(request);

            if (response == null || response.getStatusCode() != 200) {
                throw new CalloutException('Error in response: ' + (response != null ? response.getStatus() : 'Null response'));
            }
            
            return response.getBody();
        } catch (StringException se) {
            System.debug('StringException caught: ' + se.getMessage());
            res.statusCode = 400;
            return 'Error: ' + se.getMessage();
        } catch (CalloutException ce) {
            System.debug('CalloutException caught: ' + ce.getMessage());
            res.statusCode = 500;
            return 'Error: ' + ce.getMessage();
        } catch (Exception e) {
            System.debug('General Exception caught: ' + e.getMessage());
            res.statusCode = 500;
            return 'Error: ' + e.getMessage();
        }
    }
}
