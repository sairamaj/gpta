echo off
echo ------------------------------------------------------
rem prerequiste: create gpta2022 S3 bucket before running this
echo on
echo ------------------------------------------------------
aws cloudformation package --template-file app_spec.yaml --output-template-file new_app_spec.yaml --s3-bucket gpta2023 
