echo off
echo ------------------------------------------------------
rem prerequiste: run package to update the code.
echo on
echo ------------------------------------------------------
aws cloudformation deploy --template-file new_app_spec.yaml --stack-name gpta2024-ticketing-2 --capabilities CAPABILITY_IAM --parameter-overrides Stage=prod


 