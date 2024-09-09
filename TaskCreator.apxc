global class TaskCreator implements Schedulable {

    global void execute (SchedulableContext ctx){
        List<Opportunity> opptys = [SELECT Id, Name, OwnerId, CloseDate 
                                    FROM Opportunity WHERE IsClosed = False];
        
        List<Task> tasks = new List<Task>();
        for(Opportunity opp : opptys){
            Task task = new Task();
            task.OwnerId = opp.OwnerId;
        }
            insert tasks;
    }
        
        
      public static void scheduleTaskCreation(){
        TaskCreator tc = new TaskCreator();
        String sch = '0 0 9 ? * MON *';
        String jobId = System.schedule('Weekly Opportunity Task Creation', sch, tc);
    }
}
