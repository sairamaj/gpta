# Tasks
  * Understand the application (Gpta Ticket App team)
    * [From here](https://github.com/sairamaj/gpta/blob/2024/apps/ticketing/README.MD)

___

## Setup API (Sai)
* Used to store the ticket and check-in information
* Api url: https://rn0j844i6i.execute-api.us-west-2.amazonaws.com/Prod/tickets/
* Status: Done

___

## Setup Web site(Sai)
* A sample web site which can be used to upload the tickets to AWS dynamodb
* Web site can be accessed from here:
  * [Gpta Developer web site](https://gpta2023.azurewebsites.net/)
  * Same web site which was done in 2023 can be used as there is no change
  * As this was developer web site and not complete (some UI messsages are not greate), but works for functionality ( use chrome developer tools console Ctrl+Shift+I )
  * How to use
    * Administrator
      * Choose File
      * Upload
      * Go to Home to see summary
      * Go to Tickets to see the tikets file
  * File format
    ```csv
        Name,Email,Id,Adults,Kids,Cost,Member
        -------------------------------------
        krishna surya,krishnasurya@yahoo.com,6LR773368C622854B,0,6,92,0
        Lakshmi Jaladi,lakshmicj5@gmail.com,9YE89933N0457553F,2,6,44,0
        Srinivas Sanka,s_sanka@yahoo.com,6UK85494TX455330C,3,7,16,0
    ```
   * How to generate the above file?
     * Download Paypal ticket information
       * Sample paypal from last year
         ```csv
            Adults,Kids,Date,Time,TimeZone,Name,Type,Status,Currency,Gross,Fee,Net,From Email Address,To Email Address,Transaction ID,Shipping Address,Address Status,Item Title,Item ID,Shipping and Handling Amount,Insurance Amount,Sales Tax,Option 1 Name,Option 1 Value,Option 2 Name,Option 2 Value,Reference Txn ID,Invoice Number,Custom Number,Quantity,Receipt ID,Balance,Address Line 1,Address Line 2/District/Neighborhood,Town/City,State/Province/Region/County/Territory/Prefecture/Republic,Zip/Postal Code,Country,Contact Phone Number,Subject,Note,Country Code,Balance Impact
            485,174,,,,,,,,9832,,9486.15,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
            2,0,3/11/2017,16:07:05,PDT,Srinivas Sanka,Website Payment,Completed,USD,16,-0.76,15.24,s_sanka@yahoo.com,gpta@gpta.info,6UK85494TX455330C,"Srinivas, Sanka, 17236 NW Tucson street, Beaverton, OR, 97006, US",Confirmed,per adult,,0,,0,,,,,,,,1,,15.24,17236 NW Tucson street,,Beaverton,OR,97006,US,,,,,
            5,1,3/12/2017,10:51:46,PDT,krishna surya,Website Payment,Completed,USD,92,-2.97,89.03,krishnasurya@yahoo.com,gpta@gpta.info,6LR773368C622854B,"krishna, surya, 17738 NW Pioneer Road, Beaverton, OR, 97006, US",Confirmed,,,0,,0,,,,,,,,6,3.35E+15,104.27,17738 NW Pioneer Road,,Beaverton,OR,97006,US,,,krishnasurya@yahoo.com,,
            2,1,3/12/2017,10:56:34,PDT,Lakshmi Jaladi,Website Payment,Completed,USD,44,-1.58,42.42,lakshmicj5@gmail.com,gpta@gpta.info,9YE89933N0457553F,"Lakshmi, Jaladi, 1950 nw Miller rd  apt #c410, CEDAR MILL, OR, 97229, US",Confirmed,,,0,,0,,,,,,,,3,3.99E+15,146.69,1950 nw Miller rd  apt #c410,,CEDAR MILL,OR,97229,US,,Shopping Cartper adultper kid,,,
         ```
    * Use powershell to extract
      * Need to adjust the ticket price in this script as it is used to calculate Adult and Kids count from paypal file (PayPal file has only total but not split of adults and kids)
       ```powershell
        .\PayPalExtract.ps1 -FileName .\sample\UgadiTickets.csv  -FilterAfterDate 02/02/2022 | out-file c:\temp\sample.txt
       ```
    * Use the above generated file to upload
    * If you want to write another script to generate the .csv file , you can do whatever the tool you are comfortable as long as the file format is same
___      
  
## Ios App(Gpta Team)    
* Pre requisites
  * Mac
  * Familiazation with XCode
  * Apple developer account (you can test without this, but to copy to iphone ,you need this)
* Checkout source from [here](https://github.com/sairamaj/gpta/)
  * git clone https://github.com/sairamaj/gpta/
* Switch to branch 2024
  * git checkout -f 2024
* Open _ticketapp_ project from  apps\ticketing\app\ios\ticketapp in _XCode_
* Change the URL
* Run the app
* See that simulator is coming up
* See the tickets are being shown (using web app a sample was loaded)
* Downloading to the phone
  * Setup the developer account
  * Connect iphone
  * Switch from simulator to connected phone in XCode 
  * Run the app and xcode will copy the app
  * you can repeat this process for other iphones

_____

## Day before event(Gpta Ticketing Team)
* Setting up the ticketing data
  * Download the csv file from paypal
  * Run the powershell tool to generate csv (or your own custom tool)
  * Through developer web site
    * Administartor
      * Clear
      * Upload
    * Verify through _Home_ and _Ticket_ links in web site
* Relaunch the iphone app
  * One should see the tickets

_____



