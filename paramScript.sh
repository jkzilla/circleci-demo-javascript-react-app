#!/bin/bash
PARAM_FLAG=$(eval echo "${PARAM_FLAG}")

if [ "$PARAM_FLAG" = "false" ]; then
    echo "hi_im_False"
fi