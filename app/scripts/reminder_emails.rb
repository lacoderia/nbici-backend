#!/usr/bin/env ruby
require_relative "../../config/environment"

User.send_classes_left_reminder

User.send_expiration_reminder
