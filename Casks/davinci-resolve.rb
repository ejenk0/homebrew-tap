require_relative "../lib/blackmagic_download_strategy"

cask "davinci-resolve" do
  # version format: "<release>,<downloadId>"
  # downloadId comes from:
  #   curl -s https://www.blackmagicdesign.com/api/support/latest-stable-version/davinci-resolve/mac
  # When bumping, update both values together (same as updating version + sha256).
  version "21.0.3,445d72f4f0154711b19e2b11c7d47f69"
  sha256 "192a1bc8f5116f834ff980151384050be6f73927ba91e15cc93b2429744c7d40"

  # The URL is the downloadId. BlackmagicDownloadStrategy POSTs to obtain a
  # short-lived signed CDN URL and downloads from it.
  url version.csv.second, using: BlackmagicDownloadStrategy
  name "DaVinci Resolve"
  desc "Professional video editing, color grading, VFX, and audio post-production"
  homepage "https://www.blackmagicdesign.com/products/davinciresolve"

  livecheck do
    url "https://www.blackmagicdesign.com/api/support/latest-stable-version/davinci-resolve/mac"
    strategy :json do |json|
      j = json["mac"]
      "#{j["major"]}.#{j["minor"]}.#{j["releaseNum"]}"
    end
  end

  depends_on macos: :sonoma
  # Download is a zip containing DaVinci_Resolve_<version>_Mac.dmg
  container type: :zip

  pkg "Install Resolve #{version.csv.first}.pkg"

  uninstall quit:    "com.blackmagic-design.davinciresolve",
            pkgutil: "com.blackmagicdesign.*",
            delete:  [
              "/Applications/DaVinci Resolve",
              "/Library/Application Support/Blackmagic Design/DaVinci Resolve",
            ]

  zap trash: [
    "~/Library/Application Support/Blackmagic Design/DaVinci Resolve",
    "~/Library/Caches/com.blackmagic-design.davinciresolve",
    "~/Library/Logs/Blackmagic Design",
    "~/Library/Preferences/com.blackmagic-design.davinciresolve.plist",
    "~/Movies/DaVinci Resolve",
  ]
end
