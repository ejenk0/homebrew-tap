cask "contextify" do
  version "1.8.4"
  sha256 "9057f6531a6987d20ca765504073ad9a1691dca5a3b6e421941a68c0e55de946"

  url "https://github.com/PeterPym/contextify/releases/download/v#{version}/Contextify.dmg"
  name "Contextify"
  desc "Searchable local archive of Claude Code and Codex sessions"
  homepage "https://contextify.sh/"

  livecheck do
    url "https://contextify.sh/appcast.xml"
    strategy :sparkle, &:short_version
  end

  auto_updates true
  depends_on arch: :arm64
  depends_on macos: :sequoia

  app "Contextify.app"

  uninstall quit: "sh.contextify.Contextify"

  # ~/.contextify holds the session archive database; zap removes it because
  # a zap is a full removal, but a plain uninstall leaves it intact.
  zap trash: [
    "~/.contextify",
    "~/Library/Application Support/Contextify",
    "~/Library/Caches/sh.contextify.Contextify",
    "~/Library/HTTPStorages/sh.contextify.Contextify",
    "~/Library/Preferences/sh.contextify.Contextify.plist",
    "~/Library/Saved Application State/sh.contextify.Contextify.savedState",
  ]
end
