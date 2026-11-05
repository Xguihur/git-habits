# git-habits

`git-habits` 是一个轻量级、跨平台的快捷命令配置仓库，用于集中管理常用的 Git、Shell 和 npm 命令。通过 Git 克隆仓库并运行平台对应的安装脚本，开发者可以在 macOS、Linux 和 Windows 环境中快速恢复开发习惯，同时保留原有 Shell 配置。

本项目只通过 Git 分发；不包含 `package.json`、Node.js CLI、npm 包或 npm Registry 发布流程。`npm` 仅是 `nrd`/`nrb` 运行时的可选依赖。

## 快速开始

```sh
git clone https://github.com/<username>/git-habits.git
cd git-habits
./install.sh
```

macOS/Linux 的脚本根据 `$SHELL` 选择 `.zshrc` 或 `.bashrc`；Git Bash 使用同一个 `install.sh`，并使用其 Bash 用户目录。安装会把生成文件放在 `${XDG_CONFIG_HOME:-$HOME/.config}/git-habits`，只在启动文件中维护标记区块。

Windows PowerShell：

```powershell
git clone https://github.com/<username>/git-habits.git
Set-Location git-habits
.\install.ps1
```

PowerShell 生成文件位于 `$HOME\.git-habits`，入口写入 `$PROFILE`。如果执行策略阻止本地脚本，可在当前用户范围允许脚本后重试：`Set-ExecutionPolicy -Scope CurrentUser RemoteSigned`。

安装后打开新终端，或执行 `. ~/.bashrc`、`. ~/.zshrc` 或 `. $PROFILE`。

## 支持环境

- macOS、Linux、Windows；
- Bash、Zsh、Windows Git Bash、PowerShell；
- Git 必须已安装并在 `PATH` 中；
- npm 只在使用 `nrd` 或 `nrb` 时需要。

Windows CMD 不属于第一阶段目标。

## 命令列表

| 命令 | 行为 | 参数 |
| --- | --- | --- |
| `cl` | `clear` / `Clear-Host` | 无 |
| `gad` | `git add .` | 无 |
| `gcm` | `git commit -m` | 提交信息 |
| `gps` | `git push` | 可选 Git 参数 |
| `gpl` | `git pull` | 可选 Git 参数 |
| `gmg` | `git merge` | 分支或 ref |
| `gst` | `git status` | 可选 Git 参数 |
| `glg` | `git log` | 可选 Git 参数 |
| `gll` | `git log --oneline` | 可选 Git 参数 |
| `gcl` | `git clone` | 仓库参数 |
| `nrd` | `npm run dev` | 可选 npm 参数 |
| `nrb` | `npm run build` | 可选 npm 参数 |

例如：`gcm "initial commit"` 等价于 `git commit -m "initial commit"`。`commands.tsv` 是命令清单和说明的集中源配置；运行时文件保持平台语法适配。

## 更新、卸载和诊断

更新仓库并重复执行幂等安装即可：

```sh
git pull
./update.sh
```

PowerShell 使用 `git pull` 后执行 `./update.ps1`（或 `& .\update.ps1`）。安装只更新项目配置，不覆盖用户标记区块之外的内容；发生修改前会创建 `.git-habits.bak*` 备份。

卸载：

```sh
./uninstall.sh
# PowerShell: .\uninstall.ps1
```

卸载只移除项目标记区块和生成的配置目录，保留其他用户配置及备份。

诊断：

```sh
./doctor.sh
# PowerShell: .\doctor.ps1
```

`doctor` 检查 Git、npm、配置路径、加载区块和当前会话中的命令，不自动修改用户配置。

## 自定义命令

1. 在 `config/commands.tsv` 中增加一行，填写名称、Shell 命令、PowerShell 命令、说明、参数标志和风险标志；
2. 同步更新 `shell/git-habits.sh` 与 `shell/git-habits.ps1` 的平台函数；
3. 运行 `tests/smoke.sh`，并在 Bash/Zsh 与 PowerShell 中验证行为；
4. 提交 Pull Request。

这样既保留单一清单，又明确记录无法由 TSV 直接生成的 Shell/PowerShell 参数适配。不要直接编辑用户的 profile。

## 安全说明

- 脚本不会上传 Git 配置，不读取或保存 token、密码、私钥；
- 不要把敏感信息提交到仓库；
- 安装不会覆盖既有配置，修改前会备份；
- `gad` 可能暂存当前目录下全部变更；`gps` 会推送；`gpl` 会拉取；`gmg` 会合并；
- `nrd` 和 `nrb` 会执行当前项目 `package.json` 中定义的 npm script；
- Git 缺失时 Git 命令不能工作；npm 缺失不影响 Git 快捷命令；
- 第一阶段不提供 `git reset --hard`、`git clean -fd`、强制推送或删除分支等高风险快捷命令；
- 使用前请确认命令行为和当前工作目录。

## 贡献

Fork 仓库，创建分支，修改集中配置和平台运行时，运行 `tests/smoke.sh`，提交清晰的 commit，并创建 Pull Request。请同时说明平台、Shell 和验证命令。

## License

MIT，见 [LICENSE](LICENSE)。
