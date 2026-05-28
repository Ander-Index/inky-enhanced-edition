/*
	Tests if the flow has reached a particular gather "this scene". This is an extension of "seen_more_recently_than", but it's so useful it's worth having separately. / 测试流程是否"在本场景中"到达了某个特定的 gather 点。这是 "seen_more_recently_than" 的扩展，但它非常有用，值得单独存在。

	Usage: / 用法：

	// define where the start of the scene is / 定义场景的开始位置
	~ sceneStart = -> start_of_scene

	- (start_of_scene)
		"Welcome!" / "欢迎！"

	- (opts)
		<- cough_politely(-> opts)

		*	{ seen_this_scene(-> cough_politely.cough) }
			"Hello!" / "你好！"

		+	{ not seen_this_scene(-> cough_politely.cough) }
			["Hello!"] / ["你好！"]
			I try to speak, but I can't get the words out! / 我试图说话，但说不出话来！
			-> opts



	=== cough_politely(-> go_to)
		*	(cough) [Cough politely] / [礼貌地咳嗽]
			I clear my throat. / 我清了清嗓子。
			-> go_to

*/


VAR sceneStart = -> seen_this_scene

=== function seen_this_scene(-> link)
	{  sceneStart == -> seen_this_scene:
		[ERROR] - you need to initialise the sceneStart variable before using "seen_this_scene"! / [错误] - 在使用 "seen_this_scene" 之前，你需要初始化 sceneStart 变量！
		~ return false
	}
	~ return seen_more_recently_than(link, sceneStart)


=== function seen_more_recently_than(-> link, -> marker)
	{ TURNS_SINCE(link) >= 0:
        { TURNS_SINCE(marker) == -1:
            ~ return true
        }
        ~ return TURNS_SINCE(link) < TURNS_SINCE(marker)
    }
    ~ return false
