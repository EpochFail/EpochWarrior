#!/usr/bin/env ruby
require 'rubygems'
require 'ruby_warrior'

profile = RubyWarrior::Profile.load('./.profile')
profile.tower_path = Gem.path.first+"/gems/rubywarrior-0.1.1/towers/intermediate"
profile.save
