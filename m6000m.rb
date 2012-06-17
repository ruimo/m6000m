#!/usr/bin/ruby                                                                      

#  Licensed to the Apache Software Foundation (ASF) under one or more
#  contributor license agreements.  See the NOTICE file distributed with
#  this work for additional information regarding copyright ownership.
#  The ASF licenses this file to You under the Apache License, Version 2.0
#  (the "License"); you may not use this file except in compliance with
#  the License.  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.

require 'rubygems'                                                                   
gem 'serialport','>=1.0.4'
require 'serialport'
require "bigdecimal"
require "data"
require "renderer"

if ARGV.length == 0
  puts "Specify RS-232C device name"
  exit(1)
end

SerialPort.open(ARGV.shift, 19200, 7, 1, SerialPort::ODD) {|sp|                                                
  sp.read_timeout = 2000

  loop do
    data = sp.gets
    if data == nil
      sp.break(5)
    elsif data.length == 11
#      puts "data = #{data}"
      dataPacket = DataPacket.from_string(data)
      puts Renderer.render_data(dataPacket)
    end
  end
}

