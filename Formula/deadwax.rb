class Deadwax < Formula
  desc "Terminal music player for Navidrome and other Subsonic servers"
  homepage "https://github.com/voidrender/deadwax"
  url "https://github.com/voidrender/deadwax/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "d631115e71e7066f692880fad6ad6da51c86433e8320172b4bb8b304dac183b0"
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
