# homebrew-bosun

Homebrew tap for [Bosun](https://github.com/pilothouse/bosun), a macOS console for GitHub and coding
agents.

## Install

```bash
brew tap pilothouse/bosun
brew trust pilothouse/bosun
brew install --cask bosun
```

Or in one line, without tapping first:

```bash
brew install --cask pilothouse/bosun/bosun
```

Note the three parts in that second form. `pilothouse/bosun` on its own is the name of the tap, not
something you can install, so `brew install pilothouse/bosun` will not work.

### About the trust step

Recent versions of Homebrew refuse to load anything from a third-party tap until you say you trust
it. Without it you get:

```
Error: Refusing to load cask pilothouse/bosun/bosun from untrusted tap pilothouse/bosun.
```

This is Homebrew asking whether you trust code from outside its official repositories, which is a
fair question to ask about any tap, including this one. `brew trust pilothouse/bosun` answers it once
for the whole tap.

## Uninstall

```bash
brew uninstall --cask bosun
```

To remove settings, cached data and saved connections as well:

```bash
brew zap --cask bosun
```

## Updating the cask on a new release

Bosun is signed and notarized by hand. Full process is in
[bosun-docs](https://github.com/pilothouse/bosun-docs/blob/main/docs/release.md). Once a release is
published, update this tap:

1. Get the version and the sha256. `scripts/sign-release.sh` in bosun-docs prints the sha256 when it
   finishes. To work it out from a published release instead:

   ```bash
   shasum -a 256 Bosun.dmg
   ```

2. Edit `Casks/bosun.rb` and set `version` and `sha256`. Nothing else normally changes, because the
   download URL is built from the version.

3. Check it before pushing:

   ```bash
   brew audit --cask --online pilothouse/bosun/bosun
   brew install --cask pilothouse/bosun/bosun
   ```

Make sure the sha256 matches the artifact that is actually attached to the published release. If you
take it from a local build instead, it will not match what users download, and every install will
fail with a checksum error.

## Why the app still updates itself

The cask sets `auto_updates true` because Bosun updates through Sparkle. Homebrew installs it and
then leaves version bumps alone, so the two do not fight over the same app.
