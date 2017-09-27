#!/usr/bin/env bash

#==========================================================================================
# Originate iOS CircleCI Deployment
# remove_certificates_and_profiles.sh
#
# This script removes our temporary keychain for Continuous Deployment on CircleCI,
#    along with all installed provisioning profiles. 
#
#==========================================================================================

# delete temporary circle.keychain and remove install system provisioning profiles
security delete-keychain circle.keychain
rm -f ~/Library/MobileDevice/Provisioning\ Profiles/*
