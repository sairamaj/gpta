# Overview
This directory contains the tools to make the ticket app to work

_____

## Extract
Extracts the pay pal downloaded to normalied view which can be used to upload

* Language
  * Powershell
* Input
  * Pay pal downloaded spreadsheet
* Output
  * Text file containing the ticket info
  ```txt
    Name,Email,Id,Adults,Kids,Cost,Member
    -------------------------------------
    Ab11 A111,aba111@gmail.com,6SW64429E6173130K 3JR01788PK839950G 2R543605L2110010F 6XH68052019113833,2,,60.00,True
    B111 L111,b11@gmail.com,2VY653210Y997023J,2,,60.00,False
  ```
* Usage
  ```powershell
    .\PayPalExtract.ps1 -FileName 'Download.CSV' -FilterAfterDate 03/12/2023 | out-file ..\output\out.txt -Encoding ascii
  ```

_____

## QrCode
Generates QR code from the tickets 

* Language
  * JavaScript
* Input
  * Ticket file
* Output
  * QR code images for each participant in output\images
* Usage
  ```cmd
    node gen_qrcode_tickets.js ..\output\out.txt
  ```

_____

## Mailer
Send mail

* Language
  * Python
* Input
  * Image directory containing images
    * Each image is in the format of <email>.png
* Result
  * Mail sent with attachment
* Usage
  ```cmd
    c:\python38\python mail.py ..\output\images False False true
  ```  
_____


