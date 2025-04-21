import { LightningElement, wire } from 'lwc';
import getPendingApprovalQuotes from '@salesforce/apex/PendingQuotesController.getPendingApprovalQuotes';
import approveQuote from '@salesforce/apex/PendingQuotesController.approveQuote';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


export default class PendingQuotesLWC extends LightningElement {
    quotes = [];

    columns = [
        { label: 'Quote Name', fieldName: 'Name', type: 'text' },
        { label: 'Opportunity Name', fieldName: 'Opportunity.Name', type: 'text' },
        { label: 'Discount', fieldName: 'Discount', type: 'percent' },
        { label: 'Total Price', fieldName: 'TotalPrice', type: 'currency' },
        {
            type: 'button',
            label: 'Actions',
            cellAttributes: { alignment: 'center' },
            typeAttributes: {
                label: 'Approve',
                name: 'approve',
                title: 'Click to approve',
                variant: 'brand',
                iconName: 'utility:check'
            }
        }
    ];

    @wire(getPendingApprovalQuotes)
    wiredQuotes({ data, error }) {
        if (data) {
            this.quotes = data;
        }
    }


    approveQuote(quoteId) {
        approveQuote({ quoteId })
            .then(() => {
                this.quotes = this.quotes.filter(q => q.Id !== quoteId);
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Quote approved.',
                        variant: 'success'
                    })
                );
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: error.body.message,
                        variant: 'error'
                    })
                );
            });
    }

    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;

        if (actionName === 'approve') {
            this.approveQuote(row.Id);
        }
    }
}