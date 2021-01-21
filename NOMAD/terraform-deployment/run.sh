#!/bin/bash

terraform apply \
      -var "do_token=" \
      -lock=false -auto-approve
