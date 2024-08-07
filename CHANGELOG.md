# Changelog

## 2024-08-07

- Merge branch 'master' of github.com:harperreed/dotfiles (by [Harper Reed](mailto:harper@nata2.org), 577b99f)
- Merge branch 'master' of github.com:harperreed/dotfiles (by [Harper Reed](mailto:harper@nata2.org), 613acb0)
- - Deleted various outdated scripts from `.config/bin` 🌪   - Files include:     - `.md`     - `adhocttp.go`     - `brightness`     - `cloudapp`     - `convert_markdown_mobi.sh`     - `dot`     - `dotfile-status.sh`     - `drop_ip.sh`     - `generate_csr`     - `get_zip.php`     - `git-rank-contributers`     - `gitio`     - `httpd`     - `imagesnap`     - `imgcat`     - `movieme`     - `mustacheme`     - `read2text`     - `screenshot.sh`     - `set-defaults`     - `set-defaults.sh`     - `speed_curl.sh`     - `thisweek`     - `whereami`     - `xmppipe.pl`     - `yt` (by [Harper Reed](mailto:harper@nata2.org), 9a02596)
- Merge branch 'master' of github.com:harperreed/dotfiles (by [Harper Reed](mailto:harper@nata2.org), 9553ccd)
- Merge branch 'master' of github.com:harperreed/dotfiles (by [Harper Reed](mailto:harper@nata2.org), d29c816)
- 🐟🎉 Revamped Fish Shell Config for Mac! 🎉🐟 (by [Harper Reed](mailto:harper@nata2.org), 40b2295)
- Merge branch 'master' of github.com:harperreed/dotfiles (by [Harper Reed](mailto:harper@nata2.org), 94c72d9)
- Added rainbow magic to SSH connection messages 🌈✨ (by [Harper Reed](mailto:harper@nata2.org), 394f26a)
- Merge branch 'master' of github.com:harperreed/dotfiles (by [Harper Reed](mailto:harper@nata2.org), 73b29e5)
- Merge branch 'master' of github.com:harperreed/dotfiles (by [Harper Reed](mailto:harper@nata2.org), 1ddf867)
- Update config.fish (by [Harper Reed](mailto:harper@nata2.org), 6511df7)
- Merge branch 'master' of github.com:harperreed/dotfiles (by [Harper Reed](mailto:harper@nata2.org), d094c11)
- Merge branch 'master' of github.com:harperreed/dotfiles (by [Harper Reed](mailto:harper@nata2.org), 7dbc141)
- Merge branch 'master' of github.com:harperreed/dotfiles (by [Harper Reed](mailto:harper@nata2.org), ee4f36b)
- Summary of changes - `.config/fish/config.fish` updated SSH key loading logic 🚀🔑🔥 - SSH keys now added based on connection type: interactive SSH, non-interactive SSH, or physical terminal 💻🔐 - Added echo statements to provide feedback on connection type 📣 - Removed redundant key-adding function at the bottom of the file (cleanup) 🧹🔧 (by [Harper Reed](mailto:harper@nata2.org), 2a80386)
- Merge branch 'master' of github.com:harperreed/dotfiles (by [Harper Reed](mailto:harper@nata2.org), 0a89f08)
- SSH key updates 🗝️🔐💥 - Updated `.ssh/id_ed25519.pub` comment to include new user details and metadata. Changed from `harper@DARKNESS.local` to `harper@modest.com (08-07-2024) [ed25519]`. 🎉 - Updated `.ssh/id_rsa.pub` comment to reflect the same new user details and metadata. Changed from `harper@Harpers-Mac-mini.local` to `harper@modest.com (08-07-2024) [rsa]`. 🚀 (by [Harper Reed](mailto:harper@nata2.org), f3458dc)

## 2024-08-06

- Merge branch 'master' of github.com:harperreed/dotfiles (by [Harper Reed](mailto:harper@nata2.org), d6f4fad)
- Merge branch 'master' of github.com:harperreed/dotfiles (by [Harper Reed](mailto:harper@nata2.org), 2a09a6a)
- 🎉 Config Overhaul Bonanza 🎉 (by [Harper Reed](mailto:harper@nata2.org), 1af52df)
- Merge branch 'master' of github.com:harperreed/dotfiles (by [Harper Reed](mailto:harper@nata2.org), a815ddd)
- Update config.fish (by [Harper Reed](mailto:harper@nata2.org), ff84696)
- Merge branch 'master' of github.com:harperreed/dotfiles (by [Harper Reed](mailto:harper@nata2.org), 3544ca3)
- Add custom greeting for Darwin platform 🌍😄 (by [Harper Reed](mailto:harper@nata2.org), 5e16cda)

## 2024-08-04

