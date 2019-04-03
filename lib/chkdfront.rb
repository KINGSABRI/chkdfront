# Standard libraries
require 'optparse'
require 'ostruct'
require 'net/http'
require 'openssl'

# Chkdfront
require 'chkdfront/version'
require 'chkdfront/providers'
require 'chkdfront/request'
require 'chkdfront/troubleshoot'
require 'chkdfront/cli_operations'

# External libraries
require 'cli/ui'
require 'tty-spinner'
require 'word_wrap'
require 'net/ping'
require 'net/dns'
require 'adomain'

module ChkDFront
  class Error < StandardError; end
end
