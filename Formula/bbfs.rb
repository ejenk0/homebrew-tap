class Bbfs < Formula
  desc "Filesystem driver that mounts Blackboard course contents as local files"
  homepage "https://github.com/BlackboardFS/bbfs"
  license "MIT"
  head "https://github.com/BlackboardFS/bbfs.git", branch: "main"

  depends_on "rust" => :build

  on_macos do
    depends_on cask: "macfuse"
  end

  on_linux do
    depends_on "gtk+3"
    depends_on "webkit2gtk"
    depends_on "libfuse"
  end

  def install
    system "cargo", "install",
      "--locked",
      "--root", prefix,
      "--path", "bbfs-cli"
  end

  test do
    assert_match "mount BlackboardFS", shell_output("#{bin}/bbfs --help")
  end
end
