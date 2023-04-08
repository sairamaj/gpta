# https://mailtrap.io/blog/send-emails-with-gmail-api/
# https://developers.google.com/gmail/api/quickstart/python
# https://cppsecrets.com/users/16949711010510710111649539864103109971051084699111109/Python-Create-Gmail-drafts-from-Gmail-account-using-Gmail-API.php


# Copyright 2018 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# [START gmail_quickstart]
from __future__ import print_function

import base64
import mimetypes
import os
import sys
import shutil

from email.message import EmailMessage
from email.mime.audio import MIMEAudio
from email.mime.base import MIMEBase
from email.mime.image import MIMEImage
from email.mime.text import MIMEText
from os import listdir
from os.path import isfile, join

import google.auth
from google.auth.transport.requests import Request
from google.oauth2.credentials import Credentials
from google_auth_oauthlib.flow import InstalledAppFlow
from googleapiclient.discovery import build
from googleapiclient.errors import HttpError

if(len(sys.argv) < 2):
    print('directory (directory containing images) [boolean for create_draft] [boolean for send_draft] [boolean for auto]')
    sys.exit(1)
create_draft = False
send_draft = False
auto = False

imagePath = sys.argv[1]
if(len(sys.argv) > 2):
    print(sys.argv[2])
    create_draft = sys.argv[2].lower() == "true"
if(len(sys.argv) > 3):
    send_draft = sys.argv[3].lower() == "true"
if(len(sys.argv) > 4):
    auto = sys.argv[4].lower() == "true"

if send_draft == True and create_draft == False:
    print('If send_draft is True, create_draft should be True')
    sys.exit(2)

from_email = 'gptainfo@gmail.com'
subject = 'Your GPTA ticket QR code'
body = f = open("body.txt", "r").read()


# If modifying these scopes, delete the file token.json.
#SCOPES = ['https://www.googleapis.com/auth/gmail.readonly']
SCOPES = ['https://www.googleapis.com/auth/gmail.compose']


def gmail_create_draft_send_with_attachment(service, to_email, attachment_filename, create_draft, send_draft):
    """Create and insert a draft email with attachment.
       Print the returned draft's message and id.
      Returns: Draft object, including draft id and message meta data.

      Load pre-authorized user credentials from the environment.
      TODO(developer) - See https://developers.google.com/identity
      for guides on implementing OAuth2 for the application.
    """
    #creds, _ = google.auth.default()

    try:
        # create gmail api client
        #service = build('gmail', 'v1', credentials=creds)
        mime_message = EmailMessage()

        # headers
        mime_message['To'] = to_email
        mime_message['From'] = from_email
        mime_message['Subject'] = subject

        # text
        mime_message.set_content(body)

        # attachment
        # guessing the MIME type
        type_subtype, _ = mimetypes.guess_type(attachment_filename)
        maintype, subtype = type_subtype.split('/')

        with open(attachment_filename, 'rb') as fp:
            attachment_data = fp.read()
        mime_message.add_attachment(
            attachment_data, maintype, subtype, filename=attachment_filename)

        encoded_message = base64.urlsafe_b64encode(
            mime_message.as_bytes()).decode()

        create_draft_request_body = {
            'message': {
                'raw': encoded_message
            }
        }

        print(F"To:{to_email} Attachment:{attachment_filename}...")
        draft = None
        if create_draft is True:
            print("Creating real draft")
            # pylint: disable=E1101
            draft = service.users().drafts().create(userId="me",
                                                    body=create_draft_request_body)\
                .execute()
            print(
                F'Draft id: {draft["id"]}\nDraft message: {draft["message"]}')

            if send_draft is True:
                print("Sending real mail")
                drafts = service.users().drafts()
                draft_id = draft["id"]
                drafts.send(userId='me', body={'id': str(draft_id)}).execute()
                print(F'sending draft')
    except HttpError as error:
        print(F'An error occurred: {error}')
        draft = None
    return draft

# enumerates emails and image names from the image path


def getEmails(imagePath):
    pngFiles = [f for f in listdir(imagePath) if isfile(join(imagePath, f))]

    list = []
    for pngFile in pngFiles:
        if pngFile.endswith('.png'):
            email = pngFile[:-len(".png")]
            list.append((email, os.path.join(imagePath, pngFile)))
    return list

def cleanStaging(imagePath):
    print(f"cleaning staging: {imagePath}")
    for file in os.listdir(imagePath):
        batch_path = os.path.join(imagePath, file)
        if os.path.isdir(batch_path):
            print(f"cleaning batch path: {batch_path}")
            shutil.rmtree(batch_path)

def moveToStaging(imagePath):
    batch = 1
    batch_count = 10
    count = 0
    batch_path_list = []
    batch_path = os.path.join(imagePath, f"batch_{batch}")
    os.mkdir(batch_path)
    batch_path_list.append(batch_path)
    pngFiles = [f for f in listdir(imagePath) if isfile(join(imagePath, f))]
    for file in pngFiles:
        if count == batch_count:
            batch = batch+1
            count = 0
            batch_path = os.path.join(imagePath, f"batch_{batch}")
            os.mkdir(batch_path)
            batch_path_list.append(batch_path)

        src = os.path.join(imagePath, file)
        dst = os.path.join(batch_path, file)
        print(f"copying {src} to {dst}")
        shutil.copyfile(src, dst)
        count = count + 1
    return batch_path_list

def main():
    """Shows basic usage of the Gmail API.
    Lists the user's Gmail labels.
    """
    creds = None
    # The file token.json stores the user's access and refresh tokens, and is
    # created automatically when the authorization flow completes for the first
    # time.
    if os.path.exists('token.json'):
        creds = Credentials.from_authorized_user_file('token.json', SCOPES)
    # If there are no (valid) credentials available, let the user log in.
    if not creds or not creds.valid:
        if creds and creds.expired and creds.refresh_token:
            creds.refresh(Request())
        else:
            flow = InstalledAppFlow.from_client_secrets_file(
                'credentials.json', SCOPES)
            creds = flow.run_local_server(port=0)
        # Save the credentials for the next run
        with open('token.json', 'w') as token:
            token.write(creds.to_json())

    try:
        # Call the Gmail API
        # create gmail api client
        service = build('gmail', 'v1', credentials=creds)

        print(
            f"processing {imagePath} create_draft:{create_draft} send_draft:{send_draft}")
        
        cleanStaging(imagePath)
        batch_path_list = moveToStaging(imagePath)
        total_sends = 0
        mails_send = []
        for batch_path in batch_path_list:
            print(f"batch {batch_path}")
            proceed = False
            if auto == False:
                proceed = input("Press Y to proceed:") == "Y"
            else:
                proceed = True
            email_pngfiles = getEmails(batch_path)
            if proceed:
                for email_pngfile in email_pngfiles:
                    print(email_pngfile)
                    mails_send.append(email_pngfile)
                    gmail_create_draft_send_with_attachment(
                        service, email_pngfile[0], email_pngfile[1], create_draft, send_draft)
                    total_sends = total_sends+1
        
        print(f"total mails send:{total_sends}")
        # print('________________________')
        # for email_pngfile in mails_send:
        #     print(f"{email_pngfile[1]} sent to {email_pngfile[0]}")
        # print('________________________')

    except HttpError as error:
        # TODO(developer) - Handle errors from gmail API.
        print(f'An error occurred: {error}')


if __name__ == '__main__':
    main()
