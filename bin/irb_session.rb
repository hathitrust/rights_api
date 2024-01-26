#!/usr/bin/env ruby

# frozen_string_literal: true

require "irb"

root =  File.join(__dir__, "..")
$LOAD_PATH << File.join(root, "lib")

require "rights_api/services"

RightsAPI::Services[:database_connection]

require "rights_api"

IRB.setup nil
ARGV.clear # otherwise all script parameters get passed to IRB
IRB.start
