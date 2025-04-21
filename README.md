# Brian Cersosimo - FirstChair Challenge

Flow, Classes and LWC are on this repo.

I decided not to create a custom Approval_Status__c field on the Quote object because the standard Status field already covers the necessary approval states. Similarly, instead of adding a custom Total_Amount__c, I used the standard TotalPrice field, which accurately represents the final amount of the quote. This approach helps maintain a clean data model and leverages Salesforce's native functionality.
The current implementation fulfills the requirements effectively, but there is definitely room for enhancements. For example, the trigger logic could be further modularized and extended for scalability, and a factory pattern could be introduced for the TestSetup.

Part 1: https://github.com/cersosimo7/fcChallenge/commit/b39957f6f67b1a6fb58b01f124555a818ee36f0e

Part 2: https://github.com/cersosimo7/fcChallenge/commit/083dcf3f3874eef050524aaa51789a0170b12d85

Bonus: https://github.com/cersosimo7/fcChallenge/commit/a50c802c47ad371792d10ea55330e98740507c99

## Flow

![image](https://github.com/user-attachments/assets/c7d406f3-c06a-4f94-b67b-c43b1366fda0)

## Code Coverage

![image](https://github.com/user-attachments/assets/dab8f0ac-3377-4ecf-b623-6c10350bf98c)

