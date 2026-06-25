# typed: false
# frozen_string_literal: true

class Forge < Formula
  desc "Open-source rules engine for the Magic: The Gathering card game"
  homepage "https://github.com/Card-Forge/forge"
  url "https://github.com/Card-Forge/forge/releases/download/forge-2.0.13/forge-installer-2.0.13.tar.bz2"
  sha256 "df23b237095cfc5ff97a4711946b25ff852da9ff43b916c40783f6b5a41ce855"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
    regex(/^forge[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "openjdk@21"

  def install
    # The release tarball is a self-contained portable directory: jars plus a
    # large read-only res/ asset tree. Forge resolves res/ relative to its
    # working directory, so the launchers below cd into libexec. User data and
    # caches are written to ~/Library/Application Support/Forge and
    # ~/Library/Caches/Forge (or ~/.forge on Linux), never into the keg.
    libexec.install Dir["*"] - Dir["*.exe", "*.cmd", "*.command", "*.sh", "*.bat"]

    java = "#{formula_opt_bin("openjdk@21")}/java"

    (bin/"forge").write <<~SH
      #!/bin/bash
      cd "#{libexec}" || exit 1
      exec "#{java}" -Xmx4096m \\
        -Dio.netty.tryReflectionSetAccessible=true -Dfile.encoding=UTF-8 \\
        -jar "#{libexec}/forge-gui-desktop-#{version}-jar-with-dependencies.jar" "$@"
    SH

    # Adventure mode needs the JPMS module opens that upstream's launcher passes.
    (bin/"forge-adventure").write <<~SH
      #!/bin/bash
      cd "#{libexec}" || exit 1
      exec "#{java}" -Xmx4096m \\
        --add-opens java.desktop/java.beans=ALL-UNNAMED \\
        --add-opens java.desktop/javax.swing.border=ALL-UNNAMED \\
        --add-opens java.desktop/javax.swing.event=ALL-UNNAMED \\
        --add-opens java.desktop/sun.swing=ALL-UNNAMED \\
        --add-opens java.desktop/java.awt.image=ALL-UNNAMED \\
        --add-opens java.desktop/java.awt.color=ALL-UNNAMED \\
        --add-opens java.desktop/sun.awt.image=ALL-UNNAMED \\
        --add-opens java.desktop/javax.swing=ALL-UNNAMED \\
        --add-opens java.desktop/java.awt=ALL-UNNAMED \\
        --add-opens java.base/java.util=ALL-UNNAMED \\
        --add-opens java.base/java.lang=ALL-UNNAMED \\
        --add-opens java.base/java.lang.reflect=ALL-UNNAMED \\
        --add-opens java.base/java.text=ALL-UNNAMED \\
        --add-opens java.desktop/java.awt.font=ALL-UNNAMED \\
        --add-opens java.base/jdk.internal.misc=ALL-UNNAMED \\
        --add-opens java.base/sun.nio.ch=ALL-UNNAMED \\
        --add-opens java.base/java.nio=ALL-UNNAMED \\
        --add-opens java.base/java.math=ALL-UNNAMED \\
        --add-opens java.base/java.util.concurrent=ALL-UNNAMED \\
        --add-opens java.base/java.net=ALL-UNNAMED \\
        -Dio.netty.tryReflectionSetAccessible=true -Dfile.encoding=UTF-8 \\
        -jar "#{libexec}/forge-gui-mobile-dev-#{version}-jar-with-dependencies.jar" "$@"
    SH
  end

  test do
    jar = libexec/"forge-gui-desktop-#{version}-jar-with-dependencies.jar"
    assert_path_exists jar
    # The desktop jar is a valid, runnable archive carrying the main class.
    assert_match "forge/view/Main",
      shell_output("#{formula_opt_bin("openjdk@21")}/jar tf #{jar}")
  end
end
