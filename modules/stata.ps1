# Stata 17

aws s3 cp s3://${Env:S3_PACKER_RESOURCES_PATH}/SetupStata17.exe SetupStata17.exe

Start-Process SetupStata17.exe -ArgumentList "/s","/v`"/qn ADDLOCAL=core,StataMP64`"" -NoNewWindow -Wait -PassThru

# I couldn't find a way to automate the license details, like I did
#  under Ubuntu using expect, since it uses a Windows Form for
# these. As far as as I understand, this lic file should work on both
# Windows and Linux, but I think I prefer my expect solution...
aws s3 cp s3://${Env:S3_PACKER_RESOURCES_PATH}/stata.lic "C:\\Program Files\\Stata17\\STATA.lic"

# We have a temporary build of Stata 17 which fixes issues relating to
# writing to rclone mounted (and OneDrive, apparently) volumes. This
# will be included in a Stata 17 update at some point, but for now we
# can pull down the test release.
aws s3 cp s3://${Env:S3_PACKER_RESOURCES_PATH}/StataMP-64-test.exe "C:\\Program Files\\Stata17\\StataMP-64.exe"
