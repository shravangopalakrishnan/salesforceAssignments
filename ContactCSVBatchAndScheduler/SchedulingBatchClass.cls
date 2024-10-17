ContactCSVScheduler scheduler = new ContactCSVScheduler();

String cronExpression = '0 0 12 * * ? *'; //Scheduled for 12pm everyday

System.schedule('Daily Contact CSV Scheduler', cronExpression, scheduler);
