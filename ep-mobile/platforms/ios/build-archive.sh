#!/bin/bash

# Copyright © 2014 Elastic Path Software Inc. All rights reserved.
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
#
#
# build-archive.sh
#
# Bash script to build, archive and export the HTML5 Storefront iOS PhoneGap app.
# Generates a distribution package in the form of a .IPA file.
#
# USAGE:         the script expects 2 parameters specifying the build and
#                version numbers to be associated with the generated app.
#
# PREREQUISITES: 1. an iOS device with a valid provisioning profile has been configured in Xcode
#                2. the relevant configuration settings have been set in this file

# ======================
# CONFIGURATION SETTINGS
# ======================

# Full path to the directory where the Xcode project (.xcodeproj file) resides
PROJ_DIR=~/Dev/phonegap/ep-mobile/platforms/ios/

# The name of the Xcode project (space characters should be escaped with \)
PROJ_NAME=HTML5\ Storefront

# Location of the .plist file
INFOPLIST_FILE=${PROJ_DIR}${PROJ_NAME}/${PROJ_NAME}-Info.plist

# Name of the scheme containing the targets and configurations to be built
SCHEME_NAME=HTML5\ Storefront

# Name of provisioning profile (as it appears in Xcode device organizer)
PROVISIONING_PROFILE="iOS Team Provisioning Profile: *"


# ===========
# SCRIPT BODY
# ===========

# Function to show usage information
show_help() {
cat << EOF
Usage: ${0##*/} [-h] [-b BUILD_NUMBER] [-v VERSION_NUMBER]...

Generates a distribution package (.IPA) file for the HTML5 Storefront PhoneGap iOS application
    
    -h                 display this help
    -b BUILD_NUMBER    the build number to use for this package file (e.g. 1.0.0)
    -v VERSION_NUMBER  the version number to use for this package file (e.g. 1.0.0)

EOF
}

# =================
# Handle parameters
# =================
while getopts "hb:v:" opt; do
  case "$opt" in
    h)
      show_help
      exit 0
      ;;
    b)
      BUILD_NUMBER=$OPTARG
      ;;
    v)
      VERSION_NUMBER=$OPTARG
      ;;
    '?')
      show_help >&2
      exit 1
      ;;
    esac
done

# Test that build AND version number parameters have been supplied
if [ -z $BUILD_NUMBER ] || [ -z $VERSION_NUMBER ]; then
  echo "ERROR: Missing build and/or version number parameters"
  show_help
  exit 0
fi

# ============================
# Update build/version numbers
# ============================

# Set build number
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $BUILD_NUMBER" "${INFOPLIST_FILE}"

# Set version number
/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString $VERSION_NUMBER" "${INFOPLIST_FILE}"

# =============================
# Build, archive and export app
# =============================

# Move to the project directory
cd ${PROJ_DIR}

# Build the project - specifying the target processor instruction set (ARMv7 - iPhone 3GS+/iPad)
xcodebuild -project "${PROJ_NAME}.xcodeproj" -scheme "${PROJ_NAME}" -sdk iphoneos7.1 -arch armv7 VALID_ARCHS=armv7 clean build

# Archive the project (generates a .xcarchive file)
xcodebuild archive -archivePath "${PROJ_NAME}" -scheme "${PROJ_NAME}" -arch armv7 VALID_ARCHS=armv7

# Delete any existing IPA file in the target directory
rm -f "${PROJ_NAME}.ipa"

# Export the archive as an IPA file using the provisioning profile
xcodebuild -exportArchive -exportFormat IPA -archivePath "${PROJ_NAME}.xcarchive" -exportPath "${PROJ_NAME}" -exportProvisioningProfile "${PROVISIONING_PROFILE}"
