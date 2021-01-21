#!/bin/bash

terraform plan \
      -var "do_token=" \
      -lock=false
