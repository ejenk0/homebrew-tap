cask "qbittorrent" do
  version "5.2.2"
  sha256 "4d6eec9ffd932cd64d35d3fa3df85932bf397457461a69cebcde6d5b737ae5e4"

  url "https://downloads.sourceforge.net/qbittorrent/qbittorrent-mac/qbittorrent-#{version}/qbittorrent-#{version}.dmg",
      verified: "downloads.sourceforge.net/qbittorrent/qbittorrent-mac/"
  name "qBittorrent"
  desc "Peer to peer Bittorrent client"
  homepage "https://www.qbittorrent.org/"

  # Ported from Homebrew/homebrew-cask, which is disabling this cask on
  # 2026-09-01 because qBittorrent's macOS builds are self-signed rather than
  # notarised and so fail Gatekeeper. The app still installs and runs; macOS
  # blocks it on first launch until approved via
  # System Settings -> Privacy & Security -> Open Anyway.
  livecheck do
    url "https://sourceforge.net/projects/qbittorrent/rss?path=/qbittorrent-mac"
    regex(%r{url=.*?/qbittorrent[._-]v?(\d+(?:\.\d+)+)\.dmg}i)
  end

  depends_on macos: :ventura

  app "qbittorrent.app", target: "qBittorrent.app"

  zap trash: [
    "~/.config/qBittorrent",
    "~/Library/Application Support/qBittorrent",
    "~/Library/Caches/qBittorrent",
    "~/Library/Preferences/org.qbittorrent.qBittorrent.plist",
    "~/Library/Preferences/qBittorrent",
    "~/Library/Saved Application State/org.qbittorrent.qBittorrent.savedState",
  ]
end
