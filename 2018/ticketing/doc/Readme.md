# Tickets screen
![tickets](https://github.com/sairamaj/gpta/blob/master/2017/ticketing/doc/Screen_Tickets.png)

## Display
* Title will show the Total check-ins / Total tickets ( 52/647)
* Status - No - Name  - checked-in/total tickets
  * Status - Green all checked in. Red nobody checked-in . Yellow - partial check-in
  * No     - Serial number
  * Name   - Name of the person who bought the tickets
  * check-in/total tickets - checked in count/ total tickets bought
* Selecting the row will display 
  * Control where one can either check-in all at once or individual check-ins
  * Shows the pay pal confirmation number
* Actions
  * To check all use the All switch (this checks all the tickets)
  * To check individuals use the stepper 
    * For individual check-ins one has to press __Done__
  * Searching
    * One can search using the __name__(partial) or __confirmation__ number

# Logs
![logs](https://github.com/sairamaj/gpta/blob/master/2017/ticketing/doc/Screen_Log.png)
* Shows diagnostics logs

# Navigating to settings
![tosettings](https://github.com/sairamaj/gpta/blob/master/2017/ticketing/doc/Screen_ToSettings.png)
* Settings to ticket app configuration. Select ticketapp to modify settings

# Settings
![settings](https://github.com/sairamaj/gpta/blob/master/2017/ticketing/doc/Screen_Settings.png)
* Auto refresh 
  * When multiple people are using the app and checking in the tickets auto refresh ON will sync the UI periodically
  * Time period in minutes to auto refresh should happen
  
  __Note__ : 2 minutes is the lowest value and even if you set below 2 the app will  make it 2 minutes ( to save the cost of my __aws__ account)
