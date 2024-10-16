public with sharing class PlanController {
    @AuraEnabled(cacheable=true)
    public static List<Plan__c> getPlansByCountry(Id countryId) {
        return [
            SELECT Id, Name, Description__c, Price__c
            FROM Plan__c
            WHERE Country__c = :countryId
        ];
    }
}
