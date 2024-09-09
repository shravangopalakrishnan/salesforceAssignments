trigger ContactTrigger on Contact (after insert, after delete) {

    if(Trigger.isInsert){
        for(Contact c : Trigger.New){
            ContactCalloutService.sendContactId(c.Id, 'create');
        }
    }


    if(Trigger.isDelete){
        for(Contact c : Trigger.Old){
            ContactCalloutService.sendContactId(c.Id, 'delete');
        }
    }
}
