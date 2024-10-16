public with sharing class RatingController {
    @AuraEnabled
    public static void saveRating(Id customerDetailId, Id planId, Id countryId, Decimal rating, String feedback) {
        try {
            Rating__c newRating = new Rating__c();
            newRating.Customer_Detail__c = customerDetailId;
            newRating.Plan__c = planId;
            newRating.Country__c = countryId;
            newRating.Rating__c = rating;
            newRating.Feedback__c = feedback;
            insert newRating;
        } catch (Exception e) {
            throw new AuraHandledException('Failed to save rating: ' + e.getMessage());
        }
    }
}
