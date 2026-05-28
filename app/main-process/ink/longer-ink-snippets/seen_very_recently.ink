/*
	Tests if the flow passes a particular gather "very recently" - that is, within the last 3 turns. / 测试流程是否"非常近期"地经过了某个特定的 gather 点——即在最近 3 个回合内。

	Usage: / 用法：

	- (welcome)
		"Welcome!" / "欢迎！"
	- (opts)
		*	{seen_very_recently(->welcome)}
			"Sorry, hello, yes." / "抱歉，你好，是的。"
		+	"Er, what?" / "呃，什么？"
			-> opts
		*	"Can we get on with it?" / "我们能继续了吗？"

*/

=== function seen_very_recently(-> x)
    ~ return TURNS_SINCE(x) >= 0 && TURNS_SINCE(x) <= 3
