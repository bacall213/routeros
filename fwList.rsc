#######################################
# Copyright 2016 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# This is not an official Google product.
#
# RouterOS
#
# View/Reset select firewall address lists
# Globals:
#   fwList
# Arguments:
#   $1 -> $action
#     (v|V|view|View|VIEW|r|R|reset|Reset|RESET)
#   $2 -> $addressList
#     (firewall_list_name)
# Returns:
#   None
#
#######################################

# Remove script and function if they exist
:if ([/system script find where name=fwList] != "") do={
  /system script remove [/system script find where name=fwList];
  /system script environment remove \
    [/system script environment find where name=fwList];
};


# New script is added here
# If the script hasn't been modified, this is the only code block you need.
/system script add name="fwList" \
  comment="View/Reset firewall address lists" policy="read,policy,test" \
  source={
  
  :global fwList do={
    :local action "$1";
    :local addressList "$2";
    
    :local sshLists {"ssh-attempt-1";"ssh-attempt-2";\
                     "ssh-attempt-3";"ssh-attempt-4";\
                     "ssh-blocked-addr";"ssh-attempt-30d-src";\
                     "ssh-accept"};

    :local dropLists {"dropped-addr-1d";"dropped-addr-1h";\
                      "dropped-addr-1m";"dropped-addr-5m";\
                      "dropped-addr-7d";"dropped-addr-10m";\
                      "dropped-addr-12h";"dropped-addr-30m";\
                      "dropped-guests-1d";"dropped-guests-1h";\
                      "dropped-guests-1m";"dropped-guests-5m";\
                      "dropped-guests-10m";"dropped-guests-30m";\
                      "portscan-src-5m";"blocked-addr"};

    :local definedLists {"sshLists"=$sshLists;"dropLists"=$dropLists};
    :local realAction;
    
    # Check for action and firewall list
    :if (("$action" ~ "^(v|V|view|View|VIEW|r|R|reset|Reset|RESET)\$") && \
         ([:typeof "$addressList"] != "nothing")) do={

      :if ("$action" ~ "^(v|V|view|View|VIEW)\$") do={
        :set realAction "view";
      } else={
        :if ("$action" ~ "^(r|R|reset|Reset|RESET)\$") do={
          :set realAction "reset";
        };
      };

      # Check if input is a predefined array of lists
      :if ([:typeof ($definedLists->"$addressList")] = "array") do={
        :put ("Predefined firewall list array includes " . \
          [:len ($definedLists->"$addressList")] . " lists:");
        
        :foreach subList in=($definedLists->"$addressList") do={
          :local listLength [:len [/ip firewall address-list \
            find where list="$subList"]];

          :if ($listLength > 0) do={
            :put ("List $subList contains " . $listLength . " item(s):");

            :foreach address in=[/ip firewall address-list \
              find where list="$subList"] do={
              
              :local humanAddress \
                [/ip firewall address-list get $address address];

              :if ("$realAction" = "view") do={
                :put "$humanAddress ($address)";
              } else={
                :if ("$realAction" = "reset") do={
                  :put "Removing $humanAddress ($address)";
                  /ip firewall address-list remove $address;
                };
              };
            };
          } else={ :put "Skipping empty list... $subList"; };
        };
      } else={
        :local listLength [:len [/ip firewall address-list \
          find where list="$addressList"]];

        :if ($listLength > 0) do={
          :put ("List $addressList contains " . $listLength . " item(s):");

          :foreach address in=[/ip firewall address-list \
            find where list="$addressList"] do={
            
            :local humanAddress \
              [/ip firewall address-list get $address address];
            
            :if ("$realAction" = "view") do={
              :put "$humanAddress ($address)";
            } else={
              :if ("$realAction" = "reset") do={
                :put "Removing $humanAddress ($address)";
                /ip firewall address-list remove $address;
              };
            };
          };
        } else={ :put "List is empty or nonexistent... $addressList"; };
      };
    } else={
      :put "Usage:";
      :put "  \$fwList (v|V|view|View|VIEW) firewall_list_or_array";
      :put "  \$fwList (r|R|reset|Reset|RESET) firewall_list_or_array";
      :put "\n  Predefined firewall list arrays:";
      :foreach name,list in=($definedLists) do={ :put "  $name"; };
    };
  };
};


# Execute script to create global function
/system script run fwList;