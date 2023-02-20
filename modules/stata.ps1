# Stata 17

aws s3 cp s3://${Env:S3_PACKER_RESOURCES_PATH}/SetupStata17.exe SetupStata17.exe

Start-Process SetupStata17.exe -ArgumentList "/s","/v`"/qn ADDLOCAL=core,StataMP64`"" -NoNewWindow -Wait -PassThru

# I couldn't find a way to automate the license details, like I did
#  under Ubuntu using expect, since it uses a Windows Form for
# these. As far as as I understand, this lic file should work on both
# Windows and Linux, but I think I prefer my expect solution...
aws s3 cp s3://${Env:S3_PACKER_RESOURCES_PATH}/stata.lic "C:\\Program Files\\Stata17\\STATA.lic"
