class Deadwax < Formula
  desc "Terminal music player for Navidrome and other Subsonic servers"
  homepage "https://github.com/voidrender/deadwax"
  url "https://github.com/voidrender/deadwax/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "a75915b88670806ffbbcd5eba2d257af7bfd67974f31a8edf92521884ea92693"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/voidrender/deadwax.git", branch: "main"

  depends_on "rust" => :build
  depends_on "mpv"

  def install
    system "cargo", "install", *std_cargo_args

    return unless OS.mac?

    # The notification helper. Deadwax finds it in libexec next to its
    # own executable.
    system "scripts/install-macos-notifier.sh", "--build-only"
    libexec.install "target/notifier/DeadwaxNotifier.app"
  end

  def caveats
    return unless OS.mac?

    <<~EOS
      The first track-change notification makes macOS ask whether
      DeadwaxNotifier may show notifications. Allow it to see album art
      notifications.
    EOS
  end

  test do
    assert_match "deadwax #{version}", shell_output("#{bin}/deadwax --version")
    return unless OS.mac?

    assert_path_exists libexec/"DeadwaxNotifier.app/Contents/MacOS/DeadwaxNotifier"
    system "codesign", "--verify", libexec/"DeadwaxNotifier.app"
  end
end
