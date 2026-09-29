class Arapuca < Formula
  desc "Cross-platform process sandbox with kernel-enforced isolation"
  homepage "https://github.com/LeGambiArt/arapuca"
  url "https://github.com/LeGambiArt/arapuca/archive/refs/tags/v0.2.8.tar.gz"
  sha256 "8a57224530389e125b07a6cb4cb996f9e7224d3a048e91da8f17fb93472445f0"
  license "Apache-2.0"
  head "https://github.com/LeGambiArt/arapuca.git", branch: "main"

  depends_on "cbindgen" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    system "cargo", "build", "--release", "--lib"

    system "cbindgen", "--config", "cbindgen.toml",
           "--crate", "arapuca", "--output", "include/arapuca.h"

    if OS.mac?
      lib.install "target/release/libarapuca.dylib"
    elsif OS.linux?
      lib.install "target/release/libarapuca.so"
    end

    lib.install "target/release/libarapuca.a"
    include.install "include/arapuca.h"

    (lib/"pkgconfig").mkpath
    pc_content = File.read("arapuca.pc.in")
                     .gsub("@PREFIX@", prefix)
                     .gsub("@LIBDIR@", lib)
                     .gsub("@VERSION@", version)
                     .gsub("@NATIVE_LIBS@", "-ldl -lpthread")
                     .gsub("@INSTALL_FEATURES@", "")
    (lib/"pkgconfig/arapuca.pc").write pc_content
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/arapuca --version 2>&1", 1)

    output = shell_output("#{bin}/arapuca -- echo 'Hello from sandbox'")
    assert_match "Hello from sandbox", output

    assert_path_exists include/"arapuca.h"

    if OS.mac?
      assert_path_exists lib/"libarapuca.dylib"
    elsif OS.linux?
      assert_path_exists lib/"libarapuca.so"
    end
  end
end
