trigger ContactSequenceTrigger on Contact (before insert) {
    if (Trigger.isBefore && Trigger.isInsert) {
        ContactSequenceHandler.assignSequenceNumbers(Trigger.new);
    }
}
