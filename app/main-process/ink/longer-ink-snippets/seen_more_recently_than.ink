/*
	Tests if the flow has reached one divert more recently than another. / 测试流程是否比另一个跳转更近期地到达了某个跳转点。

	If we have never reached the first divert, we return false. / 如果从未到达过第一个跳转点，则返回 false。
	If we have never reached the second divert, we return true. / 如果从未到达过第二个跳转点，则返回 true。

	This is especially useful for testing "have we done X this scene". / 这对于测试"我们是否在本场景中做过 X"特别有用。

	Usage: / 用法：

	- (start_of_scene)
		"Welcome!" / "欢迎！"

	- (opts)
		<- cough_politely(-> opts)

		*	{ seen_more_recently_than(-> cough_politely.cough, -> start_of_scene) }
			"Hello!" / "你好！"

		+	{ not seen_more_recently_than(-> cough_politely.cough, -> start_of_scene) }
			["Hello!"] / ["你好！"]
			I try to speak, but I can't get the words out! / 我试图说话，但说不出话来！
			-> opts



	=== cough_politely(-> go_to)
		*	(cough) [Cough politely] / [礼貌地咳嗽]
			I clear my throat. / 我清了清嗓子。
			-> go_to

*/

=== function seen_more_recently_than(-> link, -> marker)
	{ TURNS_SINCE(link) >= 0:
        { TURNS_SINCE(marker) == -1:
            ~ return true
        }
        ~ return TURNS_SINCE(link) < TURNS_SINCE(marker)
    }
    ~ return false
