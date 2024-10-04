public with sharing class OpportunityController {
    @AuraEnabled(cacheable=true)
    public static List<Opportunity> getOpportunities() {
        return [SELECT Id, Name, StageName FROM Opportunity ORDER BY StageName];
    }

    @AuraEnabled
    public static void updateOpportunityStage(Id opportunityId, String newStage) {
        Opportunity opp = [SELECT Id, StageName FROM Opportunity WHERE Id = :opportunityId LIMIT 1];
        opp.StageName = newStage;
        update opp;
    }
}
