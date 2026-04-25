# Neovim Config

## 日本語

AstroNvim v6 をベースにした個人用 Neovim 設定です。`lazy.nvim` でプラグインを管理し、普段の編集で必要な基本設定、ファイルツリー、Markdown preview、Rust 開発支援をすぐ使えるようにしています。

### 特徴

- AstroNvim v6 ベースの軽量な構成
- `lazy.nvim` によるプラグイン管理
- Leader キーは Space、LocalLeader キーは `,`
- 行番号、相対行番号、2 スペースインデント、システムクリップボード連携
- InsertLeave / FocusLost での自動保存
- 保存前に CRLF を除去し、`fileformat=unix` に統一
- `jj` で Insert mode から Normal mode へ戻る
- Terminal mode からの移動をしやすくするキーマップ
- `markdown-preview.nvim` による Markdown preview
- `knap` と外部 viewer による PDF / Markdown / LaTeX / Typst の PDF preview
- `rustaceanvim` による Rust 開発支援
  - Rust では入力異常回避のため codelens を無効化
- `zenhan` がある環境では Insert / Cmdline を抜けたときに IME をオフ

### 必要なもの

- Neovim 0.10 以上
- Git
- Nerd Font 推奨
- Node.js / npm
  - `markdown-preview.nvim` の初回ビルドに使います
- PDF preview 用のコマンド
  - PDF ビューア: `sioyek`, `zathura`, `okular`, `evince`, `xdg-open` のいずれか
  - Markdown: `pandoc`
  - LaTeX: `latexmk` 推奨、なければ `pdflatex`
  - Typst: `typst`
- Rust ツールチェーン
  - Rust 開発をする場合に使います
- `zenhan`
  - WSL などで IME 自動オフを使いたい場合のみ任意で入れてください

### インストール

既存の Neovim 設定がある場合は、先に退避します。

```sh
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak
mv ~/.local/state/nvim ~/.local/state/nvim.bak
mv ~/.cache/nvim ~/.cache/nvim.bak
```

このリポジトリを `~/.config/nvim` に配置します。

```sh
git clone <repository-url> ~/.config/nvim
nvim
```

初回起動時に `lazy.nvim` と必要なプラグインが自動でセットアップされます。

### よく使うキーマップ

| キー | 動作 |
| --- | --- |
| `<leader>ev` | `init.lua` を開く |
| `<leader>sv` | `init.lua` を再読み込み |
| `<leader>t` | Neo-tree をトグル |
| `<C-m>` | Neo-tree で現在のファイルを表示 |
| `<leader>b` | Neo-tree の buffer 一覧を float 表示 |
| `jj` | Insert mode から Normal mode へ戻る |
| Terminal mode `<Esc>` | Terminal mode から抜ける |
| Terminal mode `<C-h/j/k/l>` | Terminal mode から window 移動 |
| `<leader>mp` | Markdown preview を開く |
| `<leader>pp` | PDF を開く / PDF live preview を開始・停止 |
| `<leader>po` | PDF を開く / PDF を 1 回だけ生成して開く |
| `<leader>pc` | PDF preview の viewer を閉じる |
| `<leader>pj` | 対応 viewer で PDF 側を現在行へジャンプ |

PDF preview は PDF (`.pdf`), Markdown (`.md`), LaTeX (`.tex`), Typst (`.typ`) で使えます。PDF ファイルでは `<leader>pp`, `<leader>po`, `:PdfOpen` のいずれかで外部 PDF viewer を起動します。Markdown / LaTeX / Typst では `<leader>pp` で保存や編集に合わせて PDF を再生成し、外部 PDF viewer で表示します。1 回だけ確認したい場合は `<leader>po` を使ってください。

同じ操作はコマンドからも実行できます。

```vim
:PdfOpen
:PdfPreviewToggle
:PdfPreviewOnce
:PdfPreviewClose
:PdfPreviewJump
```

### 構成

```text
.
├── init.lua                    # Neovim の基本設定とキーマップ
├── lazy-lock.json              # lazy.nvim のロックファイル
├── lua/
│   ├── lazy_setup.lua          # AstroNvim / lazy.nvim のセットアップ
│   ├── community.lua           # AstroCommunity 用の入口
│   ├── polish.lua              # 最後に実行する追加設定用
│   └── plugins/
│       ├── markdown-preview.lua
│       ├── pdf-preview.lua
│       ├── rust.lua
│       └── *.lua               # AstroNvim の設定例、必要に応じて有効化
├── selene.toml                 # Lua lint 設定
└── neovim.yml                  # Selene 用 globals 設定
```

