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

require "bigdecimal"
require "test/unit"
require "unit"
require "data"

class TestData < Test::Unit::TestCase
  def test_volt()
    data = DataPacket.from_string("00015;80:")
    assert_equal(BigDecimal("0.015"), data.value)
    assert_equal(:voltage, data.function)
  end

  def test_resistance()
    data = DataPacket.from_string("508323802")
    assert_equal(BigDecimal("8.32") * MEGA, data.value)
    assert_equal(:resistance, data.function)
  end

  def test_cap()
    data = DataPacket.from_string("210126802")
    assert_equal(BigDecimal("0.1012") * MICRO, data.value)
    assert_equal(:capacity, data.function)
  end

  def test_ampere()
    data = DataPacket.from_string("000019808")
    assert_equal(BigDecimal("0.01"), data.value)
    assert_equal(:manualAmpere, data.function)
  end
end
