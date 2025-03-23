#!/usr/bin/env bats

setup() {
  DIR="$(cd "$(dirname "$BATS_TEST_FILENAME")" >/dev/null 2>&1 && pwd)"
  PATH="$DIR/../:$PATH"
  PREFIX="/tmp/bats-aws-cli-installer/prefix"
  BIN="/tmp/bats-aws-cli-installer/bin"
  mkdir -p "$PREFIX" "$BIN"
}

teardown() {
  rm -rf /tmp/bats-aws-cli-installer
}

@test "-h displays help" {
  run aws-cli-installer -h
  [[ "$status" -eq 0 ]]
  [[ "${lines[0]}" = "Usage: aws-cli-installer [OPTIONS]" ]]
  [[ "${lines[2]}" =~ "Display this message" ]]
}

@test "-v with no arg displays version" {
  run aws-cli-installer -v
  [[ "$status" -eq 0 ]]
  [[ "${lines[0]}" =~ "aws-cli-installer v" ]]
  [[ "${lines[1]}" = "See aws-cli-installer --help for usage." ]]
}

@test "installs and uninstalls AWS CLI" {
  # installs
  run aws-cli-installer -i "$PREFIX" -b "$BIN"
  [[ "$status" -eq 0 ]]
  [[ -f "$BIN/aws" ]]
  "$BIN"/aws --version

  # uninstalls
  run aws-cli-installer -i "$PREFIX" -b "$BIN" --uninstall
  [[ "$status" -eq 0 ]]
  [[ ! -f "$BIN/aws" ]]
  [[ ! -d "$PREFIX/awscli" ]]
}

@test "-v installs specific AWS CLI version" {
  run aws-cli-installer -v 2.3.4 -i "$PREFIX" -b "$BIN"
  [[ "$status" -eq 0 ]]
  [[ -f "$BIN/aws" ]]
  run "$BIN"/aws --version
  [[ "$status" -eq 0 ]]
  [[ "$output" =~ "aws-cli/2.3.4 Python/3.8.8" ]]
}

@test "-g checks GPG signature" {
  run aws-cli-installer -g --gpg-autoimport -i "$PREFIX" -b "$BIN"
  [[ "$status" -eq 0 ]]
  [[ "${lines[0]}" =~ "gpg:" ]]
  [[ -f "$BIN/aws" ]]
  "$BIN"/aws --version
}
