#!/usr/bin/env ruby
require_relative "../../config/environment"

User.expire_classes

Appointment.finalize
