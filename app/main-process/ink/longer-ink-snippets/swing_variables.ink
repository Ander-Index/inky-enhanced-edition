
/*

	Overview: / 概述：

	A system for tracking "good and bad" actions, and returning the proportion the player has encountered in the course of their playthrough. / 一个追踪"好与坏"行为的系统，返回玩家在游戏过程中所遇到的行为比例。

	e.g. the player has said 15 nice things and 5 nasty things, so they are 75% nice.
	/ 例如：玩家说了 15 句好话和 5 句坏话，那么他们的友善程度为 75%。

	This allows the game to make decisions about the balance of the player's choices across the game regardless of knowing how many choice moments they've actually encountered. / 这使得游戏能够对玩家在整个游戏中的选择平衡做出判断，而不需要知道他们实际遇到了多少个选择时刻。

	It also means that the player's behaviour settles over time - each additional decision they take has less and less effect on the overall value. In short, "what's done is done."
	/ 这也意味着玩家的行为会随时间推移而趋于稳定——每增加一个决定，其对总体数值的影响就越来越小。简而言之，"木已成舟"。


	System: / 系统：

	Each concept is given a "swing variable", which after being given an initial value, can be "raised" or "lowered".
	/ 每个概念被赋予一个"摇摆变量"，在给定初始值后，可以被"提升"或"降低"。

	For more significant actions, one can "elevate" or "ditch" it. For all-but-irrecoverable actions, you can "escalate" or "demolish" the stat.
	/ 对于更重要的行为，可以"大幅提升"或"大幅降低"它。对于几乎不可挽回的行为，可以"急剧提升"或"彻底摧毁"该状态。

	To test the variable, the following queries are provided: "high", "up", "mid", "down", "low".
	/ 要测试该变量，提供了以下查询："高"、"偏高"、"中等"、"偏低"、"低"。

	Note that the system won't return a "up" or "down" result until the player has taken a few choices to seed the system.
	/ 请注意，在玩家做出几个选择来为系统提供种子数据之前，系统不会返回"偏高"或"偏低"的结果。


	Usage: / 用法：

	// initialise the variable / 初始化变量
	VAR niceness = INITIAL_SWING

	// alter the variable / 修改变量
	~ raise(niceness) 		// note a nice choice / 记录一个友善的选择
	~ lower(niceness)		// note a nasty choice / 记录一个恶劣的选择

	// test the variable / 测试变量
	I'm <> / 我是<>
	{
	- up(niceness):
		nice / 友善的
	- down(niceness):
		nasty / 恶劣的
	- else:
		undecided / 尚未确定
	}
	<>.


*/


CONST INITIAL_SWING = 1001

=== function swing_count(x)
    ~ return (upness(x) + downness(x)) - 2

=== function swing_ready(x)
    ~ return swing_count(x) >= 2

=== function raise(ref x)
	~ x = x + 1000



=== function elevate(ref x)
    ~ raise(x)
    ~ raise(x)
    ~ raise(x)

=== function lower(ref x)
	~ x = x + 1

== function ditch (ref x)
    ~ lower(x)
    ~ lower(x)
    ~ lower(x)

=== function demolish(ref x)
    ~ x = x + 20

=== function escalate(ref x)
    ~ x = x + (20 * 1000)



=== function upness(x)
	~ return x / 1000

=== function downness(x)
	~ return x % 1000


=== function high(x)
    ~ return (1 * upness(x) >= downness(x) * 9)

=== function up(x)
	~ return swing_ready(x) && (4 * upness(x) >= downness(x) * 6)

=== function down(x)
	~ return swing_ready(x) && (6 * upness(x) <= downness(x) * 4)

=== function low(x)
	~ return swing_ready(x) && (9 * upness(x) <= downness(x) * 1)

=== function mid(x)
    // If the swing isn't ready this returns true / 如果摇摆尚未就绪，则返回 true
    // Because "up is false and down is false" / 因为"up 为 false 且 down 为 false"
    ~ return (not up(x) && not down(x))
