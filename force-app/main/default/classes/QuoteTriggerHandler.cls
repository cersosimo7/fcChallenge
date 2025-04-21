public class QuoteTriggerHandler {
    public static void updateOpportunityAmount(List<Quote> newQuotes, Map<Id, Quote> oldMap) {
        Map<Id, Quote> approvedQuotes = new Map<Id, Quote>();
        List<Opportunity> oppsToUpdate = new List<Opportunity>();

        for (Quote quoteObj : newQuotes) {
            String oldStatus = oldMap != null && oldMap.containsKey(quoteObj.Id) ? oldMap.get(quoteObj.Id).Status : null;
            if (quoteObj.Status == QuoteStatusConstants.APPROVED && oldStatus != QuoteStatusConstants.APPROVED && quoteObj.OpportunityId != null) {
                approvedQuotes.put(quoteObj.OpportunityId, quoteObj);
            }
        }

        if (!approvedQuotes.isEmpty()){
            Map<Id, Quote> latestApprovedQuoteMap = new Map<Id, Quote>();

            List<Quote> latestQuotes = [SELECT Id, OpportunityId, TotalPrice, Status, CreatedDate
                                        FROM Quote
                                        WHERE OpportunityId IN :approvedQuotes.keySet()
                                        AND Status = :QuoteStatusConstants.APPROVED
                                        ORDER BY LastModifiedDate DESC
                                    ];
    
            Set<Id> seenOpps = new Set<Id>();

            for (Quote quoteObj : latestQuotes) {
                if (!seenOpps.contains(quoteObj.OpportunityId)) {
                    latestApprovedQuoteMap.put(quoteObj.OpportunityId, quoteObj);
                    seenOpps.add(quoteObj.OpportunityId);
                }
            }

            for (Id oppId : latestApprovedQuoteMap.keySet()) {
                Quote latest = latestApprovedQuoteMap.get(oppId);
                oppsToUpdate.add(new Opportunity(Id = oppId, Amount = latest.TotalPrice));
            }
        }

        if (!oppsToUpdate.isEmpty()) {
            update oppsToUpdate;
        }
    }
}
