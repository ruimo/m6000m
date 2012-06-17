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

require "bigdecimal"
require "unit"

class DataPacket
  private
  @@function_table = {
    0x3b => :voltage,
    0x3d => :microAmpere,
    0x3f => :milliAmpere,
    0x30 => :autoAmpere,
    0x39 => :manualAmpere,
    0x33 => :resistance,
    0x35 => :continuity,
    0x31 => :diode,
    0x32 => :frequency,
    0x36 => :capacity,
    0x34 => :temperature,
    0x3e => :adp0,
    0x38 => :adp1,
    0x3a => :adp2,
  }

  @@range_voltage_table = {
    0x30 => BigDecimal("6") / 6000,
    0x31 => BigDecimal("60") / 6000,
    0x32 => BigDecimal("600") / 6000,
    0x33 => BigDecimal("6000") / 6000,
    0x34 => BigDecimal("600") * MILLI / 6000,
  }

  @@range_micro_ampere_table = {
    0x30 => BigDecimal("600") * MICRO / 6000,
    0x31 => BigDecimal("6000") * MICRO / 6000,
  }

  @@range_milli_ampere_table = {
    0x30 => BigDecimal("60") * MILLI / 6000,
    0x31 => BigDecimal("600") * MILLI / 6000,
  }

  @@range_auto_ampere_table = {
    0x30 => BigDecimal("6") / 6000,
    0x31 => BigDecimal("60") / 6000
  }

  @@range_manual_ampere_table = {
    0x30 => BigDecimal("60") / 6000,
  }

  @@range_resistance_table = {
    0x30 => BigDecimal("600") / 6000,
    0x31 => BigDecimal("6") * KILO / 6000,
    0x32 => BigDecimal("60") * KILO / 6000,
    0x33 => BigDecimal("600") * KILO / 6000,
    0x34 => BigDecimal("6") * MEGA / 6000,
    0x35 => BigDecimal("60") * MEGA / 6000,
  }

  @@range_freq_table = {
    0x30 => BigDecimal("6") * KILO / 6000,
    0x31 => BigDecimal("60") * KILO / 6000,
    0x32 => BigDecimal("600") * KILO / 6000,
    0x33 => BigDecimal("6") * MEGA / 6000,
    0x34 => BigDecimal("60") * MEGA / 6000,
  }

  @@range_capacity_table = {
    0x30 => BigDecimal("6") * NANO / 6000,
    0x31 => BigDecimal("60") * NANO / 6000,
    0x32 => BigDecimal("600") * NANO / 6000,
    0x33 => BigDecimal("6") * MICRO / 6000,
    0x34 => BigDecimal("60") * MICRO / 6000,
    0x35 => BigDecimal("600") * MICRO / 6000,
    0x36 => BigDecimal("6") * MILLI / 6000,
  }

  @@range_table = {
    :voltage => lambda {|range| @@range_voltage_table[range]},
    :microAmpere => lambda {|range| @@range_micro_ampere_table[range]},
    :milliAmpere => lambda {|range| @@range_milli_ampere_table[range]},
    :autoAmpere => lambda {|range| @@range_auto_ampere_table[range]},
    :manualAmpere => lambda {|range| @@range_manual_ampere_table[range]},
    :resistance => lambda {|range| @@range_resistance_table[range]},
    :continuity => lambda {|range| ONE},
    :diode => lambda {|range| ONE},
    :frequency => lambda {|range| @@range_freq_table[range]},
    :capacity => lambda {|range| @@range_capacity_table[range]},
    :temperature => lambda {|range| ONE},
    :adp0 => lambda {|range| ONE},
    :adp1 => lambda {|range| ONE},
    :adp2 => lambda {|range| ONE},
    :unknown => lambda {|range| ONE},
  }

  public
  def initialize(range, digits, function, sign, overflow, acdc)
    @range = range
    @digits = digits
    @function = function
    @sign = sign
    @overflow = overflow
    @acdc = acdc
    @value = @sign * BigDecimal(@digits) * @@range_table[@function].call(@range)
  end

  def DataPacket.from_string(data)
    range = data.slice!(0)
    digits = data.slice!(0, 4)
    function = @@function_table[data.slice!(0)]
    if function == nil
      function = :unknown
    end

    status = data.slice!(0)
    option1 = data.slice!(0)
    option2 = data.slice!(0)
    sign = 
      if (status & 0b0000100) != 0
        -1
      else
        1
      end
    overflow = (status & 0b0000001) != 0
    if (option2 & 0b0001000) != 0
      acdc = :dc
    elsif (option2 & 0b0000100) != 0
      acdc = :ac
    end

    self.new(range, digits, function, sign, overflow, acdc)
  end

  attr_reader :function, :value, :overflow, :acdc
end
