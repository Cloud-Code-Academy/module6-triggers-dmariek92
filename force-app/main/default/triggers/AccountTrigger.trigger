trigger AccountTrigger on Account (before insert, after insert) {
/*
    * Question 1
    * Account Trigger
    * When an account is inserted change the account type to 'Prospect' if there is no value in the type field.
    * Trigger should only fire on insert.
    */
     /*
    * Question 2
    * Account Trigger
    * When an account is inserted copy the shipping address to the billing address.
    * BONUS: Check if the shipping fields are empty before copying.
    * Trigger should only fire on insert.
    */
    /*
    * Question 3
    * Account Trigger
	* When an account is inserted set the rating to 'Hot' if the Phone, Website, and Fax ALL have a value.
    * Trigger should only fire on insert.
    */
    if(Trigger.isBefore && Trigger.isInsert){
        for(Account acc : Trigger.new){
            if(acc.Type == null){
                acc.Type = 'Prospect';
            }
            if(acc.ShippingStreet != null){
                acc.BillingStreet = acc.ShippingStreet;
                acc.BillingCity = acc.ShippingCity;
                acc.BillingState = acc.ShippingState;
                acc.BillingPostalCode = acc.ShippingPostalCode;
                acc.BillingCountry = acc.ShippingCountry;
            }
            if(acc.Phone != null && acc.Website != null && acc.Fax != null){
                acc.Rating = 'Hot';
            }
        }
    }
         /*
    * Question 4
    * Account Trigger
    * When an account is inserted create a contact related to the account with the following default values:
    * LastName = 'DefaultContact'
    * Email = 'default@email.com'
    * Trigger should only fire on insert.
    */
    if(Trigger.isAfter && Trigger.isInsert){
        List<Contact> conList = new List<Contact>();
        for(Account acc : Trigger.new){
            Contact con = new Contact(LastName = 'DefaultContact', Email = 'default@email.com', AccountId = acc.Id);
            conList.add(con);
        }
        insert conList;
    }
}