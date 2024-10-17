@RestResource(urlMapping='/ObjectMetadata')
global with sharing class ObjectMetadataService {
    @HttpPost
    global static String getObjectMetadata() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        Map<String, Object> requestBody = (Map<String, Object>) JSON.deserializeUntyped(req.requestBody.toString());
        String objectName = (String) requestBody.get('objectName');
        
        Map<String, Schema.SObjectField> fieldsMap = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();
        
        List<String> fieldNames = new List<String>();
        List<String> schemaDetailsList = new List<String>();
        
        for (String fieldName : fieldsMap.keySet()) {
            Schema.DescribeFieldResult fieldDescribe = fieldsMap.get(fieldName).getDescribe();
            
            String fieldDetail = '<label=' + fieldDescribe.getLabel() +
                                 ', length=' + fieldDescribe.getLength() +
                                 ', type=' + fieldDescribe.getType() +
                                 ', nullability=' + fieldDescribe.isNillable() + '>';
            
            schemaDetailsList.add(fieldDetail);
            fieldNames.add(fieldName);
        }

        String schemaDetails = String.join(schemaDetailsList, ', ');
        
        String soql = 'SELECT ' + String.join(fieldNames, ', ') + ' FROM ' + objectName;
        
        Map<String, String> responseMap = new Map<String, String>{
            'soql' => soql,
            'schema' => schemaDetails
        };
        
        res.statusCode = 200;
        return JSON.serialize(responseMap);
    }
}
