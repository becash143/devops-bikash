#!/bin/bash
echo "Updating Ruby"
chmod -R 755 /tmp/ruby
pushd /tmp/ruby
bundle update --bundler
bin/rails db:setup
popd

echo "Updated Successfully"
