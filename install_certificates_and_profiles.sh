#!/usr/bin/env bash

#==========================================================================================
# Originate iOS CircleCI Deployment
# install_certificates_and_profiles.sh
# (based on: https://github.com/thorikawa/CircleCI-iOS-TestFlight-Sample/tree/master/scripts)
#
# This is a script to import certs and install provisioning profiles into a
#    temporary keychain for Continuous Deployment on CircleCI.
#
# Relevant items :
#    Certificates :
#        apple.cer : Apple Worldwide Developer Relations Certification Authority
#        dist.cer  : iOS distribution certificate
#        dist.p12  : iOS distribution private key (locked with $KEY_PASSWORD on export)
#
#    Provisioning Profiles :
#        Mobile Provisioning Profiles for the project being deployed are installed from
#            ./scripts/CircleCI/profile/
#
# Certificates are imported into a temporary keychain, circle.keychain, locked with
#     the password $KEYCHAIN_PASSWORD
#
#==========================================================================================

# set password for circle.keychain
KEYCHAIN_PASSWORD=circleci
KEY_PASSWORD=circleci

# create circle.keychain with $KEYCHAIN_PASSWORD
security create-keychain -p $KEYCHAIN_PASSWORD circle.keychain
# import Apple Worldwide Developer Relations Certification Authority to circle.keychain
security import ./apple.cer -k ~/Library/Keychains/circle.keychain -T /usr/bin/codesign
# import iOS distribution certificate to circle.keychain
security import ./dist.cer -k ~/Library/Keychains/circle.keychain -T /usr/bin/codesign
# import iOS distribution private key to circle.keychain
security import ./dist.p12 -k ~/Library/Keychains/circle.keychain -P $KEY_PASSWORD -T /usr/bin/codesign
# load the keychain
security list-keychain -s ~/Library/Keychains/circle.keychain
# unlock keychain with $KEYCHAIN_PASSWORD
security unlock-keychain -p $KEYCHAIN_PASSWORD ~/Library/Keychains/circle.keychain

# install provisioning profiles to system
mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles
cp ./profile/* ~/Library/MobileDevice/Provisioning\ Profiles/
