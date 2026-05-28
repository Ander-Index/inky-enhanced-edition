/*
	Threads in a given flow as a tunnel, with a given location to tunnel back to. / 将给定流程中的分支视为隧道，并指定返回的目标位置。

	If choices within this content are taken, they should end with a tunnel return (->->).
	/ 如果此内容中的选项被选择，它们应以隧道返回（->->）结束。

	Useful for "pasting in" the same block of optional content into multiple locations.
	/ 适用于将同一块可选内容"粘贴"到多个位置。

	Usage: / 用法：


	- (opts)
		<- thread_in_tunnel(-> eat_apple, -> opts)
		<- thread_in_tunnel(-> eat_banana, -> get_going)
		*	[ Leave hungry ] / [饿着离开]
			-> get_going

	=== get_going
		You leave. / 你离开了。
		-> END

	=== eat_apple
		*	[ Eat an apple ] / [吃个苹果]
			You eat an apple. It doesn't help. / 你吃了个苹果。没什么帮助。
			->->

	=== eat_banana
		*	[ Eat a banana ] / [吃根香蕉]
			You eat a banana. It's very satisfying. / 你吃了根香蕉。非常满足。
			->->


*/

=== thread_in_tunnel(-> tunnel_to_run, -> place_to_return_to)

    ~ temp entryTurnChoice = TURNS()

    -> tunnel_to_run ->

 	// if the tunnel contained choices which were chosen, then the turn count will
 	// have increased, so we should use the given return point to continue the flow.
 	// 如果隧道中包含被选择的选项，那么回合计数将增加，因此我们应该使用给定的返回点来继续流程。
    {entryTurnChoice != TURNS():
        -> place_to_return_to
    }

    // otherwise the given tunnel simply ran through, in which case we should treat
    // this as a side-thread, and close it down.
    // 否则，给定的隧道只是简单贯穿，在这种情况下我们应将其视为旁支线程，并结束它。
    -> DONE
