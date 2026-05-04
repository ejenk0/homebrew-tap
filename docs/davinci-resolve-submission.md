# Submitting davinci-resolve to homebrew-cask

## Current blockers

### 1. Custom download strategy
`BlackmagicDownloadStrategy` is a custom Ruby class — the official homebrew-cask repo
only allows built-in download strategy options. The class in `lib/` would need to be
removed entirely and replaced with built-in `url` parameters.

### 2. `url` is not a real URL
We pass the `downloadId` as the `url` value and replace it at download time. The `url`
field must be a real HTTP(S) URL for homebrew-cask audit to pass.

### 3. Fake registration data
We POST fabricated personal details to Blackmagic's API. Maintainers would likely push
back on ToS grounds. Worth checking Blackmagic's ToS to see if automated/programmatic
downloads are explicitly prohibited.

---

## Path to eligibility

### Rewrite using built-in `:post` strategy
The `segger-jlink` cask is accepted in homebrew-cask and uses a structurally identical
pattern — POST form data to accept a license and receive a download. Our cask could be
rewritten as:

```ruby
url "https://www.blackmagicdesign.com/api/register/us/download/#{version.csv.second}",
    using:      :post,
    user_agent: :fake,
    header:     ["Origin: https://www.blackmagicdesign.com",
                 "Referer: https://www.blackmagicdesign.com/support/download/77ef91f67a9e411bbbe299e595b4cfcc/Mac%20OS%20X"],
    cookies:    { "_ga" => "GA1.2.1849503966.1518103294", "_gid" => "GA1.2.953840595.1518103294" },
    data:       { "firstname" => "Homebrew", "lastname" => "Cask", ... }
```

This would eliminate the custom strategy class entirely.

### Things to verify before attempting this rewrite

- [ ] Does Homebrew's `CurlPostDownloadStrategy` follow a redirect? Blackmagic's API
      returns a plain-text signed CDN URL rather than serving the file directly, so the
      strategy would need to follow that URL. Test with `brew fetch --cask davinci-resolve`
      after rewriting.

- [ ] Does the `data:` hash support JSON body? Blackmagic expects
      `Content-Type: application/json`, not `application/x-www-form-urlencoded` (the
      default for POST). Check whether `:post` strategy can send a JSON body, or whether
      we'd need to pass it via `header:`.

- [ ] Check Blackmagic's Terms of Service for any clause prohibiting automated or
      programmatic downloads. If it's prohibited, maintainers will reject the PR.
      URL: https://www.blackmagicdesign.com/legal/termsofuse

- [ ] Confirm the `referId` (`77ef91f67a9e411bbbe299e595b4cfcc`) is stable and not
      version-specific. It appears to be a static page ID but this hasn't been verified.

- [ ] Verify the `livecheck` block returns the correct version string. The JSON response
      from `/api/support/latest-stable-version/davinci-resolve/mac` uses separate
      `major`, `minor`, `releaseNum` fields — confirm the assembled string matches the
      format used in `version`.

- [ ] Confirm the `uninstall` stanza is complete and correct by doing a full install +
      uninstall cycle and checking for leftover files/receipts.

---

## Other homebrew-cask requirements (already met)

- [x] sha256 checksum is hardcoded (not `:no_check`)
- [x] `depends_on macos:` is specified
- [x] `zap` stanza is present
- [x] `livecheck` block is present
- [x] Homepage is the official vendor page
- [x] `container type: :zip` correctly describes the download format
