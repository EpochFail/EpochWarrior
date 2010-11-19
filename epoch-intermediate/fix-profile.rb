#!/usr/bin/env ruby
require 'rubygems'
require 'ruby_warrior'

profile = RubyWarrior::Profile.load('./.profile')
spec =Gem::GemPathSearcher.new.find("ruby_warrior")
profile.tower_path = spec.full_gem_path + "/towers/intermediate"
profile.save
