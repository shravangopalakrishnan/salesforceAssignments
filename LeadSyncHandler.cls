public class LeadSyncHandler {
    
    @future(callout=true)
    public static void syncLead(List<String> leadIds, String operation) {
        if (operation == 'Insert') {
            syncLeadInsert(leadIds);
        } else if (operation == 'Update') {
            syncLeadUpdate(leadIds);
        } else if (operation == 'Delete') {
            syncLeadDelete(leadIds);
        } else {
            System.debug('Unsupported operation: ' + operation);
        }
    }

    private static void syncLeadInsert(List<String> leadIds) {
        List<Lead> leads = [SELECT Id, Name, Email, Company FROM Lead WHERE Id IN :leadIds];
        for (Lead lead : leads) {
            HttpRequest req = new HttpRequest();
            String namedCredential = 'myNamedCred';
            String endpoint = 'callout:' + namedCredential + '/services/apexrest/LeadSync';
            
            req.setEndpoint(endpoint);
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/json');
            
            Map<String, Object> leadData = new Map<String, Object>();
            leadData.put('LeadId', lead.Id);
            leadData.put('Name', lead.Name);
            leadData.put('Email', lead.Email);
            leadData.put('Company', lead.Company);
            
            req.setBody(JSON.serialize(leadData));
            sendHttpRequest(req, lead.Id);
        }
    }

    private static void syncLeadUpdate(List<String> leadIds) {
        List<Lead> leads = [SELECT Id, Name, Email, Company FROM Lead WHERE Id IN :leadIds];
        for (Lead lead : leads) {
            HttpRequest req = new HttpRequest();
            String namedCredential = 'myNamedCred';
            String endpoint = 'callout:' + namedCredential + '/services/apexrest/LeadSync';
            
            req.setEndpoint(endpoint);
            req.setMethod('PATCH');
            req.setHeader('Content-Type', 'application/json');
            
            Map<String, Object> leadData = new Map<String, Object>();
            leadData.put('LeadId', lead.Id);
            leadData.put('Name', lead.Name);
            leadData.put('Email', lead.Email);
            leadData.put('Company', lead.Company);
            
            req.setBody(JSON.serialize(leadData));
            sendHttpRequest(req, lead.Id);
        }
    }

    private static void syncLeadDelete(List<String> leadIds) {
        for (String leadId : leadIds) {
            HttpRequest req = new HttpRequest();
            String namedCredential = 'myNamedCred';
            String endpoint = 'callout:' + namedCredential + '/services/apexrest/LeadSync/' + leadId;
            
            req.setEndpoint(endpoint);
            req.setMethod('DELETE');
            req.setHeader('Content-Type', 'application/json');
            
            req.setBody(JSON.serialize(new Map<String, Object>{ 'LeadId' => leadId }));
            sendHttpRequest(req, leadId);
        }
    }

    private static void sendHttpRequest(HttpRequest req, String leadId) {
        Http http = new Http();
        try {
            HttpResponse res = http.send(req);
            System.debug('Lead ID: ' + leadId + ' | Response: ' + res.getBody());
        } catch (Exception e) {
            System.debug('Failed to sync Lead ID: ' + leadId + ' | Error: ' + e.getMessage());
        }
    }
}
