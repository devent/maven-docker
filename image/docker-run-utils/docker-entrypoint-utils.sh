#!/bin/bash

# This project is licensed under the [MIT](https://opensource.org/licenses/MIT) license.
# 
# Copyright 2018 Erwin Müller
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

set -e

BASH_CMD="bash"
RSYNC_CMD="rsync"

function check_files_exists() {
  ls $1 1> /dev/null 2>&1
}

function copy_file() {
  file="$1"; shift
  dir="$1"; shift
  mod="$1"; shift
  if [ -e "$file" ]; then
    mkdir -p "$dir"
    cp "$file" "$dir/$file"
    chmod $mod "$dir/$file"
  fi
}

function copy_files() {
  dir="$1"; shift
  target="$1"; shift
  files="$1"; shift
  if [ ! -d "${dir}" ]; then
    return
  fi
  cd "${dir}"
  if ! check_files_exists "$files"; then
    return
  fi
  $RSYNC_CMD -Lv ${dir}/$files $target/
}

function sync_dir() {
  dir="$1"; shift
  target="$1"; shift
  skip=""
  if [[ $# -gt 0 ]]; then
    skip="$1"; shift
  fi
  if [ ! -d "${dir}" ]; then
    if [[ $skip != "skip" ]]; then
      echo "${dir} does not exists or is not a directory."
      return 1
    else
      return 0
    fi
  fi
  if [ ! -d "${target}" ]; then
    if [[ $skip != "skip" ]]; then
      echo "${target} does not exists or is not a directory."
      return 1
    else
      return 0
    fi
  fi
  cd "${target}"
  $RSYNC_CMD -rlD -c ${dir}/. .
}

function do_sed() {
  ## TEMP File
  TFILE=`mktemp --tmpdir tfile.XXXXX`
  trap "rm -f $TFILE" EXIT

  file="$1"; shift
  search="$1"; shift
  replace="$1"; shift
  sed -r -e "s/^${search}.*/${replace}/g" $file > $TFILE
  cat $TFILE > $file
}

function do_sed_group() {
  ## TEMP File
  TFILE=`mktemp --tmpdir tfile.XXXXX`
  trap "rm -f $TFILE" EXIT

  file="$1"; shift
  search="$1"; shift
  replace="$1"; shift
  sed -r -e "s|^(${search}).*|${replace}|g" $file > $TFILE
  cat $TFILE > $file
}

function set_debug() {
  if [[ "$DEBUG" == "true" ]]; then
    set -x
    BASH_CMD="bash -x"
    RSYNC_CMD="rsync -v"
  fi
}

function is_sync_enabled() {
  if [[ "$SYNC_ENABLED" == "true" ]]; then
    return 0
  else
    return 1
  fi
}

function check_update_time() {
  dataDir="$1"; shift
  cd $dataDir
  if [[ -f ".last_update" ]]; then
    last_update=$(cat .last_update)
    current_time=$(date +%s)
    time_diff=$((current_time-last_update))
    if [[ $time_diff -gt $SYNC_TIME_S ]]; then
      return 0
    else
      return 1
    fi
  else
    return 0
  fi
}

function update_update_time() {
  dataDir="$1"; shift
  cd $dataDir
  echo -n "`date +%s`" > .last_update
}