`lua/plugins/*.lua` の一部は AstroNvim テンプレート由来のサンプルで、先頭の `if true then return {} end` により無効化されています。使う場合はその行を外してから編集してください。

### メンテナンス

プラグインの確認や更新は Neovim 内で行います。

```vim
:Lazy
:Lazy update
```

問題が起きた場合は、まず `:Lazy health` と `:checkhealth` を確認してください。

---

## English

Personal Neovim configuration based on AstroNvim v6. Plugins are managed by `lazy.nvim`, with practical defaults for day-to-day editing, file navigation, Markdown preview, and Rust development.

### Features

- Lightweight AstroNvim v6 based setup
- Plugin management with `lazy.nvim`
- Space as Leader and `,` as LocalLeader
- Line numbers, relative line numbers, 2-space indentation, and system clipboard integration
- Autosave on InsertLeave / FocusLost
- CRLF cleanup before write, with `fileformat=unix`
- `jj` to leave Insert mode
- Terminal mode mappings for easy window navigation
- Markdown preview via `markdown-preview.nvim`
- PDF preview for PDF, Markdown, LaTeX, and Typst via `knap` and an external viewer
- Rust support via `rustaceanvim`
  - Rust codelens is disabled to avoid input corruption in this environment
- Optional `zenhan` integration to turn IME off when leaving Insert / Cmdline mode

### Requirements

- Neovim 0.10 or newer
- Git
- Nerd Font recommended
- Node.js / npm
  - Used by the initial `markdown-preview.nvim` build
- Commands for PDF preview
  - PDF viewer: one of `sioyek`, `zathura`, `okular`, `evince`, or `xdg-open`
  - Markdown: `pandoc`
  - LaTeX: `latexmk` recommended, falling back to `pdflatex`
  - Typst: `typst`
- Rust toolchain
  - Needed for Rust development
- `zenhan`
  - Optional, only for IME auto-off behavior in environments such as WSL

### Installation

Back up any existing Neovim configuration first.

```sh
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak
mv ~/.local/state/nvim ~/.local/state/nvim.bak
mv ~/.cache/nvim ~/.cache/nvim.bak
```

Clone this repository into `~/.config/nvim`.

```sh
git clone <repository-url> ~/.config/nvim
nvim
```

On first launch, `lazy.nvim` and the configured plugins will be installed automatically.

### Keymaps

| Key | Action |
| --- | --- |
| `<leader>ev` | Open `init.lua` |
| `<leader>sv` | Source `init.lua` |
| `<leader>t` | Toggle Neo-tree |
| `<C-m>` | Reveal current file in Neo-tree |
| `<leader>b` | Open Neo-tree buffer list in a floating window |
| `jj` | Leave Insert mode |
| Terminal mode `<Esc>` | Leave Terminal mode |
| Terminal mode `<C-h/j/k/l>` | Move between windows from Terminal mode |
| `<leader>mp` | Open Markdown preview |
| `<leader>pp` | Open a PDF or toggle live PDF preview |
| `<leader>po` | Open a PDF or build one once |
| `<leader>pc` | Close the PDF preview viewer |
| `<leader>pj` | Jump the PDF viewer to the current line when supported |

PDF preview works for PDF (`.pdf`), Markdown (`.md`), LaTeX (`.tex`), and Typst (`.typ`) files. In a PDF file, use `<leader>pp`, `<leader>po`, or `:PdfOpen` to launch an external PDF viewer. In Markdown / LaTeX / Typst files, press `<leader>pp` to generate the PDF and keep it updated in an external PDF viewer. Use `<leader>po` when you only want a one-shot preview.

The same actions are available as commands.

```vim
:PdfOpen
:PdfPreviewToggle
:PdfPreviewOnce
:PdfPreviewClose
:PdfPreviewJump
```

### Structure

```text
.
├── init.lua                    # Core Neovim options and keymaps
├── lazy-lock.json              # lazy.nvim lockfile
├── lua/
│   ├── lazy_setup.lua          # AstroNvim / lazy.nvim setup
│   ├── community.lua           # AstroCommunity entry point
│   ├── polish.lua              # Final optional Lua customizations
│   └── plugins/
│       ├── markdown-preview.lua
│       ├── pdf-preview.lua
│       ├── rust.lua
│       └── *.lua               # AstroNvim examples, enable as needed
├── selene.toml                 # Lua lint configuration
└── neovim.yml                  # Selene globals configuration
```

Some files under `lua/plugins/*.lua` are disabled AstroNvim template examples. They start with `if true then return {} end`; remove that line before editing if you want to use them.

### Maintenance

Manage and update plugins from inside Neovim.

```vim
:Lazy
:Lazy update
```

If something breaks, start with `:Lazy health` and `:checkhealth`.
