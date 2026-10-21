# git_diff_to_text

在两台电脑之间离线同步 Git 改动：A 电脑导出**已暂存（`git add` 但未 `git commit`）**的修改，把生成的补丁文件拷贝到不可联网的 B 电脑上应用。

## 工作流程

1. A 电脑：`git add` 需要同步的修改。
2. A 电脑：将导出脚本 `export_on_a` 复制到代码仓目录下，运行，生成 `staged.patch`。
3. B 电脑：把 `staged.patch` 和导出脚本 `apply_on_b` 拷贝到 B 电脑的同一代码仓中。
4. B 电脑：运行应用脚本。
5. 检查结果，按需 `git add` / `git commit`。

## 脚本

| 文件 | 运行环境 | 用途 |
| --- | --- | --- |
| `export_on_a.bat` | Windows（A 电脑） | 导出已暂存的修改 |
| `export_on_a.sh` | Linux / macOS / Git Bash（A 电脑） | 导出已暂存的修改 |
| `apply_on_b.bat` | Windows（B 电脑） | 校验并应用补丁 |
| `apply_on_b.sh` | Linux / macOS / Git Bash（B 电脑） | 校验并应用补丁 |

## A 电脑：导出

```sh
# Windows
export_on_a.bat                 # 生成 staged.patch

# Linux
sh export_on_a.sh               # 生成 staged.patch
```

导出命令等价于：

```sh
git diff --cached --binary --full-index > staged.patch
```

- `--cached`：只导出暂存区与 `HEAD` 的差异。
- `--binary`：包含二进制文件的补丁。
- `--full-index`：输出完整 blob 哈希，应用更可靠。

若没有已暂存的修改，脚本会给出提示。

## B 电脑：应用

```sh
# Windows
apply_on_b.bat                   # 应用 staged.patch

# Linux
sh apply_on_b.sh                 # 应用 staged.patch
```

脚本先执行 `git apply --check` 校验，通过后才执行 `git apply`；校验失败会直接退出，不会改动文件。

## 注意事项

- 只包含**已暂存**的修改。未暂存（`git add` 之后又改动）和未跟踪的文件不会进入补丁。
- 补丁应用到 B 电脑的**工作区**，不会自动暂存；需要时手动 `git add`。
- B 电脑的代码基线应与 A 导出时一致（通常是同一个提交），否则 `git apply --check` 会失败。
- 整个过程不需要网络，只需 Git；sh 脚本可用 Git Bash 运行。
