# typed: false
# frozen_string_literal: true

# Pattern sourced from https://github.com/gromgit/homebrew-fuse
# See also: https://github.com/Homebrew/brew/issues/17326
# USAGE: `depends_on MacfuseRequirement`
class MacfuseRequirement < Requirement
  fatal true

  satisfy(build_env: false) { self.class.binary_osxfuse_installed? }

  def self.binary_osxfuse_installed?
    File.exist?("/usr/local/include/fuse.h") &&
      !File.symlink?("/usr/local/include")
  end

  env do
    ENV.append_path "PKG_CONFIG_PATH", HOMEBREW_LIBRARY/"Homebrew/os/mac/pkgconfig/fuse"
  end

  def message
    "This formula requires macFUSE. Please run `brew install --cask macfuse` first."
  end

  def display_s
    "macFUSE"
  end
end

class Formula
  def need_alt_fuse?
    HOMEBREW_PREFIX.to_s != "/usr/local"
  end

  def alt_fuse_root
    buildpath/"temp"
  end

  def setup_fuse_includes
    mkdir "#{alt_fuse_root}/include" do
      Dir["/usr/local/include/fuse*"].each { |f| cp_r f, "." }
    end
  end

  def setup_fuse_libs
    mkdir "#{alt_fuse_root}/lib" do
      Dir["/usr/local/lib/*fuse*"].each { |f| cp_r f, "." }
    end
  end

  def setup_fuse_pkgconfig
    mkdir "#{alt_fuse_root}/lib/pkgconfig" do
      cp "/usr/local/lib/pkgconfig/fuse.pc", "."
      inreplace "fuse.pc", "/usr/local", alt_fuse_root.to_s
    end
    ENV.prepend_path "PKG_CONFIG_PATH", "#{alt_fuse_root}/lib/pkgconfig"
  end

  def setup_fuse_env
    setup_fuse_includes
    setup_fuse_libs
    setup_fuse_pkgconfig
  end

  def setup_fuse_flags
    ENV.append "CFLAGS",   "-I#{alt_fuse_root}/include -I#{alt_fuse_root}/include/fuse -D_USE_FILE_OFFSET_BITS=64"
    ENV.append "CPPFLAGS", "-I#{alt_fuse_root}/include -I#{alt_fuse_root}/include/fuse -D_USE_FILE_OFFSET_BITS=64"
    ENV.append "LDFLAGS",  "-L#{alt_fuse_root}/lib"
  end

  def setup_fuse
    return unless need_alt_fuse?

    setup_fuse_env
    setup_fuse_flags
  end
end
