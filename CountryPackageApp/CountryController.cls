public with sharing class CountryController {
    @AuraEnabled(cacheable=true)
    public static List<Country__c> searchCountries(String searchTerm) {
        String formattedSearchTerm = '%' + searchTerm + '%';
        return [
            SELECT Id, Name, Country_Code__c
            FROM Country__c
            WHERE Name LIKE :formattedSearchTerm
            LIMIT 10
        ];
    }
}
