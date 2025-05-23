/* target dependent procedure for mros2-mbed
 * Copyright (c) 2023 mROS-base
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/* NOTE:
 *   this file has not been implemented and used yet
 */

#include "mros2.h"
#include "mros2-platform.h"

#include "cmsis_os.h"
#include "wifi.h"


/*
 *  Setup network I/F
 */
extern "C" esp_err_t mros2_platform_network_connect(void)
{
  init_wifi();
  osKernelStart();

  /* get mros2 IP address and set it to RTPS */
  uint32_t ipaddr = get_mros2_ip_addr();
  return mros2_setIPAddrRTPS(ipaddr);
}
