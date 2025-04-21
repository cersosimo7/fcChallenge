trigger QuoteTrigger on Quote (after insert, after update) {
    if (Trigger.isAfter) {
        if(Trigger.isInsert || Trigger.isUpdate){
            QuoteTriggerHandler.updateOpportunityAmount(Trigger.new, Trigger.oldMap);
        }
    }
}
