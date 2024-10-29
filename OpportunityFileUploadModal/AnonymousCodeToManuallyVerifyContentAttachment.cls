Id testOpportunityId = '006bm000004q55UAAQ'; //Opportunity ID
List<Id> fileIds = new List<Id>{'068bm0000058DurAAE'};  //ContentDocument ID of the uploaded file

OpportunityFileSyncService.shareOpportunityAndFile(testOpportunityId, fileIds);
