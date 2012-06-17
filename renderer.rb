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

require "unit"

class Renderer
  protected
  @@volt_table = 
    [
     [BigDecimal("0.6"), lambda {|v| "%.1fmV" % (v * KILO)}],
     [BigDecimal("0.999"), lambda {|v| "%.0fmV" % (v * KILO)}],
     [BigDecimal("6"), lambda {|v| "%.3fV" % v}],
     [BigDecimal("60"), lambda {|v| "%.2fV" % v}],
     [BigDecimal("600"), lambda {|v| "%.1fV" % v}],
     [INF, lambda {|v| "%.0fV" % v}],
    ]

  @@ampere_table = 
    [
     [BigDecimal("600") * MICRO, lambda {|a| "%.1fμA" % (a / MICRO)}],
     [BigDecimal("999") * MICRO, lambda {|a| "%.0fμA" % (a / MICRO)}],
     [BigDecimal("6000") * MICRO, lambda {|a| "%.3fmA" % (a / MILLI)}],
     [BigDecimal("60") * MILLI, lambda {|a| "%.2fmA" % (a / MILLI)}],
     [BigDecimal("600") * MILLI, lambda {|a| "%.1fmA" % (a / MILLI)}],
     [BigDecimal("999") * MILLI, lambda {|a| "%.0fmA" % (a / MILLI)}],
     [BigDecimal("6"), lambda {|a| "%.3fA" % a}],
     [INF, lambda {|a| "%.2fA" % a}],
    ]

  @@ohm_table = 
    [
     [BigDecimal("600"), lambda {|o| "%.1fΩ" % o}],
     [BigDecimal("999"), lambda {|o| "%.0fΩ" % o}],
     [BigDecimal("6000"), lambda {|o| "%.3fkΩ" % (o / KILO)}],
     [BigDecimal("9999"), lambda {|o| "%.2fkΩ" % (o / KILO)}],
     [BigDecimal("60") * KILO, lambda {|o| "%.2fkΩ" % (o / KILO)}],
     [BigDecimal("600") * KILO, lambda {|o| "%.1fkΩ" % (o / KILO)}],
     [BigDecimal("999") * KILO, lambda {|o| "%.0fkΩ" % (o / KILO)}],
     [BigDecimal("6") * MEGA, lambda {|o| "%.3fMΩ" % (o / MEGA)}],
     [INF, lambda {|o| "%.2fMΩ" % (o / MEGA)}],
    ]

  @@freq_table = 
    [
     [BigDecimal("999"), lambda {|h| "%.0fHz" % h}],
     [BigDecimal("6") * KILO, lambda {|h| "%.3fkHz" % (h / KILO)}],
     [BigDecimal("9.99") * KILO, lambda {|h| "%.2fkHz" % (h / KILO)}],
     [BigDecimal("60.00") * KILO, lambda {|h| "%.2fkHz" % (h / KILO)}],
     [BigDecimal("99.9") * KILO, lambda {|h| "%.1fkHz" % (h / KILO)}],
     [BigDecimal("600") * KILO, lambda {|h| "%.1fkHz" % (h / KILO)}],
     [BigDecimal("999") * KILO, lambda {|h| "%.0fkHz" % (h / KILO)}],
     [BigDecimal("6") * MEGA, lambda {|h| "%.3fMHz" % (h / MEGA)}],
     [INF, lambda {|h| "%.2fMHz" % (h / MEGA)}],
    ]

  @@cap_table = 
    [
     [BigDecimal("9999") * PICO, lambda {|f| "%.0fpF" % (f / PICO)}],
     [BigDecimal("0.06") * MICRO, lambda {|f| "%.5fμF" % (f / MICRO)}],
     [BigDecimal("0.0999") * MICRO, lambda {|f| "%.4fμF" % (f / MICRO)}],
     [BigDecimal("0.6") * MICRO, lambda {|f| "%.3fμF" % (f / MICRO)}],
     [BigDecimal("0.999") * MICRO, lambda {|f| "%.3fμF" % (f / MICRO)}],
     [BigDecimal("6") * MICRO, lambda {|f| "%.3fμF" % (f / MICRO)}],
     [BigDecimal("9.99") * MICRO, lambda {|f| "%.2fμF" % (f / MICRO)}],
     [BigDecimal("60") * MICRO, lambda {|f| "%.2fμF" % (f / MICRO)}],
     [BigDecimal("99.9") * MICRO, lambda {|f| "%.1fμF" % (f / MICRO)}],
     [BigDecimal("600") * MICRO, lambda {|f| "%.1fμF" % (f / MICRO)}],
     [INF, lambda {|f| "%.0fμF" % (f / MICRO)}],
    ]  

  @@function_table = {
    :voltage => lambda {|d| "#{timestamp},#{acdc(d)}V,#{value(d)},#{render_volt_value(d)}"},
    :microAmpere => lambda {|d| "#{timestamp},#{acdc(d)}A,#{value(d)},#{render_ampere_value(d)}"},
    :milliAmpere => lambda {|d| "#{timestamp},#{acdc(d)}A,#{value(d)},#{render_ampere_value(d)}"},
    :autoAmpere => lambda {|d| "#{timestamp},#{acdc(d)}A,#{value(d)},#{render_ampere_value(d)}"},
    :manualAmpere => lambda {|d| "#{timestamp},#{acdc(d)}A,#{value(d)},#{render_ampere_value(d)}"},
    :resistance => lambda {|d| "#{timestamp},Ω,#{value(d)},#{render_ohm_value(d)}"},
    :continuity => lambda {|d| "#{timestamp},Ω,#{value(d)},#{render_ohm_value(d)}"},
    :diode => lambda {|d| "#{timestamp},V,#{value(d)},#{render_volt_value(d)}"},
    :frequency => lambda {|d| "#{timestamp},Ω,#{value(d)},#{render_freq_value(d)}"},
    :capacity => lambda {|d| "#{timestamp},Ω,#{value(d)},#{render_cap_value(d)}"},
    :temperature => lambda {|d| "#{timestamp},℃,#{value(d)},#{render_temp_value(d)}"},
    :adp0 => lambda {|d| "#{timestamp},ADP0,#{value(d)},#{render_adp_value(d)}"},
    :adp1 => lambda {|d| "#{timestamp},ADP1,#{value(d)},#{render_adp_value(d)}"},
    :adp2 => lambda {|d| "#{timestamp},ADP2,#{value(d)},#{render_adp_value(d)}"},
    :unknown => lambda {|d| "#{timestamp},?,#{value(d)},#{render_unknown_value(d)}"},
  }

  public
  def Renderer.render_data(data)
    @@function_table[data.function].call(data)
  end

  def Renderer.render_volt_value(data)
    render_value(@@volt_table, data)
  end

  def Renderer.render_ampere_value(data)
    render_value(@@ampere_table, data)
  end

  def Renderer.render_ohm_value(data)
    render_value(@@ohm_table, data)
  end

  def Renderer.render_freq_value(data)
    render_value(@@freq_table, data)
  end

  def Renderer.render_cap_value(data)
    render_value(@@cap_table, data)
  end

  def Renderer.render_temp_value(data)
    if data.overflow
      "overflow"
    else
      "%.0f℃" % data.value
    end
  end

  def Renderer.render_adp_value(data)
    data.value
  end

  def Renderer.render_unknown_value(data)
    data.value
  end

  protected 
  def Renderer.render_value(table, data)
    if data.overflow
      "overflow"
    else
      absVal = data.value.abs
      (data.value < ZERO ? "-" : "") + table[table.index {|t| absVal <= t[0]}][1].call(absVal)
    end
  end

  def Renderer.value(data)
    if data.overflow
      "overflow"
    else
      data.value
    end
  end

  def Renderer.acdc(data)
    if data.acdc == :ac
      "AC"
    elsif data.acdc == :dc
      "DC"
    else
      ""
    end
  end

  def Renderer.timestamp
    time = Time.now
    time.strftime("%x") + "," + time.strftime("%X")
  end
end
