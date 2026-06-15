require_relative "../lib/blackmagic_download_strategy"

cask "davinci-resolve" do
  # version format: "<release>,<downloadId>"
  # downloadId comes from:
  #   curl -s https://www.blackmagicdesign.com/api/support/latest-stable-version/davinci-resolve/mac
  # When bumping, update both values together (same as updating version + sha256).
  version "20.3.2,80455587a3294e209846d7722f500906"
  sha256 "f8f8e32f67f29096ee172c67146d19e95368f4e37edda2594bba1bc378161eac"

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
