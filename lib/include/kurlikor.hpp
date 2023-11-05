// Copyright (c) 2023 ttldtor.
// SPDX-License-Identifier: BSL-1.0

#pragma once

#include <string>

namespace org::ttldtor::kurlikor {

struct Kurlikor {
  static std::string get(const std::string& url) noexcept;
};

inline std::string get(const std::string& url) noexcept {
  return Kurlikor::get(url);
}

}  // namespace org::ttldtor::kurlikor
