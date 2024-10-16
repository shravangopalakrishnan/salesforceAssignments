public with sharing class CustomerDetailController {
    @AuraEnabled
    public static Id saveCustomerDetail(String name, String phone, Id countryId) {
        try {
            // Convert the phone input from String to Decimal
            Decimal phoneNumber = Decimal.valueOf(phone);

            // Create a new Customer Detail record
            Customer_Detail__c customerDetail = new Customer_Detail__c();
            customerDetail.Name = name;
            customerDetail.Phone__c = phoneNumber;
            customerDetail.Country__c = countryId;
            customerDetail.Booking_Date__c = Date.today();

            // Insert the record and return the Id
            insert customerDetail;
            return customerDetail.Id;
        } catch (Exception e) {
            throw new AuraHandledException('Error saving customer detail: ' + e.getMessage());
        }
    }
}
