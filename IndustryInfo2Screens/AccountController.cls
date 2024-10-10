public with sharing class AccountController {

    @AuraEnabled(cacheable=true)
    public static List<String> getIndustries() {
        Set<String> industrySet = new Set<String>();
        for (Account acc : [SELECT Industry FROM Account WHERE Industry != NULL]) {
            industrySet.add(acc.Industry);
        }
        return new List<String>(industrySet);
    }

    @AuraEnabled(cacheable=true)
    public static List<Account> getAccountsByIndustry(String industry) {
        return [SELECT Id, Name, Phone FROM Account WHERE Industry = :industry];
    }

    @AuraEnabled(cacheable=true)
    public static List<Opportunity> getOpportunitiesByAccountId(Id accountId) {
        return [SELECT Name, Amount, StageName, CloseDate FROM Opportunity WHERE AccountId = :accountId];
    }
}
