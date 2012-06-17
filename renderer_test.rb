#!/usr/bin/ruby                                                                      
# encoding: utf-8

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
require "test/unit"
require "data"
require "renderer"

class TestRenderer < Test::Unit::TestCase
  def test_voltRenderer()
    assert_equal("0.0mV", Renderer.render_volt_value(DataPacket.new(0x34, "0000", :voltage, 1, false, :dc)))
    assert_equal("600.0mV", Renderer.render_volt_value(DataPacket.new(0x34, "6000", :voltage, 1, false, :dc)))
    assert_equal("999mV", Renderer.render_volt_value(DataPacket.new(0x30, "0999", :voltage, 1, false, :dc)))
    assert_equal("-600.0mV", Renderer.render_volt_value(DataPacket.new(0x34, "6000", :voltage, -1, false, :dc)))

    assert_equal("612mV", Renderer.render_volt_value(DataPacket.new(0x30, "0612", :voltage, 1, false, :dc)))
    assert_equal("-612mV", Renderer.render_volt_value(DataPacket.new(0x30, "0612", :voltage, -1, false, :dc)))
    assert_equal("6.000V", Renderer.render_volt_value(DataPacket.new(0x30, "6000", :voltage, 1, false, :dc)))
    assert_equal("-6.000V", Renderer.render_volt_value(DataPacket.new(0x30, "6000", :voltage, -1, false, :dc)))

    assert_equal("6.01V", Renderer.render_volt_value(DataPacket.new(0x31, "0601", :voltage, 1, false, :dc)))
    assert_equal("-6.01V", Renderer.render_volt_value(DataPacket.new(0x31, "0601", :voltage, -1, false, :dc)))
    assert_equal("60.00V", Renderer.render_volt_value(DataPacket.new(0x31, "6000", :voltage, 1, false, :dc)))
    assert_equal("-60.00V", Renderer.render_volt_value(DataPacket.new(0x31, "6000", :voltage, -1, false, :dc)))

    assert_equal("60.1V", Renderer.render_volt_value(DataPacket.new(0x32, "0601", :voltage, 1, false, :dc)))
    assert_equal("-60.1V", Renderer.render_volt_value(DataPacket.new(0x32, "0601", :voltage, -1, false, :dc)))
    assert_equal("600.0V", Renderer.render_volt_value(DataPacket.new(0x32, "6000", :voltage, 1, false, :dc)))
    assert_equal("-600.0V", Renderer.render_volt_value(DataPacket.new(0x32, "6000", :voltage, -1, false, :dc)))

    assert_equal("601V", Renderer.render_volt_value(DataPacket.new(0x33, "0601", :voltage, 1, false, :dc)))
    assert_equal("-601V", Renderer.render_volt_value(DataPacket.new(0x33, "0601", :voltage, -1, false, :dc)))
    assert_equal("1000V", Renderer.render_volt_value(DataPacket.new(0x33, "1000", :voltage, 1, false, :dc)))
    assert_equal("-1000V", Renderer.render_volt_value(DataPacket.new(0x33, "1000", :voltage, -1, false, :dc)))
  end

  def test_ampereRenderer()
    assert_equal("0.0μA", Renderer.render_ampere_value(DataPacket.new(0x30, "0000", :microAmpere, 1, false, :dc)))
    assert_equal("600.0μA", Renderer.render_ampere_value(DataPacket.new(0x30, "6000", :microAmpere, 1, false, :dc)))
    assert_equal("-600.0μA", Renderer.render_ampere_value(DataPacket.new(0x30, "6000", :microAmpere, -1, false, :dc)))

    assert_equal("999μA", Renderer.render_ampere_value(DataPacket.new(0x31, "0999", :microAmpere, 1, false, :dc)))
    assert_equal("-999μA", Renderer.render_ampere_value(DataPacket.new(0x31, "0999", :microAmpere, -1, false, :dc)))
    
    assert_equal("6.000mA", Renderer.render_ampere_value(DataPacket.new(0x31, "6000", :microAmpere, 1, false, :dc)))
    assert_equal("-6.000mA", Renderer.render_ampere_value(DataPacket.new(0x31, "6000", :microAmpere, -1, false, :dc)))

    assert_equal("6.01mA", Renderer.render_ampere_value(DataPacket.new(0x30, "0601", :milliAmpere, 1, false, :dc)))
    assert_equal("-6.01mA", Renderer.render_ampere_value(DataPacket.new(0x30, "0601", :milliAmpere, -1, false, :dc)))
    assert_equal("60.00mA", Renderer.render_ampere_value(DataPacket.new(0x30, "6000", :milliAmpere, 1, false, :dc)))
    assert_equal("-60.00mA", Renderer.render_ampere_value(DataPacket.new(0x30, "6000", :milliAmpere, -1, false, :dc)))

    assert_equal("60.1mA", Renderer.render_ampere_value(DataPacket.new(0x31, "0601", :milliAmpere, 1, false, :dc)))
    assert_equal("-60.1mA", Renderer.render_ampere_value(DataPacket.new(0x31, "0601", :milliAmpere, -1, false, :dc)))
    assert_equal("600.0mA", Renderer.render_ampere_value(DataPacket.new(0x31, "6000", :milliAmpere, 1, false, :dc)))
    assert_equal("-600.0mA", Renderer.render_ampere_value(DataPacket.new(0x31, "6000", :milliAmpere, -1, false, :dc)))

    assert_equal("999mA", Renderer.render_ampere_value(DataPacket.new(0x30, "0999", :autoAmpere, 1, false, :dc)))
    assert_equal("-999mA", Renderer.render_ampere_value(DataPacket.new(0x30, "0999", :autoAmpere, -1, false, :dc)))

    assert_equal("601mA", Renderer.render_ampere_value(DataPacket.new(0x30, "0601", :autoAmpere, 1, false, :dc)))
    assert_equal("-601mA", Renderer.render_ampere_value(DataPacket.new(0x30, "0601", :autoAmpere, -1, false, :dc)))
    assert_equal("6.000A", Renderer.render_ampere_value(DataPacket.new(0x30, "6000", :autoAmpere, 1, false, :dc)))
    assert_equal("-6.000A", Renderer.render_ampere_value(DataPacket.new(0x30, "6000", :autoAmpere, -1, false, :dc)))

    assert_equal("6.01A", Renderer.render_ampere_value(DataPacket.new(0x31, "0601", :autoAmpere, 1, false, :dc)))
    assert_equal("-6.01A", Renderer.render_ampere_value(DataPacket.new(0x31, "0601", :autoAmpere, -1, false, :dc)))
  end

  def test_ohmRenderer()
    assert_equal("0.0Ω", Renderer.render_ohm_value(DataPacket.new(0x30, "0000", :resistance, 1, false, nil)))
    assert_equal("0.1Ω", Renderer.render_ohm_value(DataPacket.new(0x30, "0001", :resistance, 1, false, nil)))
    assert_equal("600.0Ω", Renderer.render_ohm_value(DataPacket.new(0x30, "6000", :resistance, 1, false, nil)))

    assert_equal("601Ω", Renderer.render_ohm_value(DataPacket.new(0x31, "0601", :resistance, 1, false, nil)))
    assert_equal("999Ω", Renderer.render_ohm_value(DataPacket.new(0x31, "0999", :resistance, 1, false, nil)))
    assert_equal("6.000kΩ", Renderer.render_ohm_value(DataPacket.new(0x31, "6000", :resistance, 1, false, nil)))

    assert_equal("6.01kΩ", Renderer.render_ohm_value(DataPacket.new(0x32, "0601", :resistance, 1, false, nil)))
    assert_equal("9.99kΩ", Renderer.render_ohm_value(DataPacket.new(0x32, "0999", :resistance, 1, false, nil)))
    assert_equal("60.00kΩ", Renderer.render_ohm_value(DataPacket.new(0x32, "6000", :resistance, 1, false, nil)))

    assert_equal("60.1kΩ", Renderer.render_ohm_value(DataPacket.new(0x33, "0601", :resistance, 1, false, nil)))
    assert_equal("99.9kΩ", Renderer.render_ohm_value(DataPacket.new(0x33, "0999", :resistance, 1, false, nil)))

    assert_equal("600.0kΩ", Renderer.render_ohm_value(DataPacket.new(0x33, "6000", :resistance, 1, false, nil)))
    assert_equal("999kΩ", Renderer.render_ohm_value(DataPacket.new(0x34, "0999", :resistance, 1, false, nil)))

    assert_equal("1.000MΩ", Renderer.render_ohm_value(DataPacket.new(0x34, "1000", :resistance, 1, false, nil)))
    assert_equal("6.000MΩ", Renderer.render_ohm_value(DataPacket.new(0x34, "6000", :resistance, 1, false, nil)))

    assert_equal("6.01MΩ", Renderer.render_ohm_value(DataPacket.new(0x35, "0601", :resistance, 1, false, nil)))
  end

  def test_freqRenderer()
    assert_equal("0Hz", Renderer.render_freq_value(DataPacket.new(0x30, "0000", :frequency, 1, false, nil)))
    assert_equal("1Hz", Renderer.render_freq_value(DataPacket.new(0x30, "0001", :frequency, 1, false, nil)))
    assert_equal("999Hz", Renderer.render_freq_value(DataPacket.new(0x30, "0999", :frequency, 1, false, nil)))
    assert_equal("1.000kHz", Renderer.render_freq_value(DataPacket.new(0x30, "1000", :frequency, 1, false, nil)))
    assert_equal("6.000kHz", Renderer.render_freq_value(DataPacket.new(0x30, "6000", :frequency, 1, false, nil)))

    assert_equal("6.01kHz", Renderer.render_freq_value(DataPacket.new(0x31, "0601", :frequency, 1, false, nil)))
    assert_equal("60.00kHz", Renderer.render_freq_value(DataPacket.new(0x31, "6000", :frequency, 1, false, nil)))
    assert_equal("99.9kHz", Renderer.render_freq_value(DataPacket.new(0x32, "0999", :frequency, 1, false, nil)))
    assert_equal("100.0kHz", Renderer.render_freq_value(DataPacket.new(0x32, "1000", :frequency, 1, false, nil)))
    assert_equal("600.0kHz", Renderer.render_freq_value(DataPacket.new(0x32, "6000", :frequency, 1, false, nil)))

    assert_equal("601kHz", Renderer.render_freq_value(DataPacket.new(0x33, "0601", :frequency, 1, false, nil)))
    assert_equal("999kHz", Renderer.render_freq_value(DataPacket.new(0x33, "0999", :frequency, 1, false, nil)))
    assert_equal("1.000MHz", Renderer.render_freq_value(DataPacket.new(0x33, "1000", :frequency, 1, false, nil)))
    assert_equal("6.000MHz", Renderer.render_freq_value(DataPacket.new(0x33, "6000", :frequency, 1, false, nil)))
    assert_equal("6.01MHz", Renderer.render_freq_value(DataPacket.new(0x34, "0601", :frequency, 1, false, nil)))
  end

  def test_capRenderer()
    assert_equal("0pF", Renderer.render_cap_value(DataPacket.new(0x30, "0000", :capacity, 1, false, nil)))
    assert_equal("999pF", Renderer.render_cap_value(DataPacket.new(0x30, "0999", :capacity, 1, false, nil)))
    assert_equal("1000pF", Renderer.render_cap_value(DataPacket.new(0x30, "1000", :capacity, 1, false, nil)))
    assert_equal("6000pF", Renderer.render_cap_value(DataPacket.new(0x30, "6000", :capacity, 1, false, nil)))
    assert_equal("6010pF", Renderer.render_cap_value(DataPacket.new(0x31, "0601", :capacity, 1, false, nil)))
    assert_equal("9990pF", Renderer.render_cap_value(DataPacket.new(0x31, "0999", :capacity, 1, false, nil)))
    assert_equal("0.01000μF", Renderer.render_cap_value(DataPacket.new(0x32, "0100", :capacity, 1, false, nil)))
    assert_equal("0.06000μF", Renderer.render_cap_value(DataPacket.new(0x32, "0600", :capacity, 1, false, nil)))
    assert_equal("0.0601μF", Renderer.render_cap_value(DataPacket.new(0x32, "0601", :capacity, 1, false, nil)))
    assert_equal("0.0999μF", Renderer.render_cap_value(DataPacket.new(0x32, "0999", :capacity, 1, false, nil)))
    assert_equal("0.600μF", Renderer.render_cap_value(DataPacket.new(0x32, "6000", :capacity, 1, false, nil)))
    assert_equal("0.999μF", Renderer.render_cap_value(DataPacket.new(0x33, "0999", :capacity, 1, false, nil)))
    assert_equal("6.000μF", Renderer.render_cap_value(DataPacket.new(0x33, "6000", :capacity, 1, false, nil)))
    assert_equal("9.99μF", Renderer.render_cap_value(DataPacket.new(0x34, "0999", :capacity, 1, false, nil)))
    assert_equal("60.00μF", Renderer.render_cap_value(DataPacket.new(0x34, "6000", :capacity, 1, false, nil)))
    assert_equal("99.9μF", Renderer.render_cap_value(DataPacket.new(0x35, "0999", :capacity, 1, false, nil)))
    assert_equal("600.0μF", Renderer.render_cap_value(DataPacket.new(0x35, "6000", :capacity, 1, false, nil)))
    assert_equal("999μF", Renderer.render_cap_value(DataPacket.new(0x36, "0999", :capacity, 1, false, nil)))
    assert_equal("6000μF", Renderer.render_cap_value(DataPacket.new(0x36, "6000", :capacity, 1, false, nil)))
  end
end
