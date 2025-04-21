@isTest
private class QuoteTriggerHandlerTest {

    @testSetup
    static void setupData() {
        Profile profile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        User manager = new User(
            Alias = 'mgr',
            FirstName = 'manager',
            LastName ='manager',
            Email = 'manager@firstchair.com',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = profile.Id,
            TimeZoneSidKey = 'America/New_York',
            Username = 'manageruser@firstchair.com'
        );

        insert manager;

        Id stdPbId = Test.getStandardPricebookId();

        Product2 prod = new Product2(Name = 'Test Product', IsActive = true);

        insert prod;

        PricebookEntry pbe = new PricebookEntry(
            Product2Id = prod.Id,
            Pricebook2Id = stdPbId,
            UnitPrice = 1000,
            IsActive = true
        );
        
        insert pbe;

        Opportunity opp = new Opportunity(
            Name = 'Test Opportunity',
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(15)
        );

        insert opp;

        Quote quote = new Quote(
            Name = 'Test Quote',
            OpportunityId = opp.Id,
            Pricebook2Id = stdPbId,
            Status = 'Needs Review',
            ExpirationDate = Date.today().addDays(7),
            Manager__c = manager.Id
        );

        insert quote;

        QuoteLineItem quoteLineItem = new QuoteLineItem(
            QuoteId = quote.Id,
            Quantity = 2,
            UnitPrice = 1000,
            PricebookEntryId = pbe.Id
        );

        insert quoteLineItem;
    }

    @isTest
    static void testApprovedQuoteUpdatesOpportunity() {

        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        User manager = [SELECT Id FROM User LIMIT 1];
        Quote quote = [SELECT Id FROM Quote LIMIT 1];
        

        Test.startTest();
            quote.Status = QuoteStatusConstants.APPROVED;

            update quote;
        Test.stopTest();
        
        Opportunity updatedOpp = [SELECT Amount FROM Opportunity WHERE Id = :opp.Id];

        System.assertEquals(2000, updatedOpp.Amount, 'Opportunity amount should reflect approved quote total');
    }
}
