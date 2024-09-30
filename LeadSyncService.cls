@RestResource(urlMapping='/LeadSync/*')
global with sharing class LeadSyncService {

    @HttpPost
    global static String insertLead(String LeadId, String Name, String Email, String Company) {
        try {
            if (String.isBlank(Name) || String.isBlank(Company) || String.isBlank(Email)) {
                return 'Error: Name, Company, and Email are required.';
            }

            Lead newLead = new Lead(LastName=Name, Company=Company, Email=Email, OrgA_LeadId__c=LeadId);
            insert newLead;

            return 'Lead inserted successfully: ' + newLead.Id;
        } catch (Exception e) {
            return 'Error in Insert: ' + e.getMessage();
        }
    }

    @HttpPatch
    global static String updateLead(String LeadId, String Name, String Email, String Company) {
        try {
            if (String.isBlank(LeadId)) {
                return 'Error: LeadId is required for update.';
            }

            Lead leadToUpdate = [SELECT Id, LastName, Email, Company FROM Lead WHERE OrgA_LeadId__c = :LeadId LIMIT 1];
            if (leadToUpdate != null) {
                if (!String.isBlank(Name)) leadToUpdate.LastName = Name;
                if (!String.isBlank(Email)) leadToUpdate.Email = Email;
                if (!String.isBlank(Company)) leadToUpdate.Company = Company;

                update leadToUpdate;
                return 'Lead updated successfully: ' + leadToUpdate.Id;
            } else {
                return 'Error: Lead not found.';
            }
        } catch (QueryException qe) {
            return 'Error: Lead not found.';
        } catch (Exception e) {
            return 'Error in Update: ' + e.getMessage();
        }
    }

    @HttpDelete
    global static void deleteLead() {
        RestRequest req = RestContext.request;
        String leadId = req.requestURI.substring(req.requestURI.lastIndexOf('/') + 1);

        try {
            if (String.isBlank(leadId)) {
                RestContext.response.statusCode = 400;
                RestContext.response.responseBody = Blob.valueOf('Error: LeadId is required for deletion.');
                return;
            }

            Lead leadToDelete = [SELECT Id FROM Lead WHERE OrgA_LeadId__c = :leadId LIMIT 1];
            delete leadToDelete;

            RestContext.response.statusCode = 200;
            RestContext.response.responseBody = Blob.valueOf('Lead deleted successfully.');
        } catch (QueryException qe) {
            RestContext.response.statusCode = 404;
            RestContext.response.responseBody = Blob.valueOf('Error: Lead not found.');
        } catch (Exception e) {
            RestContext.response.statusCode = 500;
            RestContext.response.responseBody = Blob.valueOf('Error in Delete: ' + e.getMessage());
        }
    }
}
