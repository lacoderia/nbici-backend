#!/usr/bin/env ruby
require_relative "../config/environment"

logger = Logger.new('/home/deploy/nbici-backend/log/expire_and_finalize.log', 5, 1024000)

begin
  User.expire_classes
  Appointment.finalize
  Waitlist.reimburse_classes
  logger.info("Successfully completed")
rescue Exception => e
  logger.error("Errored #{e.message}")
end
