// Copyright (c) 2024 ttldtor.
// SPDX-License-Identifier: BSL-1.0

#include <iostream>
#include <string>

#include <kurlikor.hpp>

using namespace std::literals;

int main(int argc, char** argv) {
  if (argc > 1) {
    if (argv[1] == "test-simple-get"s) {
      std::cout << org::ttldtor::kurlikor::get("http://info.cern.ch") << std::endl;
    }
  }

  return 0;
}