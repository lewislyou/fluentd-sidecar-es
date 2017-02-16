#!/bin/bash

# Copyright 2015 The Kubernetes Authors All rights reserved.
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

mkdir -p /etc/td-agent/files
if [ -z "$FILES_TO_COLLECT" ]; then
  exit 0
fi

podnametag=${PODNAME//-/.}

for filepath in $FILES_TO_COLLECT
do
  filename=$(basename $filepath)
  cat > "/etc/td-agent/files/${filename}" << EndOfMessage
<source>
  type tail
  format multiline
  format_firstline /\d{4}-\d{1,2}-\d{1,2}/
  format1 /^(?<time>[^ ]* [^ ]*) *(?<level>[^ ]*) *\[(?<thread>[^ ].*)\] *\[(?<userspace>[^ ].*)\] - (?<message>[^ ].*)/
  multiline_flush_interval 3s
  time_format %F %T,%L
  path ${filepath}
  read_from_head true
  pos_file /etc/td-agent/fluentd-es.log.pos
  tag $podnametag.$PODNAMESPACE.${filename//-/.}
</source>
EndOfMessage
done
