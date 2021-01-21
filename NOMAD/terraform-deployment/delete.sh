#!/bin/bash

terraform destroy \
      -var "do_token=" \
      -lock=false -auto-approve
