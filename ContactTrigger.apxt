trigger ContactTrigger on Contact (after insert, after update, after delete) {
    
    Set<Id> accIds = new Set<Id>();
    
    if(Trigger.isInsert || Trigger.isUpdate || Trigger.isUndelete){
        for(Contact con : Trigger.new){
            if(con.AccountId != null){
            accIds.add(con.AccountId);
            }
        }
    }
    
    if(Trigger.isDelete){
        for(Contact con : Trigger.old){
            if(con.AccountId != null){
                accIds.add(con.AccountId);
            }
        }
    }
    
    if(!accIds.isEmpty()){
        Map<Id, Integer> accContactCounts = new Map<Id, Integer>();
        for(AggregateResult result : [SELECT AccountId, Count(Id) cnt
                                      FROM Contact WHERE AccountId In :accIds
                                      GROUP BY AccountId]) {
                                          
             accContactCounts.put((Id)result.get('AccountId'), (Integer)result.get('cnt'));
       }
        
        List<Account> accountsToUpdate = new List<Account>();
        
        for(Id accId : accIds){
            Account acc = new Account(Id = accId, 
                    	  Total_Contacts_Count__c = accContactCounts.containsKey(accId) ? accContactCounts.get(accId) : 0);
            accountsToUpdate.add(acc);
        }
        
        if(!accountsToUpdate.isEmpty()){
            update accountsToUpdate;
        }
                                     
    }

}
