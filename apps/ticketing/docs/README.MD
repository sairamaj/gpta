# Overview
Ios App to manage event ticketing system. 

____

## Features
* Check-in ticket for the ticket holders
  * Through QR code scan
  * Search by name/confirmation code
  * Partial check-in capability
* Synchronizing the check-ins from multiple devices
* Report view
  * View by number of arrivals

____

## How to check-in 
  * Ask for QR code and available 
    * use Scan button
  * If no QR code
    * Ask for either name or confirmation code
  * If all participants arrived use the quick switcher to mark all the participants.
  * If you are doing partial check-ins (not recommended)
    * Increment/Decrement either Adult/Kids appropriately
  * Use the __Done__ button to close the info

**Note:** Even though app supports partial check-in , it is not recommended to use it as it gets complicated. Give the bracelets for the one who arrived first and mark as all arrived. Also partial check-in is not available through QR Scan.

____

## Scan
Couple of things to learn about Scan

* Detects whether a GPTA ticket or not and if not detected then shows the error.
* If QR code is presented and it is GPTA ticket info, then confirmation is matched against all tickets and will present Check-In only if the ticket exists.
* Once QR scanned and Checked in using the scan, then if the same QR is presented , we cannot use for Check-in. (One can un check using in the app and present QR code again)

____

## Settings
Before using the app (also one can check while app is running) make sure **Auto refresh** is enabled and also set to **2mins**.

Go to Settings -> TicketApp -> Auto Refresh and enable it.

Go to Settings -> TicketApp -> Auto Interval and set it to **2min**

**Note**: Even though there is a background timer which is supposed to refresh , please use Refresh icon on the top to synchronization.
____

## FAQ
**Q**:What is the star(*) next to ticket
**Ans**: Indicates that GPTA membership.

**Q**: Ticket report does not match with other device

**Ans**: Try using Refresh icon to see whether it updates or not.

**Q**: It is not synchroning from other device

**Ans**: Visit the **Logs** button and see whether any errors are happening becuase of flaky network. This should show how the syncing is happening.

**Q**: What is the green block against to ticket.

**Ans**: This indicates whether it was synchronized to cloud or not.
____
