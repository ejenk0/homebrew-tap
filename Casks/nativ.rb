cask "nativ" do
  version "0.3.3"
  sha256 "a24ac99708a2fab7d14d18197cfbe056339934a642421f890da2b229990f92fe"

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
