cask "nativ" do
  version "0.1.0"
  sha256 "900a069202458d963f26949b05e1a00a1509b360a7339449ae293de28e5d17a3"

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
