@isTest
public class TaskCreatorTest {
    
    @testSetup()
    static void setup(){
        List<Opportunity> opptys = new List<Opportunity>();
        Date closeDate = Date.today().addDays(50);
        for(Integer i=0; i<10; i++){
            Opportunity o = new Opportunity(Name = 'Opp'+i, 
                                            CloseDate = closeDate, StageName = 'Prospecting', OwnerId = UserInfo.getUserId());
            opptys.add(o);
        }
        insert opptys;  
        
        
    }
    
    @isTest
    static void testExecute(){
      
        Test.startTest();
        TaskCreator task = new TaskCreator();
        task.execute(null);
        Test.stopTest();
        
        List<Task> lt = [SELECT Id, WhatId, OwnerId, Subject, Priority FROM Task];
        for(Task t : lt){
        System.assertEquals(0, lt.size(), 'Tasks exist before job has run');
   
        }

    }
    
    @isTest
    static void testScheduleTaskCreation(){
        Test.startTest();
        TaskCreator.scheduleTaskCreation();
        Test.stopTest();
        
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
                          NextFireTime FROM CronTrigger WHERE CronJobDetail.Name = 'Weekly Opportunity Task Creation'];
        System.assertEquals(' 0 0 9 ? * MON *', ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
    } 
    
}
