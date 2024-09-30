trigger LeadSyncTrigger on Lead (after insert, after update, after delete) {

    List<String> leadIds = new List<String>();

    if (Trigger.isInsert) {
        for (Lead lead : Trigger.new) {
            leadIds.add(lead.Id);
        }
        LeadSyncHandler.syncLead(leadIds, 'Insert');
    }

    if (Trigger.isUpdate) {
        for (Lead lead : Trigger.new) {
            leadIds.add(lead.Id);
        }
        LeadSyncHandler.syncLead(leadIds, 'Update');
    }

    if (Trigger.isDelete) {
        for (Lead lead : Trigger.old) {
            leadIds.add(lead.Id);
        }
        LeadSyncHandler.syncLead(leadIds, 'Delete');
    }
}
