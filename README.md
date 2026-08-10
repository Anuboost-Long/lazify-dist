<div align="center">

<img src="assets/logo.png" alt="Lazify" width="148">

<h1>Lazify</h1>

<p><strong>Build, run, and review — all in one desktop workspace.</strong></p>

<p>
One command center for your projects, coding agents, terminals,<br>
live previews, templates, and local development tools.
</p>

<p>
<img src="https://img.shields.io/badge/macOS-12.0%2B-7C5CD6?style=for-the-badge&logo=apple&logoColor=white" alt="macOS 12.0+">
<img src="https://img.shields.io/badge/Windows-10%20%2F%2011-4CC9F0?style=for-the-badge&logo=windows&logoColor=white" alt="Windows 10/11">
<img src="https://img.shields.io/badge/Apple%20Silicon-%2B%20Intel-FF7A45?style=for-the-badge" alt="Apple Silicon and Intel">
<a href="https://github.com/Anuboost-Long/lazify-dist/releases"><img src="https://img.shields.io/badge/Download-Latest%20Release-FFB347?style=for-the-badge&logo=github&logoColor=white" alt="Download"></a>
</p>

</div>

---

## ⚡ Install

### macOS

One line in Terminal:

```bash
curl -fsSL https://raw.githubusercontent.com/Anuboost-Long/lazify-dist/main/install.sh | bash
```

Then launch it:

```bash
open -a Lazify
```

That's it. The installer picks the build that matches your Mac, checks the
download, installs to `/Applications`, and clears the quarantine flag so macOS
opens it without a fuss.

<details>
<summary><b>Install somewhere else</b></summary>

<br>

```bash
INSTALL_DIR="$HOME/Applications" bash -c "$(curl -fsSL https://raw.githubusercontent.com/Anuboost-Long/lazify-dist/main/install.sh)"
```

</details>

<details>
<summary><b>Prefer the disk image?</b></summary>

<br>

Lazify ships a separate build per architecture — pick the one for your Mac:

| Your Mac | Download |
|---|---|
| Apple Silicon (M1 and later) | `Lazify-arm64.dmg` |
| Intel | `Lazify-x64.dmg` |

> Not sure? Run `uname -m` — `arm64` means Apple Silicon, `x86_64` means Intel.

1. Download it from [Releases](https://github.com/Anuboost-Long/lazify-dist/releases).
2. Open it and drag **Lazify** onto the **Applications** shortcut.
3. Clear the quarantine flag — **this step is not optional**:

   ```bash
   xattr -dr com.apple.quarantine /Applications/Lazify.app
   ```

4. Open Lazify from Applications.

</details>

### Windows

> **Not out yet.** The Windows installer is built on Windows for its native
> terminal module, so it follows shortly behind the macOS release. Watch
> [Releases](https://github.com/Anuboost-Long/lazify-dist/releases) for it.

When it lands:

1. Download `Lazify Setup <version>.exe` from [Releases](https://github.com/Anuboost-Long/lazify-dist/releases).
2. Run it. No admin rights needed — it installs to your user profile.
3. Windows SmartScreen will likely warn about an unrecognised publisher the
   first time — see [below](#️-if-windows-says-the-publisher-is-unknown) for why
   that's expected.

---

## ✨ What it does

<table>
<tr>
<td width="50%" valign="top">

### 🤖 Agents where your code lives

Run Codex, Claude, or your own CLI agent inside the project it is changing.
Conversations, files, diffs, and token usage stay in one place.

</td>
<td width="50%" valign="top">

### ▶️ Run and preview without leaving

Launch your dev script, detect its local port, and inspect the result beside
the agent doing the work.

</td>
</tr>
<tr>
<td width="50%" valign="top">

### 🔍 Review every change with context

Read files, inspect session diffs, switch branches, and understand what changed
before anything ships.

</td>
<td width="50%" valign="top">

### 🧰 Your local toolchain, visible

Runtimes, package managers, dependencies, and open ports — surfaced instead of
guessed at.

</td>
</tr>
</table>

---

## 🚀 First run

| | |
|:--:|---|
| **1** | **Open Lazify.** The workspace opens on your projects. |
| **2** | **Add a project** — import an existing folder, or scaffold a new one from a template. |
| **3** | **Start an agent** in that project, or run a script from the workspace. |
| **4** | **Watch it work** — the editor, diffs, and live preview sit beside the terminal. |

---

## 🔄 Updates

Lazify checks for updates from this repository. Open **Settings → About →
Updates** to check, download, and install — the download shows progress, and
nothing restarts until you say so.

> On macOS, in-app installing requires a Developer ID signature, which this
> build does not yet carry. Until then, re-run the install command above to
> move to a new version. Windows updates in place.

---

## ⚠️ If macOS says the app is "damaged"

> **"Lazify" is damaged and can't be opened. You should move it to the Trash.**

**Your download is fine.** Nothing is corrupted.

Lazify is signed ad-hoc rather than with a paid Apple Developer ID certificate.
macOS marks anything arriving through a browser with a quarantine attribute, and
for an ad-hoc signed app it reports that as damage instead of the usual
"unidentified developer" prompt. Clearing the flag fixes it:

```bash
xattr -dr com.apple.quarantine /Applications/Lazify.app
```

> 💡 The one-line installer does this for you — which is exactly why it's the
> recommended route.

## ⚠️ If Windows says the publisher is unknown

> **Windows protected your PC — Microsoft Defender SmartScreen prevented an
> unrecognised app from starting.**

**Your download is fine.** Lazify isn't yet signed with a paid code-signing
certificate, so Windows has no publisher identity to vouch for. Click **More
info**, then **Run anyway**. This is the same trust gap the macOS build
documents above — just Windows' version of the warning.

---

## 📋 Requirements

| | macOS | Windows |
|---|---|---|
| **OS version** | 12.0 Monterey or later | Windows 10 or later, and 11 |
| **Architecture** | Apple Silicon or Intel — a separate build for each | x64 |

---

<div align="center">

<img src="assets/logo.png" alt="" width="52">

<sub>This repository hosts the releases and the installer.<br>
Lazify is not open source — the source is kept in a private repository.</sub>

</div>
