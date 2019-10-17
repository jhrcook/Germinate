#!/bin/bash

## Build the Jazzy documentation and print the undocumented objects.

jazzy -x USE_SWIFT_RESPONSE_FILE=NO

Swift .parse_undocumented_json.swift

exit
