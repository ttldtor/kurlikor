// Copyright (c) 2024 ttldtor.
// SPDX-License-Identifier: BSL-1.0

#ifdef WIN32
#  if !defined(_WIN32_WINNT)
#    define _WIN32_WINNT 0x0601
#  endif
#endif

#include <boost/asio/connect.hpp>
#include <boost/asio/ip/tcp.hpp>
#include <boost/beast/core.hpp>
#include <boost/beast/http.hpp>
#include <boost/beast/version.hpp>
#include <boost/url.hpp>
#include <cstdlib>
#include <iostream>
#include <kurlikor.hpp>
#include <string>

namespace b = boost;
namespace bb = boost::beast;
namespace http = bb::http;
namespace asio = b::asio;
using tcp = asio::ip::tcp;

namespace org::ttldtor::kurlikor {

std::string Kurlikor::get(const std::string& url) noexcept {
  try {
    auto result = b::urls::parse_uri(url);

    if (!result) {
      return "error: parse URI error";
    }

    std::string host = result->host();

    std::string port = "80";

    if (result->has_port()) {
      port = result->port();
    } else if (result->has_scheme() && result->scheme_id() == b::urls::scheme::https) {
      port = "443";
    }

    std::string path = result->path();

    if (path.empty()) {
      path = "/";
    }

    // The io_context is required for all I/O
    asio::io_context ioc;

    // These objects perform our I/O
    tcp::resolver resolver(ioc);
    bb::tcp_stream stream(ioc);

    // Look up the domain name
    auto const results = resolver.resolve(result->host(), port);

    // Make the connection on the IP address we get from a lookup
    stream.connect(results);

    // Set up an HTTP GET request message
    http::request<http::string_body> req{http::verb::get, path, 11};
    req.set(http::field::host, host);
    req.set(http::field::user_agent, BOOST_BEAST_VERSION_STRING);

    // Send the HTTP request to the remote host
    http::write(stream, req);

    // This buffer is used for reading and must be persisted
    bb::flat_buffer buffer;

    // Declare a container to hold the response
    http::response<http::dynamic_body> res;

    // Receive the HTTP response
    http::read(stream, buffer, res);

    if (res.result_int() != 200) {
      return "error: status code is " + std::to_string(res.result_int());
    }

    // Gracefully close the socket
    bb::error_code ec;
    auto r = stream.socket().shutdown(tcp::socket::shutdown_both, ec);

    // not_connected happens sometimes
    // so don't bother reporting it.
    //
    if (ec && ec != bb::errc::not_connected) {
      // throw bb::system_error{ec};
      return "error: shutdown error, error code: " + ec.to_string();
    }
    // If we get here then the connection is closed gracefully
    return boost::beast::buffers_to_string(res.body().data());
  } catch (const std::exception& e) {
    return std::string("error: e: ") + e.what();
  }
}

}  // namespace org::ttldtor::kurlikor
