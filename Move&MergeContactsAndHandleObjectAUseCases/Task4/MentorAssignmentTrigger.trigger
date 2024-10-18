trigger MentorAssignmentTrigger on Object_A__c (before update) {
    Map<String, Integer> experienceMap = new Map<String, Integer>{
        '1-2 yr' => 2,
        '2-3 yr' => 3,
        '4-5 yr' => 5,
        '6-10 yr' => 10
    };

    List<Object_A__c> potentialMentors = [SELECT Id, Roles__c, Language__c, Experience__c, Request_Type__c, Match_Found__c, Request_Status__c
                                          FROM Object_A__c 
                                          WHERE Request_Type__c = 'Mentor' AND Match_Found__c = false];

    List<Object_A__c> mentorsToUpdate = new List<Object_A__c>();

    for (Object_A__c mentee : Trigger.new) {
        if (mentee.Action__c == 'Find Mentor' && mentee.Request_Type__c == 'Mentee' && !mentee.Match_Found__c) {
            Integer menteeExperience = experienceMap.get(mentee.Experience__c);

            for (Object_A__c mentor : potentialMentors) {
                Integer mentorExperience = experienceMap.get(mentor.Experience__c);

                if (mentor.Language__c == mentee.Language__c &&
                    mentor.Roles__c.contains(mentee.Roles__c) &&
                    mentorExperience >= menteeExperience) {
                    
                    mentee.Match_Found__c = true;
                    mentee.Request_Status__c = 'Match Found';
                    
                    mentor.Match_Found__c = true;
                    mentor.Request_Status__c = 'Match Found';
                    mentorsToUpdate.add(mentor);

                    break;
                }
            }
        }
    }

    if (!mentorsToUpdate.isEmpty()) {
        update mentorsToUpdate;
    }
}
