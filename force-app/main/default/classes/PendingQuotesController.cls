public with sharing class PendingQuotesController {
    
    @AuraEnabled(cacheable=true)
    public static List<Quote> getPendingApprovalQuotes() {
        List<Quote> quoteList = [SELECT Id, Name, Status, TotalPrice, Discount, Opportunity.Name
                                FROM Quote
                                WHERE Status =: QuoteStatusConstants.PENDING_APPROVAL
                                    AND CreatedById =: UserInfo.getUserId()
                                ];
        return quoteList;
    }

    @AuraEnabled
    public static void approveQuote(Id quoteId) {
        Quote quote = new Quote(Id = quoteId, Status = QuoteStatusConstants.APPROVED);

        update quote;
    }
}