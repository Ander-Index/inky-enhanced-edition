# Inky Enhanced Edition

**Inky Enhanced Edition (InkEE)** 是 [Inky](https://github.com/inkle/inky) 的社区增强分支。Inky 是 [inkle](http://www.inklestudios.com/ink) 出品的 ink 互动叙事语言编辑器。

> 关于 ink 语言和 Inky 编辑器的详细介绍，请参阅[原版 Inky 仓库](https://github.com/inkle/inky)。
>
> **注意**：本分支的所有改动均由本仓库作者使用 DeepSeek V4 Pro 进行 Vibe Coding 完成。本分支不会向原仓库提交任何代码，以避免代码污染。

---

## 相较于原版的改进

### 🐛 Bug 修复

- **修复 CJK 地区崩溃**：非英语系统（如中文）打开工程时不再弹出 `TypeError: Cannot read properties of undefined (reading 'submenu')` 错误
- **修复 macOS 中文 locale 检测**：`zh-Hans-CN` 等带脚本标签的 locale 现在能正确加载中文翻译
- **修复顶级菜单汉化失效**：`&File` → `文件` 等含 `&` 前缀的菜单项现在能正确翻译
- **修复设置面板字号不生效**：ACE 设置面板传入字符串 `"14"` 而非数字导致 CSS 单位缺失，现已自动转换
- **修复设置面板改动丢失**：文本输入框关闭面板时未触发保存事件，现已修复

### ✨ 新功能

- **偏好设置面板**：Edit → Preferences（`Cmd+,`）打开 ACE 编辑器完整设置面板
- **设置面板中文化**：面板内所有选项标签均已翻译为中文
- **独立编辑/预览字体设置**：代码编辑区和故事预览区可分别设置字体族和字号，支持后备字体（逗号分隔）
- **字体字号持久化**：所有字体设置自动保存，重启后恢复
- **字号默认值保护**：输入非法字符时自动回退到默认值
- **字体引号自动清理**：浏览器给多词字体名添加的 CSS 引号自动去除
- **`Cmd+0` 重置缩放**：快捷键恢复到 100%
- **缩放联动字号**：`Cmd+=` / `Cmd+-` 缩放后字号同步更新并持久化
- **Ink 代码片段双语注释**：快速语法菜单插入的模板代码含中英双语注释
- **菜单完整汉化**：全部菜单项、对话框均已翻译为简体中文

### 🔧 构建改进

- 应用打包名改为 **Inky Enhanced Edition**
- DMG 制作改用系统自带 `hdiutil`，不再依赖 `appdmg` 原生模块（兼容 Node.js v24+）

---

## 下载

前往 [Releases](../../releases/latest) 页面下载最新版本。

---

## 构建

```bash
# 开发模式运行
cd app && npm install && npm start

# 构建 macOS DMG
cd app && npm run build-package -- -zip mac

# 构建 Windows zip（可在 macOS 上交叉编译）
cd app && npm run build-package -- -zip win64
```

---

## 许可

基于原版 [Inky](https://github.com/inkle/inky)，采用 MIT 许可证。

Copyright (c) 2016 inkle Ltd.

---

*以上改进由 [DeepSeek V4 Pro](https://deepseek.com) 通过 vibe coding 完成。本分支不会向上游仓库提交代码，以避免代码污染。*

