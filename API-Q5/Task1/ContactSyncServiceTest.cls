@IsTest
private class ContactSyncServiceTest {
    
    @IsTest
    static void testContactSyncInsert() {
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatusCode(200);
        mockResponse.setBody('Contact inserted with ID: 0035g00000XXXXX');
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(mockResponse));
        
        Contact testContact = new Contact(FirstName = 'Test', LastName = 'User', Email = 'testuser@example.com', Phone = '1234567890');
        insert testContact;
        
        Test.startTest();
        ContactSyncService.syncContacts(); 
        Test.stopTest();
        
        System.assertEquals(200, mockResponse.getStatusCode());
    }
    
    @IsTest
    static void testContactSyncUpdate() {
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatusCode(200);
        mockResponse.setBody('Contact updated with ID: 0035g00000XXXXX');
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(mockResponse));
        
        Contact existingContact = new Contact(FirstName = 'Test', LastName = 'User', Email = 'testuser@example.com', Phone = '1234567890');
        insert existingContact;
        
        existingContact.Phone = '0987654321';
        update existingContact;
        
        Test.startTest();
        ContactSyncService.syncContacts();  
        Test.stopTest();
        
        System.assertEquals(200, mockResponse.getStatusCode());
    }
    
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        private HttpResponse response;
        
        public MockHttpResponseGenerator(HttpResponse response) {
            this.response = response;
        }
        
        public HttpResponse respond(HttpRequest req) {
            return response;
        }
    }
}
