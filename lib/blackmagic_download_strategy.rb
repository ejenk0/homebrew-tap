# typed: true
# frozen_string_literal: true

require "download_strategy"

# Downloads files from Blackmagic Design's undocumented registration API.
#
# The URL field in the cask should be the downloadId (an opaque token from
# Blackmagic's catalog API). This strategy POSTs fake registration data to
# obtain a short-lived signed CDN URL, then downloads from it.
#
# Usage in a cask:
#   url "80455587a3294e209846d7722f500906", using: BlackmagicDownloadStrategy
class BlackmagicDownloadStrategy < CurlDownloadStrategy
  def fetch(timeout: nil)
    @url = resolve_signed_url
    super
  end

  private

  def resolve_signed_url
    ohai "Fetching Blackmagic Design signed download URL..."

    result = curl_output(
      "--request", "POST",
      "--header", "Content-Type: application/json;charset=UTF-8",
      "--header", "Accept: application/json, text/plain, */*",
      "--header", "Origin: https://www.blackmagicdesign.com",
      "--header", "Referer: https://www.blackmagicdesign.com/support/download/77ef91f67a9e411bbbe299e595b4cfcc/Mac%20OS%20X",
      "--header", "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) " \
                  "AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
      "--header", "Cookie: _ga=GA1.2.1849503966.1518103294; _gid=GA1.2.953840595.1518103294",
      "--data", JSON.generate(
                  firstname: "Homebrew",
                  lastname:  "Cask",
                  email:     "brew@example.com",
                  phone:     "202-555-0194",
                  country:   "us",
                  state:     "California",
                  city:      "San Francisco",
                  street:    "1 Infinite Loop",
                  product:   "DaVinci Resolve",
                ),
      "https://www.blackmagicdesign.com/api/register/us/download/#{@url}"
    )

    signed_url = result.stdout.strip
    if signed_url.empty? || !signed_url.start_with?("http")
      raise CurlDownloadStrategyError,
            "Failed to obtain Blackmagic download URL"
    end

    signed_url
  end
end
