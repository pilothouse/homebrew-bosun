cask "bosun" do
  # Both must match the SIGNED Bosun.dmg attached to the release, not a local build — a local one
  # hashes differently and every install then fails on the checksum. `release.sh` prints the sha256
  # when it finishes; otherwise take it from the release itself:
  #   shasum -a 256 <(curl -fsSL "$(gh release view v1.0.0 --repo pilothouse/bosun --json assets \
  #     --jq '.assets[]|select(.name=="Bosun.dmg").url')")
  version "1.1.0"
  sha256 "b1689e8978cb4c388ee13da6363dc10995d099f104b98ef6f4028cf888a17b5b"

  # The asset filename is not versioned, only the tag is. package-app.sh always writes "Bosun.dmg".
  url "https://github.com/pilothouse/bosun/releases/download/v#{version}/Bosun.dmg"
  name "Bosun"
  desc "Console for GitHub and coding agents"
  homepage "https://bosun.anvas.dev/"

  livecheck do
    url :url
    strategy :github_latest
  end

  # Bosun updates itself through Sparkle. Telling Homebrew that stops `brew upgrade` from fighting an
  # app that has already updated in place, and stops it reporting a version mismatch as an error.
  auto_updates true
  # Package.swift declares .macOS(.v13). In a cask this reads as "Ventura or newer".
  depends_on macos: :ventura
  # Apple Silicon only. release.yml builds on the runner's native arch and ships a single-slice
  # arm64 binary, so on an Intel Mac the app installs happily and then refuses to launch. Declaring
  # the constraint turns that into an install-time error that says why. Drop this line when the DMG
  # becomes universal (needs a zig cross-compile of libghostty).
  depends_on arch: :arm64

  app "Bosun.app"

  # Everything the app writes outside its own bundle. The Application Support directory is lowercase
  # "bosun" and holds connections.json, connections-sync.json, github-cache.json and avatars/.
  # The rest are keyed on the bundle identifier, dev.anvas.bosun.
  zap trash: [
    "~/Library/Application Support/bosun",
    "~/Library/Caches/Bosun",
    "~/Library/Caches/dev.anvas.bosun",
    "~/Library/HTTPStorages/dev.anvas.bosun",
    "~/Library/Preferences/dev.anvas.bosun.plist",
    "~/Library/Saved Application State/dev.anvas.bosun.savedState",
  ]
end