- Merge branch 'master' of github.com:harperreed/dotfiles (by [Harper Reed](mailto:harper@nata2.org), 3f908bf)
- Merge branch 'master' of github.com:harperreed/dotfiles (by [Harper Reed](mailto:harper@nata2.org), a0c2451)
- Merge branch 'master' of github.com:harperreed/dotfiles (by [Harper Reed](mailto:harper@nata2.org), 5ef054c)
- Merge branch 'master' of github.com:harperreed/dotfiles (by [Harper Reed](mailto:harper@nata2.org), 6a91c13)
- Deleting orbsack stuff from SSH config file. 🌍🚀 (by [Harper Reed](mailto:harper@nata2.org), 01b75d1)
- Make ForwardAgent less of a paranoid mess! 🤖 ➡️ 🚀 (Trust us, it's for the best!) (by [Harper Reed](mailto:harper@nata2.org), 1c3c5b3)
- Updated vdirsyncer config for GMail integration 🎉✉️ (by [Harper Reed](mailto:harper@nata2.org), aa6f38e)

## 2024-08-02

- Add iCloud and Google Contacts configuration files 🎉🎈 (by [Harper Reed](mailto:harper@nata2.org), a2e852b)

## 2024-07-28

- Summary of changes - `.config/iterm2/com.googlecode.iterm2.plist`: Added keys `AboutToPasteTabsWithCancel` and `AboutToPasteTabsWithCancel_selection` to enable a warning when pasting tabs, preventing unintentional pasting of sensitive info. 😂✂️🚫 - `.config/mise/config.toml`: Introduced `[tools]` section with `usage = "latest"` to always use the latest tools. 🛠️🔄 Updated various scripts to improve the management and generation of documentation using `repo2txt` and `llm` tools. 📄🚀 - `Library/Application Support/io.datasette.llm/templates/readme-gen.yaml`: Enhanced the readme generation template to ensure the README follows a specific structure and is thorough. 🎨📝 Improved instructions for generating documentation including emojis and a specific order format. 🎉👍 (by [Harper Reed](mailto:harper@nata2.org), 26751eb)

## 2024-07-24

- added darker (by [Harper Reed](mailto:harper@nata2.org), dc07593)
- added window (by [Harper Reed](mailto:harper@nata2.org), 8295de7)

## 2024-07-23

- 🎉 Woot! Time to get our theme on! 🎨🌈 (by [Harper Reed](mailto:harper@nata2.org), 4bab6c0)
- 🎊 Summary of changes 🎊 - Huuuuge update to the iTerm2 config plist file 🤯 - Looks like it includes a bunch of new color presets and profiles and shit 🌈 - More window arrangements too, for all your terminal multitasking needs 🖥️💻 - Cranked the blur radius up to fuckin' 11 for maximum eye strain 😵 - Customized the status bar with all kinds of system stats and emojis out the wazoo 🔋💻📶🕑📂💼 (by [Harper Reed](mailto:harper@nata2.org), 5a90bfc)
- Updated Fish shell configuration to activate 'mise' settings 🔧🐟 (by [Harper Reed](mailto:harper@nata2.org), 9e861fe)
- updated iterm config (by [Harper Reed](mailto:harper@nata2.org), 37c7e8c)
- added mise (by [Harper Reed](mailto:harper@nata2.org), 1d971d1)

## 2024-07-22

- 🚀 Update iTerm2 Configuration with New Variables and Customization! 🌈 (by [Harper Reed](mailto:harper@nata2.org), e57b5b7)

## 2024-07-21

- merged (by [Harper Reed](mailto:harper@nata2.org), 881d0df)

## 2024-07-19

- Merge branch 'master' of github.com:harperreed/dotfiles (by [Harper Reed](mailto:harper@nata2.org), cad128d)
- 🎉✨ New Pull Request Script and Config Updates! 🚀💥 (by [Harper Reed](mailto:harper@nata2.org), 46c4d45)

## 2024-07-17

- 🎉 Add .asdfrc config file for asdf version manager 🚀 - Created `.asdfrc` from scratch to configure the asdf version manager 🆕 - Set `legacy_version_file` to `yes` to support older file format 📜 - Disabled using release candidates with `use_release_candidates = no` 🙅‍♂️ - Downloads will be cleaned up after install with `always_keep_download = no` 🧹 - Repos will be checked for updates every 60 seconds 🕐 - Full plugin names are allowed with `disable_plugin_short_name_repository = no` ✅ - `concurrency` set to `auto` to let asdf manage parallel installs/updates 🏃‍♂️💨 (by [Harper Reed](mailto:harper@nata2.org), ebb9e9e)
- 🤘 Refactor that config yo! 🎸 - Tweaked the transparency to make it a bit more see-through, because we like to live dangerously 😎 - Bumped up the faint text alpha for light mode, because why the fuck not? 🌞 - Made some wild and crazy changes to the status bar colors. It's like a fucking rainbow up in here now! 🌈 (by [Harper Reed](mailto:harper@nata2.org), 5f14fe2)
- updated archive (by [Harper Reed](mailto:harper@nata2.org), 3cce73a)
- This diff shows changes to the iTerm2 configuration file com.googlecode.iterm2.plist. Here's a summary of the key changes: (by [Harper Reed](mailto:harper@nata2.org), 8795c5e)
- updated encrypted archive (by [Harper Reed](mailto:harper@nata2.org), b6e3432)
- Merge branch 'master' of github.com:harperreed/dotfiles (by [Harper Reed](mailto:harper@nata2.org), f69ad40)
- 👋🏽 Revamped iTerm2 configuration! 🚀 (by [Harper Reed](mailto:harper@nata2.org), c49b454)

## 2024-07-16

- updated archive (by [Harper Reed](mailto:harper@nata2.org), 345e0d8)
- Merge branch 'master' of github.com:harperreed/dotfiles (by [Harper Reed](mailto:harper@nata2.org), 594726d)
- updated iterm (by [Harper Reed](mailto:harper@nata2.org), e9fae11)
- updated (by [Harper Reed](mailto:harper@nata2.org), 3e610a9)

## 2024-07-15

- 🎉 Woohoo, looks like you added a bunch of cool new fish shell configuration! 🐠🎣  Let's break it down: (by [Harper Reed](mailto:harper@nata2.org), ce3ab62)
- Merge branch 'master' of github.com:harperreed/dotfiles (by [Harper Reed](mailto:harper@nata2.org), 4f2c3ca)
- 🚀 Overhauled fisher functions and config - Replaced old fisher config and functions with updated versions - fisher function condensed and modernized - nvm function updated to latest version - Removed outdated fisher plugins and associated functions:   - gitnow   - pyenv   - wd   - docker/docker-compose completions   - spin   - bax   - fish-apple-touchbar - Updated done plugin to latest version 🎉 Cleaned up config.fish and reorganized - Moved theme settings to separate theme.fish file - Secrets loading streamlined - Custom greeting function improved with more robust checks - Reorganized config into logical sections:   - PATH setup   - OS-specific configs   - Prompt (Starship?) setup   - Key framework inits: Atuin, ASDF   - SSH agent setup - Removed old/unused PATH entries and set more through Universal variables at the end 🔥 Removed old unused functions and simplified - Deleted old custom functions for gitnow, wd, spin, etc. - Removed old unused completions and abbr (docker, git, etc.) 💅 Styling and organization improvements - More emojis and better headings/sections - Consistent indentation and alignment throughout files - Removed crufty old aliases and simplified PATH setup (by [Harper Reed](mailto:harper@nata2.org), f9a4ec5)
- added ssh-agent (by [Harper Reed](mailto:harper@nata2.org), 2eb9f0d)

## 2024-07-02

- Merge branch 'master' of github.com:harperreed/dotfiles (by [Harper Reed](mailto:harper@nata2.org), 6ad03a0)
- 🎉 Woot woot! Looks like we got a fancy little change to the SSH config! 🎊 (by [Harper Reed](mailto:harper@nata2.org), 036ea37)
- 🎉 Get ready for some seriously exciting changes, y'all! 🚀 (by [Harper Reed](mailto:harper@nata2.org), 5a44354)

## 2024-05-14

- 🎉 Brewfile updates! 🍺 - Added "clipboard" and "yank" brews for some fancy copy-paste action 📋✂️ - Guess you'll be yankin' and clipboardin' all over the damn place now 😜 (by [Harper Reed](mailto:harper@nata2.org), 727f0b8)

## 2024-04-04

- 🔥 Tweaked SSH config for slightly less paranoia 🙈 - Commented out `StrictHostKeyChecking yes` setting 🤷‍♂️   - Now SSH won't be a fucking hardass about verifying host keys 🚀   - Fuck it, we'll do it live! 😜 YOLO amirite?? 🍻 (by [Harper Reed](mailto:harper@nata2.org), a3064e1)

## 2024-03-30

- 🚨💥 VisualHostKey settings changed 🔑🎨 (by [Harper Reed](mailto:harper@nata2.org), 856d7dc)
- 🚨 STOP THE PRESSES, WE GOT A DOOZY HERE! 🚨 (by [Harper Reed](mailto:harper@nata2.org), dc81112)
- Merge branch 'master' of github.com:harperreed/dotfiles (by [Harper Reed](mailto:harper@nata2.org), b679ad8)
- Merge branch 'master' of github.com:harperreed/dotfiles (by [Harper Reed](mailto:harper@nata2.org), fd4ffd0)
- Merge branch 'master' of github.com:harperreed/dotfiles (by [Harper Reed](mailto:harper@nata2.org), 779a22b)
- 🔥 Hot damn, check out these killer changes! 🔥 (by [Harper Reed](mailto:harper@nata2.org), fa7c74f)
- Merge branch 'master' of github.com:harperreed/dotfiles (by [Harper Reed](mailto:harper@nata2.org), d18f2d7)
- ✨ Screen & SSH config levelled up! 💪😎 ✨ (by [Harper Reed](mailto:harper@nata2.org), be1c064)
- 🚨 ZOMG, Huge SSH Config Changes! 🚨 - Renamed that crusty old `.ssh/config` file to `.ssh/host_config` 🙈 Because why the fuck not, amirite?! 💩 - Added a badass new `~/.ssh/config` file that's thicc AF 🍑 It's got more security than Fort Knox 🔒 and is optimized for maximum 🚀 SPEED 🚀 - This config includes settings for rock-solid 💪 encryption 🔐, robustness 🦾, and verbose-ass logging 📝 So when shit breaks, we'll know exactly WTF happened! 😤 - Oh, and it sources ssh configs from `.colima` and `.orbstack` because apparently we need to connect to every goddamn server in the observable universe 🪐🌌 (by [Harper Reed](mailto:harper@nata2.org), 4947288)

## 2024-03-27

- 🚀💥🤣 LMAO these changes are fuckin' awesome!!! 😎🎉 (by [Harper Reed](mailto:harper@nata2.org), 3acebcb)

## 2024-03-22

- Merge branch 'master' of github.com:harperreed/dotfiles (by [Harper Reed](mailto:harper@nata2.org), 8957692)
- 🔒 Tighten up security on key dotfiles! 🙈🙉🙊 - Change file permissions from 755 (rwxr-xr-x) to 644 (rw-r--r--) for:   - .bash_aliases   - .bash_profile   - .gvimrc   - .muttrc - Personal config files don't need world execute permissions - Keeps snoopy 👀 from executing your shit without permission! 🚫 (by [Harper Reed](mailto:harper@nata2.org), c921a41)
- 🍺 Brewfile Updates! 🎉 - Removed `marked` cask ❌ - Added `Marked 2` mas package with id `890031187` ✨ (by [Harper Reed](mailto:harper@nata2.org), b264cf1)
- 🍻 Add some new brews to the mix! 🍺 (by [Harper Reed](mailto:harper@nata2.org), e250c4f)

## 2024-03-21

- 🐟 Updating fish and adding asdf for even more amazing shell powers! 🪄 (by [Harper Reed](mailto:harper@nata2.org), 102f3ca)

## 2024-03-19

- 🎉🚀 Upgraded Node.js to v18.19.1! 🤖🎸 (by [Harper Reed](mailto:harper@nata2.org), 72806ac)

## 2024-03-15

- 🔥 Commit message prompt overhaul 🚀 - Removed the code block formatting from the output section 📝 - Condensed the instructions to make them punchier 💪 - Still covering all the key points, just more efficiently 😎 - Why? Because ain't nobody got time for long-ass prompts! ⏰ (by [Harper Reed](mailto:harper@nata2.org), c0afcb5)
- 🔥 Revamped commit message generation prompts for better specificity 👀🤖 - .config/prompts/commit-system-prompt.txt:   - Expanded the prompt to encourage more detailed commit messages 📝💪   - Added guidance to review the diff context for understanding code impact 🔍🧠   - Emphasized explaining the "why" behind changes for better clarity 🤔💡   - Requested specific explanations rather than guessing intent 🙅‍♂️🔮   - Highlighted the goal of helping others understand the changes 🤝📚   - Suggested using the commit message as a training example for the team 👨‍👩‍👧‍👦🎓 - .git_hooks/prepare-commit-msg:   - Updated the `git diff` command to include more context lines (-U999999) 📜🔍 (by [Harper Reed](mailto:harper@nata2.org), 3ef26fd)

## 2024-03-14

- 🎉 Tweaked the commit system prompt! 🙌 - .config/prompts/commit-system-prompt.txt: Changed "use swear words" to "be profane" because we're classy like that 😎💅 - Still keeping it 💯 and 🔥 but with a bit more sophistication 🎩🍸 (by [Harper Reed](mailto:harper@nata2.org), 4d132cd)
- Merge branch 'master' of github.com:harperreed/dotfiles (by [Harper Reed](mailto:harper@nata2.org), bd3e266)
- 🤖💬 Beep boop, I got a prompt update! 📝 - Made the prompts shorter and snappier - Added emojis and humor to the tone 🎉😂 - Specified a new output format 📋 (by [Harper Reed](mailto:harper@nata2.org), e8c88a3)

## 2024-03-12

- Update .gitconfig (by [Harper Reed](mailto:harper@nata2.org), 833dc8b)

## 2024-03-11

- llama_cpp not installed, install with: pip install llama-cpp-python Prepare commit message: (by [Harper Reed](mailto:harper@nata2.org), 5e0ff27)
- chore(.git_hooks): enhance prepare-commit-msg hook (by [Harper Reed](mailto:harper@nata2.org), 2cd2f8b)

## 2024-03-10

- Update prepare-commit-msg hook (by [Harper Reed](mailto:harper@nata2.org), 93788cc)
- Update .git_hooks/prepare-commit-msg (by [Harper Reed](mailto:harper@nata2.org), 121e268)
- Update git hook scripts: - Add cursor hiding and line clearing for better spinner display - Move cursor back to overwrite previous spinner frame - Show cursor and move to next line after spinner finishes - Add extra newlines for better output formatting (by [Harper Reed](mailto:harper@nata2.org), 8602605)
- Update animation spinner and formatting in prepare-commit-msg hook (by [Harper Reed](mailto:harper@nata2.org), 2884566)
- Update .git_hooks/prepare-commit-msg with animated loading and colored output (by [Harper Reed](mailto:harper@nata2.org), fb3a354)
- Feat: Add prepare-commit-msg git hook - Automatically generate informative commit messages using git diff and LLM - Skip message generation for merge commits - Write the generated message to the commit message file (by [Harper Reed](mailto:harper@nata2.org), eaaa2c4)
- Summary: Add llm-staged command and improve llm command (by [Harper Reed](mailto:harper@nata2.org), 019c9ce)
- Merge branch 'master' of github.com:harperreed/dotfiles (by [Harper Reed](mailto:harper@nata2.org), e4374c5)
- - .config/nvim/init.lua: Disable mouse support - Comment out `vim.o.mouse = "a"` to disable mouse - Set `vim.o.mouse = ""` to fully disable mouse support in Neovim (by [Harper Reed](mailto:harper@nata2.org), bd130a8)
- Enable shell integration for Fish shell (by [Harper Reed](mailto:harper@nata2.org), 258f93b)
- Modify iTerm2 configuration: - Add 1Password account integration - Set 1Password account to "GQEP3EWMENHQHIZIXJCFBITBBY" (by [Harper Reed](mailto:harper@nata2.org), 706ce53)
- Add 1Password account integration to iTerm2 (by [Harper Reed](mailto:harper@nata2.org), 26aaaca)
- created better llm handler (by [Harper Reed](mailto:harper@nata2.org), 3eb0ac7)

## 2024-03-09

- added system prompt for git (by [Harper Reed](mailto:harper@nata2.org), f274d95)
- Add git alias 'gpt' to generate commit messages using llm (by [Harper Reed](mailto:harper@nata2.org), a251ab6)

## 2024-03-07

- added miniconda to brewfile (by [Harper Reed](mailto:harper@nata2.org), d9c7662)
- updated conda (by [Harper Reed](mailto:harper@nata2.org), 5cc24c5)
- updated nvim (by [Harper Reed](mailto:harper@nata2.org), e9ae19f)
- updated iterm config (by [Harper Reed](mailto:harper@nata2.org), 06afa38)

## 2024-03-06

- added ollama (by [Harper Reed](mailto:harper@nata2.org), dcbb819)
- added a few goodies to brewfile (by [Harper Reed](mailto:harper@nata2.org), 96ed01a)
- updated brewfile (by [Harper Reed](mailto:harper@nata2.org), b85ec38)

## 2024-02-19

- Merge branch 'master' of github.com:harperreed/dotfiles (by [Harper Reed](mailto:harper@nata2.org), ed6fffa)
- updated fish vim nvim vi alias (by [Harper Reed](mailto:harper@nata2.org), a86ae7e)
- updated zed config (by [Harper Reed](mailto:harper@nata2.org), 0ca92b8)
- added gitconfig (by [Harper Reed](mailto:harper@nata2.org), f412966)
- Merge branch 'master' of github.com:harperreed/dotfiles (by [Harper Reed](mailto:harper@nata2.org), 487de7d)
- added nvim to gitconfig (by [Harper Reed](mailto:harper@nata2.org), 4c52370)
- updated iterm config (by [Harper Reed](mailto:harper@nata2.org), 87f5d21)
- updated gitconfig (by [Harper Reed](mailto:harper@nata2.org), eec9ac3)

## 2024-01-25

- added gitignore (by [Harper Reed](mailto:harper@nata2.org), 8bf3dcf)

## 2024-01-24

- removed openai key (by [Harper Reed](mailto:harper@nata2.org), 18ee9e5)
- updated zed (by [Harper Reed](mailto:harper@nata2.org), 9c60695)
- updated zed (by [Harper Reed](mailto:harper@nata2.org), eaa5e87)
- added zed (by [Harper Reed](mailto:harper@nata2.org), 7f36d20)

## 2024-01-21

- updated atuin config (by [Harper Reed](mailto:harper@nata2.org), c91ec3f)
- added atuin config (by [Harper Reed](mailto:harper@nata2.org), c55e9ed)
- updated fish config. and an errant iterm thing (by [Harper Reed](mailto:harper@nata2.org), 538c6bd)
- Merge branch 'master' of github.com:harperreed/dotfiles (by [Harper Reed](mailto:harper@nata2.org), 0ff1e4f)
- updated no keybinding (by [Harper Reed](mailto:harper@nata2.org), 40029c1)
- Merge branch 'master' of github.com:harperreed/dotfiles (by [Harper Reed](mailto:harper@nata2.org), 3c39db9)
- added atuin (by [Harper Reed](mailto:harper@nata2.org), d1c5e34)
- Merge branch 'master' of github.com:harperreed/dotfiles (by [Harper Reed](mailto:harper@nata2.org), d6e4459)
- udpated from wizard (by [Harper Reed](mailto:harper@nata2.org), 565ce2a)
- Merge branch 'master' of github.com:harperreed/dotfiles (by [Harper Reed](mailto:harper@nata2.org), 7b77a39)
- updated iterm config (by [Harper Reed](mailto:harper@nata2.org), 657f5e3)
- updated iterm config (by [Harper Reed](mailto:harper@nata2.org), 0202761)
- fish vars (by [Harper Reed](mailto:harper@nata2.org), 3061bdc)
- updated fish config to have atuin installed (by [Harper Reed](mailto:harper@nata2.org), 006429b)

## 2023-10-18

- updatede brewfile (by [Harper Reed](mailto:harper@nata2.org), 9964ad2)

## 2023-10-09

- fucked up the merge (by [Harper Reed](mailto:harper@nata2.org), 18a9fb0)
- merged. fucking mamba (by [Harper Reed](mailto:harper@nata2.org), d3e21bf)
- removed mamba (by [Harper Reed](mailto:harper@nata2.org), dfe1038)
- added atuin (by [Harper Reed](mailto:harper@nata2.org), 0d84bd9)
- merged (by [Harper Reed](mailto:harper@nata2.org), 0e751b1)
- added atuin and added vimr (by [Harper Reed](mailto:harper@nata2.org), 7b915cd)
- updated vimrc and gvim bin (by [Harper Reed](mailto:harper@nata2.org), 8c1fd2f)
- added smiple nvim config (by [Harper Reed](mailto:harper@nata2.org), 96b997f)

## 2023-09-27

- added gitlfs (by [Harper Reed](mailto:harper@nata2.org), 5839759)
- added conda to the path (by [Harper Reed](mailto:harper@nata2.org), d4acad3)
- updated bash (by [Harper Reed](mailto:harper@nata2.org), 345dfb4)

## 2023-09-13

- updated fish variables and iterm goodies (by [Harper Reed](mailto:harper@nata2.org), 4824b84)

## 2023-08-08

- merged (by [Harper Reed](mailto:harper@nata2.org), 0c247e2)
- updated fish stuff and gopaths (by [Harper Reed](mailto:harper@nata2.org), da0ebaa)
- updated fish path (by [Harper Reed](mailto:harper@nata2.org), f84053a)

## 2023-06-19

- tweaked brewfile (by [Harper Reed](mailto:harper@nata2.org), 080db4e)
- updated Brewfile (by [Harper Reed](mailto:harper@nata2.org), 6d38bd8)
- updated fish, iterm, and bash_profile (by [Harper Reed](mailto:harper@nata2.org), 5c2e9f2)

## 2023-01-25

- fixed a thing (by [Harper Reed](mailto:harper@nata2.org), aedae45)
- removed ngrok (by [Harper Reed](mailto:harper@nata2.org), 5c59499)
- merged (by [Harper Reed](mailto:harper@nata2.org), ac39f83)
- updated from trillian (by [Harper Reed](mailto:harper@nata2.org), 76e5d99)
- udpated brewfile again (by [Harper Reed](mailto:harper@nata2.org), 748f69f)
- added hammspoon (by [Harper Reed](mailto:harper@nata2.org), 419c55f)
- updated bootstrap (by [Harper Reed](mailto:harper@nata2.org), cd6363c)
- updated brewfile (by [Harper Reed](mailto:harper@nata2.org), a6db9d4)
- added ubersicht widgets (by [Harper Reed](mailto:harper@nata2.org), fa30091)
- updated a few pieces (by [Harper Reed](mailto:harper@nata2.org), b1f9d24)

## 2022-05-15

- updated config to have some magic in it (by [Harper Reed](mailto:harper@nata2.org), 64684d7)

## 2022-04-04

- updated Brefile (by [Harper Reed](mailto:harper@nata2.org), 3dab3c9)
- uipdated brewfile (by [Harper Reed](mailto:harper@nata2.org), dec53da)

## 2022-03-06

- updated from million (by [Harper Reed](mailto:harper@nata2.org), ca738c5)
- updated from million (by [Harper Reed](mailto:harper@nata2.org), 54fb999)

## 2022-02-22

- updated archive (by [Harper Reed](mailto:harper@nata2.org), 567b8c3)
- merged (by [Harper Reed](mailto:harper@nata2.org), 2a13159)
- various tweaks from linux (by [Harper Reed](mailto:harper@nata2.org), 3099878)
- merged (by [Harper Reed](mailto:harper@nata2.org), b532a78)
- updated encrypted shit (by [Harper Reed](mailto:harper@nata2.org), 86f3b33)
- git branch main (by [Harper Reed](mailto:harper@nata2.org), a54f468)
- iterm and fish (by [Harper Reed](mailto:harper@nata2.org), 65c7351)

## 2021-11-18

- Added gnrok config (by [Harper Reed](mailto:harper@nata2.org), 4b9f8a5)

## 2021-10-20

- Merge branch 'master' of github.com:harperreed/dotfiles (by [Harper Reed](mailto:harper@nata2.org), 021d3c5)
- updated autostart (by [Harper Reed](mailto:harper@nata2.org), 4bbb934)

## 2021-10-17

- removed tailscale (by [Harper Reed](mailto:harper@nata2.org), 69e1ab0)

## 2021-10-15

- updated crypt (by [Harper Reed](mailto:harper@nata2.org), e8a9f40)
- Merge branch 'master' of github.com:harperreed/dotfiles (by [Harper Reed](mailto:harper@nata2.org), 3e53fbc)

## 2021-10-14

- updated conky (by [Harper Reed](mailto:harper@nata2.org), 590e881)
- updated to include golang (by [Harper Reed](mailto:harper@nata2.org), b3560eb)
- updated bootstrap (by [Harper Reed](mailto:harper@nata2.org), cc652ee)
- removed NPM from bootstrap (by [Harper Reed](mailto:harper@nata2.org), 60d0ad4)

## 2021-10-13

- Merge branch 'master' of github.com:harperreed/dotfiles (by [Harper Reed](mailto:harper@nata2.org), f27941a)
- new conky stuff (by [Harper Reed](mailto:harper@nata2.org), 1ce9e10)
- updated start script (by [Harper Reed](mailto:harper@nata2.org), eac4905)
- set default branch (by [Harper Reed](mailto:harper@nata2.org), 36d2772)

## 2021-07-02

- Create README.md (by [Harper Reed](mailto:harper@nata2.org), a85d1c5)
- updated bootstrap (by [Harper Reed](mailto:harper@nata2.org), c156eaa)
- Merge branch 'master' of github.com:harperreed/dotfiles (by [Harper Reed](mailto:harper@nata2.org), b1aa9df)
- updated a few paths (by [Harper Reed](mailto:harper@nata2.org), b20b752)

## 2021-02-25

- longer figlets (by [Harper Reed](mailto:harper@nata2.org), c09b430)

## 2021-02-06

- removed legacy yadm apparently (by [Harper Reed](mailto:harper@nata2.org), 0ce1deb)

## 2021-02-02

- iterm configuratiuon (by [Harper Reed](mailto:harper@nata2.org), 9816063)

## 2021-01-26

- upgraded (by [Harper Reed](mailto:harper@nata2.org), 10416b7)

## 2021-01-18

- updated bash profile to match fish config a bit. also added symlink to yadm in .config for annoying distros (by [Harper Reed](mailto:harper@nata2.org), c314c7f)
- updated hostname (by [Harper Reed](mailto:harper@nata2.org), 9f43611)

## 2021-01-17

- added alacritty and updated a fwe things (by [Harper Reed](mailto:harper@nata2.org), 7835890)

## 2021-01-15

- updated conky (by [Harper Reed](mailto:harper@nata2.org), b6f5cf7)
- updated fish config (by [Harper Reed](mailto:harper@nata2.org), a4fce8d)
- updated fonts for figlet (by [Harper Reed](mailto:harper@nata2.org), 5ad7b00)

## 2020-12-19

- Merge branch 'master' of github.com:harperreed/dotfiles (by [Harper Reed](mailto:harper@nata2.org), b4ae8f8)
-  fishing it up (by [Harper Reed](mailto:harper@nata2.org), 1eb9f3e)
- Update Brewfile (by [Harper Reed](mailto:harper@nata2.org), 558a3d0)
- Update Brewfile (by [Harper Reed](mailto:harper@nata2.org), 0a83237)

## 2020-12-17

- moved conky to the right place (by [Harper Reed](mailto:harper@nata2.org), 370b1c4)
- moved conky to the right place (by [Harper Reed](mailto:harper@nata2.org), 7aa8d14)

## 2020-12-12

- e and x, yo (by [Harper Reed](mailto:harper@nata2.org), b2bd9c4)
- added dconf dump. need to add it to my bootstrap (by [Harper Reed](mailto:harper@nata2.org), d1e3c87)

## 2020-12-11

- conky config (by [Harper Reed](mailto:harper@nata2.org), e5ec108)
- Merge branch 'master' of github.com:harperreed/dotfiles (by [Harper Reed](mailto:harper@nata2.org), aee63dd)

## 2020-12-10

- i was so careful. alas. (by [Harper Reed](mailto:harper@nata2.org), 265f171)
-  cal (by [Harper Reed](mailto:harper@nata2.org), 590c543)

## 2020-12-03

- Merge branch 'master' of github.com:harperreed/dotfiles (by [Harper Reed](mailto:harper@nata2.org), e707f63)
- Merge branch 'master' of github.com:harperreed/dotfiles (by [Harper Reed](mailto:harper@nata2.org), 2e0e537)
- update (by [Harper Reed](mailto:harper@nata2.org), 36fa21c)
- updated path (by [Harper Reed](mailto:harper@nata2.org), 2b5d18d)

## 2020-11-30

- removed nprc cuz now has secrets (by [Harper Reed](mailto:harper@nata2.org), 088f1a8)

## 2020-11-29

- added theia (by [Harper Reed](mailto:harper@nata2.org), 8e5e6c1)
- Update bootstrap (by [Harper Reed](mailto:harper@nata2.org), ff5b0e8)
- Update bootstrap (by [Harper Reed](mailto:harper@nata2.org), d941751)

## 2020-11-28

- Update bootstrap (by [Harper Reed](mailto:harper@nata2.org), 001d4b6)
- Update config.cfg (by [Harper Reed](mailto:harper@nata2.org), d48bed1)
- added steam config (by [Harper Reed](mailto:harper@nata2.org), 4c4a3f0)

## 2020-11-27

- added my nudes (by [Harper Reed](mailto:harper@nata2.org), fe46d2c)
- Merge branch 'master' of github.com:harperreed/dotfiles (by [Harper Reed](mailto:harper@nata2.org), 027bd02)
- updated from million (by [Harper Reed](mailto:harper@nata2.org), c043882)

## 2020-11-26

- Update bootstrap (by [Harper Reed](mailto:harper@nata2.org), 915fb80)

## 2020-11-24

- updated (by [Harper Reed](mailto:harper@nata2.org), 2193981)

## 2020-11-20

- updated to use fish_greeting (by [Harper Reed](mailto:harper@nata2.org), 005013f)

## 2020-11-06

- hmm (by [Harper Reed](mailto:harper@nata2.org), af6ac88)

## 2020-10-19

- tweaks (by [Harper Reed](mailto:harper@nata2.org), 9a5b881)
- made fish pretty (by [Harper Reed](mailto:harper@nata2.org), 472b391)

## 2020-10-18

- updated a few things (by [Harper Reed](mailto:harper@nata2.org), 4363e51)
- Merge branch 'master' of github.com:harperreed/dotfiles (by [Harper Reed](mailto:harper@nata2.org), fff9f4c)

## 2020-10-15

- added a few other things (by [Harper Reed](mailto:harper@nata2.org), 5024120)
- added conky (by [Harper Reed](mailto:harper@nata2.org), 78e29ac)

## 2020-10-11

- added remmina (by [Harper Reed](mailto:harper@nata2.org), 57710e9)

## 2020-09-13

- merged (by [Harper Reed](mailto:harper@nata2.org), c8c8b47)
- settings, you (by [Harper Reed](mailto:harper@nata2.org), 88ebfc5)
- hl;2mp config (by [Harper Reed](mailto:harper@nata2.org), 8839af8)
- added hl2mp (by [Harper Reed](mailto:harper@nata2.org), 935ee7f)

## 2020-09-12

- updated wallpaper config (by [Harper Reed](mailto:harper@nata2.org), 3302c86)

## 2020-09-06

- updated bootstrap (by [Harper Reed](mailto:harper@nata2.org), befb733)
- Merge branch 'master' of github.com:harperreed/dotfiles (by [Harper Reed](mailto:harper@nata2.org), 0841b04)
- removed (by [Harper Reed](mailto:harper@nata2.org), 4f02d70)
- some paths for fish (by [Harper Reed](mailto:harper@nata2.org), fd62b84)
- updated kitty (by [Harper Reed](mailto:harper@nata2.org), a7b54fe)
- tweaked kitty a bunch. (by [Harper Reed](mailto:harper@nata2.org), 450f8ad)

## 2020-08-31

- merged (by [Harper Reed](mailto:harper@nata2.org), 6e52dd1)
- merged? (by [Harper Reed](mailto:harper@nata2.org), e02379b)
- updated fish configs (by [Harper Reed](mailto:harper@nata2.org), 4ec0316)
- configs (by [Harper Reed](mailto:harper@nata2.org), 1a810ee)
- some config changes (by [Harper Reed](mailto:harper@nata2.org), 10c2c2f)
- updated to use the apt version (by [Harper Reed](mailto:harper@nata2.org), 019f5a6)

## 2020-08-30

- updated variables (by [Harper Reed](mailto:harper@nata2.org), fb77c99)
- updated (by [Harper Reed](mailto:harper@nata2.org), 277b2e2)
- updated kitty config (by [Harper Reed](mailto:harper@nata2.org), 32ad07b)
- i don't use pyenv (by [Harper Reed](mailto:harper@nata2.org), 286c178)

## 2020-08-29

- added kitty (by [Harper Reed](mailto:harper@nata2.org), 4325c6e)
- updated (by [Harper Reed](mailto:harper@nata2.org), 3c18f65)
- updated secrets (by [Harper Reed](mailto:harper@nata2.org), 6703570)
- updated brewfile (by [Harper Reed](mailto:harper@nata2.org), 6ac4b3c)
- updated brewfile (by [Harper Reed](mailto:harper@nata2.org), 237721c)
- added screern, mutt, and vim, base16 (by [Harper Reed](mailto:harper@nata2.org), f97eb17)
- added gvim (by [Harper Reed](mailto:harper@nata2.org), a2914d3)
- fished up (by [Harper Reed](mailto:harper@nata2.org), 20f0699)
- updated fish (by [Harper Reed](mailto:harper@nata2.org), 04279a4)
- updated fish (by [Harper Reed](mailto:harper@nata2.org), d1e8940)
- encrypted some goodies (by [Harper Reed](mailto:harper@nata2.org), 849bc3b)
- added gpg config (by [Harper Reed](mailto:harper@nata2.org), e9a4e26)
- deleted extra shit (by [Harper Reed](mailto:harper@nata2.org), 70db137)
- added npm config (by [Harper Reed](mailto:harper@nata2.org), a551b84)
- added osx config (by [Harper Reed](mailto:harper@nata2.org), 19a071e)
- iterm config (by [Harper Reed](mailto:harper@nata2.org), 10793b9)
- added bin dir (by [Harper Reed](mailto:harper@nata2.org), 647fe8d)
- added mutt (by [Harper Reed](mailto:harper@nata2.org), 49252e0)
- don't need viminfo (by [Harper Reed](mailto:harper@nata2.org), 8912e54)
- updated brewfile (by [Harper Reed](mailto:harper@nata2.org), 2da7ac6)
- updated brewfile (by [Harper Reed](mailto:harper@nata2.org), 7f5946b)
- updated bootstrapper (by [Harper Reed](mailto:harper@nata2.org), b44db5b)
- added bootstrap (by [Harper Reed](mailto:harper@nata2.org), 900e403)
- added vscode (by [Harper Reed](mailto:harper@nata2.org), b8fcc09)
- vim (by [Harper Reed](mailto:harper@nata2.org), e566e79)
- Added git config (by [Harper Reed](mailto:harper@nata2.org), 0e5743e)
- Added git config (by [Harper Reed](mailto:harper@nata2.org), 94e1b08)

