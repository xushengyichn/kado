# 中文免费版：做了什么、怎么做的

日期：2026-10-14
状态：完成
本地分支：feature/personal-offline

## 现在的行为

六套习惯配色、八个 App 图标全部开放。购买、恢复购买、打赏页面及提醒已经删除。增加简体中文，保留英文和法文，按照 iOS 为这个 App 选择的语言显示。品牌和图标的原有专有名称保留，图标含义以中文显示。

这是目前安装到个人 iPhone 的离线版本。使用相同的 `com.shengyixu.kado.personal` 标识覆盖安装，不卸载 App，也不修改习惯及记录的数据模型。

## 1. 去掉付费功能

- 删除 `Kado/Monetization` 的 StoreKit 商品加载、购买、交易监听和恢复服务。
- 删除设置中的 Supporter pack、Tip Jar 页面和入口，以及 Today 的打赏横幅。
- 删除 KadoCore 的 `SupporterGated`、购买权益和购买状态镜像。
- `HabitThemeSection` 直接保存选中的主题；`HabitThemeDefaults.renderedTheme` 直接读取这个选择。
- `AppIconSection` 直接应用选中的图标，`AppIconApplier` 仍处理系统拒绝、重复请求和并发切换。
- 删除启动时的交易检查、购买状态注入，以及退款后恢复默认外观的逻辑。
- 删除 `Tips.storekit` 模拟购买配置，并从工程与运行 Scheme 中移除引用。
- 移除已经不存在的付费功能测试，保留图标切换、并发、失败处理等测试，补上所有选项可用的回归检查。

## 2. 汉化

在 `Kado/Resources/Localizable.xcstrings` 和 `KadoWidgets/Resources/Localizable.xcstrings` 中增加 `zh-Hans`。覆盖导航、设置、习惯表单、记录、统计、导入导出、通知、快捷指令和 VoiceOver 文案。

中文数字表达使用适合中文的复数 `other` 规则。保留 `%lld`、`%@` 的类型和位置，中文语序调整时使用参数位置标记。增加自动检查，防止以后遗漏翻译或把次数、习惯名称等参数弄错。

设置的离线状态改为“本地存储”，说明数据保存在本机，无需登录；不再在免费离线版中提示登录 iCloud。

若手机为中文，App 会显示简体中文；也可以在 iOS 为 Kadō 单独选择简体中文。已有习惯名称、备注等用户填写的数据不会自动翻译。

## 3. 验证

- 单元测试：722 项通过，1 项原项目已声明的预期失败；没有非预期失败。
- 中文资源覆盖和格式参数检查：通过。
- iPhone 界面测试：中文今天、总览、设置、外观页面正常；六套主题全部可选；额外图标可切换，无需购买。
- iPad Air 13-inch (M4)：深色模式、最大无障碍字体检查通过，页面可滚动，中文未被截断。
- 真机：使用原免费账户签名覆盖安装，成功启动，检查时进程仍运行。

截图见 `screenshots/`。保持原 MIT 许可证和作者信息，没有向原作者仓库推送。

## 以后怎么继续修改

文案修改 `.xcstrings` 中的 `zh-Hans` 翻译；外观选择界面位于 `Kado/Views/Settings/`。使用 Xcode 的 Kado Scheme、Debug 配置，选择真实 iPhone 后按 ⌘R，即可编译和覆盖安装。

免费签名仍受 Apple 七天授权限制，去掉应用内付费功能不会改变签名期限。iCloud 和小组件数据共享仍受 Personal Team 权限限制。
