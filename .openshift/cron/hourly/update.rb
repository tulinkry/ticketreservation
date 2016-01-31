#!/bin/bash

cd "$OPENSHIFT_REPO_DIR"
rake ticket:update
echo `date` > run.txt