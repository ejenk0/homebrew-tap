cask "contextify" do
  version "1.7.7"
  sha256 "6bceeb7eff5513ca98e90d619a8de1214a2e1510185ba5a9f7741ed1c2848496"

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
