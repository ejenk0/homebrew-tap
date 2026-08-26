cask "nativ" do
  version "0.3.5"
  sha256 "30e3da070e3b229f33c8db8166d0dddc91fed55ed624cb2e89e1073f1849db9a"

  url "https://github.com/Blaizzy/nativ/releases/download/v#{version}/Nativ-#{version}.dmg"
  name "Nativ"
  desc "Local MLX inference workspace: chat, model library, and OpenAI-compatible server"
  homepage "https://github.com/Blaizzy/nativ"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on arch: :arm64
  depends_on macos: :tahoe

  app "Nativ.app"

  uninstall quit: "io.github.blaizzy.nativ"

  # Downloaded models live in the shared Hugging Face cache (~/.cache/huggingface)
  # and are deliberately left alone.
  zap trash: [
    "~/Library/Application Support/Nativ",
    "~/Library/Caches/io.github.blaizzy.nativ",
    "~/Library/HTTPStorages/io.github.blaizzy.nativ",
    "~/Library/Preferences/io.github.blaizzy.nativ.plist",
    "~/Library/Saved Application State/io.github.blaizzy.nativ.savedState",
  ]
end
