# Increase log verbosity
log_level = "DEBUG"

# Setup data dir
data_dir = "/tmp/psqaserver1"

name = "psqaserver1"
region     = "qatar"
datacenter = "ps"

# Enable the server
server {
    enabled = true

    # Self-elect, should be 3 or 5 for production
    bootstrap_expect = 1
}
