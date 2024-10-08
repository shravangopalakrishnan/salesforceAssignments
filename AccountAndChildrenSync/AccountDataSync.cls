public class AccountDataSync {
    public void fetchAccountData(String accountId) {
        String namedCredentialURL = 'callout:myNamedCred'; 
        String compositeAPIUrl = namedCredentialURL + '/services/data/v56.0/composite';

        Map<String, Object> requestBody = new Map<String, Object>();
        requestBody.put('allOrNone', true);

        List<Object> requests = new List<Object>();

        requests.add(createRequest('GET', '/services/data/v56.0/sobjects/Account/' + accountId, 'Account'));

        requests.add(createRequest('GET', '/services/data/v56.0/query/?q=' + EncodingUtil.urlEncode('SELECT Id, FirstName, LastName, Email FROM Contact WHERE AccountId = \'' + accountId + '\'', 'UTF-8'), 'Contacts'));

        requests.add(createRequest('GET', '/services/data/v56.0/query/?q=' + EncodingUtil.urlEncode('SELECT Id, Name, StageName, CloseDate FROM Opportunity WHERE AccountId = \'' + accountId + '\'', 'UTF-8'), 'Opportunities'));

        requests.add(createRequest('GET', '/services/data/v56.0/query/?q=' + EncodingUtil.urlEncode('SELECT Id, Status FROM Case WHERE AccountId = \'' + accountId + '\'', 'UTF-8'), 'Cases'));

        requestBody.put('compositeRequest', requests);

        HttpRequest req = new HttpRequest();
        req.setEndpoint(compositeAPIUrl);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setBody(JSON.serialize(requestBody));

        Http http = new Http();
        HttpResponse res = http.send(req);
        System.debug('Response Status: ' + res.getStatus());
        System.debug('Response Body: ' + res.getBody());

        if (res.getStatusCode() == 200) {
            Map<String, Object> responseBody = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            System.debug('Full Response Body: ' + JSON.serializePretty(responseBody));

            List<Object> compositeResponses = (List<Object>) responseBody.get('compositeResponse');
            if (compositeResponses != null && !compositeResponses.isEmpty()) {
                Map<String, Object> accountResponse = (Map<String, Object>) ((Map<String, Object>) compositeResponses[0]).get('body');

                if (accountResponse != null) {
                    System.debug('Account Data: ' + JSON.serializePretty(accountResponse));
                    syncAccountAndChildren(accountResponse, compositeResponses);
                } else {
                    System.debug('Account data is null or empty');
                }
            } else {
                System.debug('No composite responses found in the response');
            }
        } else {
            System.debug('Error: ' + res.getBody());
        }
    }

    private Map<String, Object> createRequest(String method, String url, String referenceId) {
        Map<String, Object> request = new Map<String, Object>();
        request.put('method', method);
        request.put('url', url);
        request.put('referenceId', referenceId);
        return request;
    }

public void syncAccountAndChildren(Map<String, Object> accountResponse, List<Object> compositeResponses) {
    String accountIdOrgB = (String) accountResponse.get('Id');
    String accountName = (String) accountResponse.get('Name');

    List<Account> existingAccounts = [SELECT Id, Name, OrgB_AccountId__c FROM Account WHERE OrgB_AccountId__c = :accountIdOrgB LIMIT 1];

    if (existingAccounts.isEmpty()) {
        existingAccounts = [SELECT Id, Name, OrgB_AccountId__c FROM Account WHERE Name = :accountName LIMIT 1];
    }

    if (!existingAccounts.isEmpty()) {
        Account existingAccount = existingAccounts[0];
        existingAccount.Name = accountName; 
        existingAccount.OrgB_AccountId__c = accountIdOrgB; 

        try {
            update existingAccount; 
        } catch (DmlException e) {
            System.debug('Error updating account: ' + e.getMessage());
        }
        
        updateChildren(existingAccount.Id, compositeResponses);
    } else {
        Account newAccount = new Account();
        newAccount.Name = accountName; 
        newAccount.OrgB_AccountId__c = accountIdOrgB; 

        try {
            insert newAccount;
        } catch (DmlException e) {
            System.debug('Error inserting account: ' + e.getMessage());
            return; 
        }

        createChildren(newAccount.Id, compositeResponses);
    }
}

    
private void updateChildren(Id accountId, List<Object> compositeResponses) {
    if (compositeResponses.size() > 2) {
        Map<String, Object> opportunitiesResponse = (Map<String, Object>) compositeResponses[2];
        if (opportunitiesResponse != null && opportunitiesResponse.containsKey('body')) {
            List<Object> opportunities = (List<Object>) ((Map<String, Object>) opportunitiesResponse.get('body')).get('records');
            if (opportunities != null) {
                List<Opportunity> opportunityUpdates = new List<Opportunity>();
                for (Object obj : opportunities) {
                    Map<String, Object> oppMap = (Map<String, Object>) obj;
                    Opportunity opportunityToUpdate = new Opportunity(Id = (String) oppMap.get('Id'), AccountId = accountId);
                    opportunityToUpdate.Name = (String) oppMap.get('Name');
                    opportunityToUpdate.StageName = (String) oppMap.get('StageName');

                    String closeDateStr = (String) oppMap.get('CloseDate');
                    if (closeDateStr != null) {
                        try {
                            opportunityToUpdate.CloseDate = Date.valueOf(closeDateStr); // Convert string to Date
                        } catch (Exception e) {
                            System.debug('Error parsing CloseDate: ' + e.getMessage());
                        }
                    }
                    
                    opportunityUpdates.add(opportunityToUpdate);
                }
                if (!opportunityUpdates.isEmpty()) {
                    try {
                        update opportunityUpdates; 
                    } catch (DmlException e) {
                        System.debug('Error updating opportunities: ' + e.getMessage());
                    }
                }
            }
        }
    }

    if (compositeResponses.size() > 3) {
        Map<String, Object> casesResponse = (Map<String, Object>) compositeResponses[3];
        if (casesResponse != null && casesResponse.containsKey('body')) {
            List<Object> cases = (List<Object>) ((Map<String, Object>) casesResponse.get('body')).get('records');
            if (cases != null) {
                List<Case> caseUpdates = new List<Case>();
                for (Object obj : cases) {
                    Map<String, Object> caseMap = (Map<String, Object>) obj;
                    Case caseToUpdate = new Case(Id = (String) caseMap.get('Id'));
                    caseToUpdate.Status = (String) caseMap.get('Status');
                    caseUpdates.add(caseToUpdate);
                }
                if (!caseUpdates.isEmpty()) {
                    try {
                        update caseUpdates; 
                    } catch (DmlException e) {
                        System.debug('Error updating cases: ' + e.getMessage());
                    }
                }
            }
        }
    }
    
       if (compositeResponses.size() > 1) {
        Map<String, Object> contactsResponse = (Map<String, Object>) compositeResponses[1];
        if (contactsResponse != null && contactsResponse.containsKey('body')) {
            List<Object> contacts = (List<Object>) ((Map<String, Object>) contactsResponse.get('body')).get('records');
            if (contacts != null) {
                List<Contact> contactUpdates = new List<Contact>();
                for (Object obj : contacts) {
                    Map<String, Object> contactMap = (Map<String, Object>) obj;
                    Contact contactToUpdate = new Contact(Id = (String) contactMap.get('Id'), AccountId = accountId);
                    contactToUpdate.FirstName = (String) contactMap.get('FirstName');
                    contactToUpdate.LastName = (String) contactMap.get('LastName');
                    contactToUpdate.Email = (String) contactMap.get('Email');

                    contactUpdates.add(contactToUpdate);
                }
                if (!contactUpdates.isEmpty()) {
                    try {
                        update contactUpdates; 
                    } catch (DmlException e) {
                        System.debug('Error updating contacts: ' + e.getMessage());
                    }
                }
            }
        }
    }
}

private void createChildren(Id accountId, List<Object> compositeResponses) {
    if (compositeResponses.size() > 2) {
        Map<String, Object> opportunitiesResponse = (Map<String, Object>) compositeResponses[2];
        if (opportunitiesResponse != null && opportunitiesResponse.containsKey('body')) {
            List<Object> opportunities = (List<Object>) ((Map<String, Object>) opportunitiesResponse.get('body')).get('records');
            if (opportunities != null) {
                List<Opportunity> opportunityInserts = new List<Opportunity>();
                for (Object obj : opportunities) {
                    Map<String, Object> oppMap = (Map<String, Object>) obj;
                    Opportunity newOpportunity = new Opportunity();
                    newOpportunity.Name = (String) oppMap.get('Name');
                    newOpportunity.StageName = (String) oppMap.get('StageName');

                    String closeDateStr = (String) oppMap.get('CloseDate');
                    if (closeDateStr != null) {
                        try {
                            newOpportunity.CloseDate = Date.valueOf(closeDateStr); 
                        } catch (Exception e) {
                            System.debug('Error parsing CloseDate: ' + e.getMessage());
                        }
                    }

                    newOpportunity.AccountId = accountId; 
                    opportunityInserts.add(newOpportunity);
                }
                if (!opportunityInserts.isEmpty()) {
                    try {
                        insert opportunityInserts; 
                    } catch (DmlException e) {
                        System.debug('Error inserting opportunities: ' + e.getMessage());
                    }
                }
            }
        }
    }

    if (compositeResponses.size() > 3) {
        Map<String, Object> casesResponse = (Map<String, Object>) compositeResponses[3];
        if (casesResponse != null && casesResponse.containsKey('body')) {
            List<Object> cases = (List<Object>) ((Map<String, Object>) casesResponse.get('body')).get('records');
            if (cases != null) {
                List<Case> caseInserts = new List<Case>();
                for (Object obj : cases) {
                    Map<String, Object> caseMap = (Map<String, Object>) obj;
                    Case newCase = new Case();
                    newCase.Status = (String) caseMap.get('Status');
                    newCase.AccountId = accountId; 
                    caseInserts.add(newCase);
                }
                if (!caseInserts.isEmpty()) {
                    try {
                        insert caseInserts; 
                    } catch (DmlException e) {
                        System.debug('Error inserting cases: ' + e.getMessage());
                    }
                }
            }
        }
    }
    
    if (compositeResponses.size() > 1) {
        Map<String, Object> contactsResponse = (Map<String, Object>) compositeResponses[1];
        if (contactsResponse != null && contactsResponse.containsKey('body')) {
            List<Object> contacts = (List<Object>) ((Map<String, Object>) contactsResponse.get('body')).get('records');
            if (contacts != null) {
                List<Contact> contactInserts = new List<Contact>();
                for (Object obj : contacts) {
                    Map<String, Object> contactMap = (Map<String, Object>) obj;
                    Contact newContact = new Contact();
                    newContact.FirstName = (String) contactMap.get('FirstName');
                    newContact.LastName = (String) contactMap.get('LastName');
                    newContact.Email = (String) contactMap.get('Email');
                    newContact.AccountId = accountId; 
                    contactInserts.add(newContact);
                }
                if (!contactInserts.isEmpty()) {
                    try {
                        insert contactInserts;
                    } catch (DmlException e) {
                        System.debug('Error inserting contacts: ' + e.getMessage());
                    }
                }
            }
        }
    }
}

}
