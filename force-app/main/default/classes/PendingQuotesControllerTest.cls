@isTest
public with sharing class PendingQuotesControllerTest {
    
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

        Quote quote = new Quote(
            Name = 'Test Quote',
            Status = QuoteStatusConstants.PENDING_APPROVAL,
            ExpirationDate = Date.today().addDays(7),
            Manager__c = manager.Id
        );

        insert quote;

    }

    @isTest
    static void testGetPendingApprovalQuotes() {
        Quote quote;

        Test.startTest();
            quote = PendingQuotesController.getPendingApprovalQuotes()[0];
        Test.stopTest();

        Assert.isTrue(quote != null, 'Quote should have value.');
    }

    @isTest
    static void testApproveQuote() {
        Quote quote = [SELECT Id FROM Quote];

        Test.startTest();
            PendingQuotesController.approveQuote(quote.Id);
        Test.stopTest();

        Quote quoteAfterUpdate = [SELECT Id, Status FROM Quote];

        Assert.areEqual(QuoteStatusConstants.APPROVED, quoteAfterUpdate.status, 'Quest status should be Approved');
    }
}