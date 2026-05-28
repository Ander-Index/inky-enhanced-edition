/*
	Tests if the flow passes a particular gather on this turn. / 测试流程在本回合是否经过某个 gather 点。

	Usage:  / 用法：

	- (welcome)
		"Welcome!" / "欢迎！"
	- (opts)
		*	{came_from(->welcome)}
			"Welcome to you!" / "欢迎你！"
		*	"Er, what?" / "呃，什么？"
			-> opts
		*	"Can we get on with it?" / "能继续了吗？"

*/

=== function came_from(-> x)
    ~ return TURNS_SINCE(x) == 0
