trigger OpportunityTrigger on Opportunity (before update, before delete) {
 /*
    * Question 5
    * Opportunity Trigger
    * When an opportunity is updated validate that the amount is greater than 5000.
    * Error Message: 'Opportunity amount must be greater than 5000'
    * Trigger should only fire on update.
    */
    /*
    * Question 7
    * Opportunity Trigger
    * When an opportunity is updated set the primary contact on the opportunity to the contact on the same account with the title of 'CEO'.
    * Trigger should only fire on update.
    */
    if(Trigger.isBefore && Trigger.isUpdate){
        for(Opportunity opp : Trigger.new){
            if(opp.Amount < 5000){
                opp.addError('Opportunity amount must be greater than 5000');
            }
        }
        Set<Id> accIds = new Set<Id>();
        for(Opportunity opp : Trigger.new){
            accIds.add(opp.AccountId);
        }
        Map<Id,Id> conIdMap = new Map<Id,Id>();
        for(Contact con : [SELECT Id,AccountId FROM Contact WHERE Title = 'CEO' AND AccountId IN :accIds]){
            conIdMap.put(con.AccountId,con.Id);
        }
        for(Opportunity opp : Trigger.new){
            if(conIdMap.containsKey(opp.AccountId)){
                opp.Primary_Contact__c = conIdMap.get(opp.AccountId);
            }
        }
    }
/*
     * Question 6
	 * Opportunity Trigger
	 * When an opportunity is deleted prevent the deletion of a closed won opportunity if the account industry is 'Banking'.
	 * Error Message: 'Cannot delete closed opportunity for a banking account that is won'
	 * Trigger should only fire on delete.
	 */
    if(Trigger.isBefore && Trigger.isDelete){
        Set<Id> accIds = new Set<Id>();
        for(Opportunity opp : Trigger.old){
            accIds.add(opp.AccountId);
        }
        Map<Id,Account> accMap = new Map<Id,Account>([SELECT Id,Industry FROM Account WHERE Id IN :accIds]);
        for(Opportunity opp : Trigger.old){
            if(opp.StageName == 'Closed Won' && accMap.get(opp.AccountId).Industry == 'Banking'){
                opp.addError('Cannot delete closed opportunity for a banking account that is won');
            }
        }
    }
}