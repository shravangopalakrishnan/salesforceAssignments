@RestResource(urlMapping='/AccountSummary/*')
global with sharing class AccountSummaryAPI {

    @HttpGet
    global static void getAccountSummary() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String accountId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);

        if (String.isBlank(accountId) || !accountId.startsWith('001')) {
            res.statusCode = 400;
            res.responseBody = Blob.valueOf('Invalid or missing Account ID.');
            return;
        }

        try {
            Account acc = [SELECT Id FROM Account WHERE Id = :accountId LIMIT 1];

            Integer contactCount = [SELECT COUNT() FROM Contact WHERE AccountId = :accountId];
            Integer opportunityCount = [SELECT COUNT() FROM Opportunity WHERE AccountId = :accountId];
            Integer caseCount = [SELECT COUNT() FROM Case WHERE AccountId = :accountId];

            AccountSummaryResponse response = new AccountSummaryResponse();
            response.accountId = acc.Id;
            response.contactCount = contactCount;
            response.opportunityCount = opportunityCount;
            response.caseCount = caseCount;

            res.statusCode = 200;
            res.responseBody = Blob.valueOf(JSON.serialize(response));

        } catch (QueryException e) {
            res.statusCode = 404;
            res.responseBody = Blob.valueOf('Account not found.');
        } catch (Exception e) {
            res.statusCode = 500;
            res.responseBody = Blob.valueOf('An unexpected error occurred: ' + e.getMessage());
        }
    }

    global class AccountSummaryResponse {
        public String accountId;
        public Integer contactCount;
        public Integer opportunityCount;
        public Integer caseCount;
    }
}
