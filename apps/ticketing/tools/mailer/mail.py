# https://mailtrap.io/blog/send-emails-with-gmail-api/
#https://developers.google.com/gmail/api/quickstart/python
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

from email.message import EmailMessage
from email.mime.audio import MIMEAudio
from email.mime.base import MIMEBase
from email.mime.image import MIMEImage
from email.mime.text import MIMEText

import google.auth
from google.auth.transport.requests import Request
from google.oauth2.credentials import Credentials
from google_auth_oauthlib.flow import InstalledAppFlow
from googleapiclient.discovery import build
from googleapiclient.errors import HttpError

if(len(sys.argv) < 3):
    print('emailid imagename required')
    sys.exit(1)

to_email = sys.argv[1]
image_name = sys.argv[2]

# If modifying these scopes, delete the file token.json.
#SCOPES = ['https://www.googleapis.com/auth/gmail.readonly']
SCOPES = ['https://www.googleapis.com/auth/gmail.compose']

def gmail_create_draft_with_attachment(service):
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
        mime_message['From'] = 'sairamaj@gmail.com'
        mime_message['Subject'] = 'Your GPTA ticket QR code image'

        # text
        mime_message.set_content(
            'Hi Please bring this GPTA QR code for faster check-in.'
            'Please do not reply.'
        )

        # attachment
        attachment_filename = image_name
        # guessing the MIME type
        type_subtype, _ = mimetypes.guess_type(attachment_filename)
        maintype, subtype = type_subtype.split('/')

        with open(attachment_filename, 'rb') as fp:
            attachment_data = fp.read()
        mime_message.add_attachment(attachment_data, maintype, subtype,filename=attachment_filename)

        encoded_message = base64.urlsafe_b64encode(mime_message.as_bytes()).decode()

        create_draft_request_body = {
            'message': {
                'raw': encoded_message
            }
        }
        # pylint: disable=E1101
        draft = service.users().drafts().create(userId="me",
                                                body=create_draft_request_body)\
            .execute()
        print(F'Draft id: {draft["id"]}\nDraft message: {draft["message"]}')
        drafts = service.users().drafts()
        draft_id = draft["id"]
        drafts.send(userId='me', body={ 'id': str(draft_id) }).execute()
        print(F'sending draft')
    except HttpError as error:
        print(F'An error occurred: {error}')
        draft = None
    return draft


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
        gmail_create_draft_with_attachment(service)

    except HttpError as error:
        # TODO(developer) - Handle errors from gmail API.
        print(f'An error occurred: {error}')


if __name__ == '__main__':
    main()