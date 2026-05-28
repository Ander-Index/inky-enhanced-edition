// Character variables. We track just two, using a +/- scale / 角色变量。我们只追踪两个，使用 +/- 刻度
VAR forceful = 0
VAR evasive = 0


// Inventory Items / 物品栏物品
VAR teacup = false
VAR gotcomponent = false


// Story states: these can be done using read counts of knots; or functions that collect up more complex logic; or variables / 故事状态：这些可以通过节点的读取计数、收集更复杂逻辑的函数或变量来实现
VAR drugged = false
VAR hooper_mentioned = false

VAR losttemper = false
VAR admitblackmail = false

// what kind of clue did we pass to Hooper? / 我们给 Hooper 传递了什么类型的线索？
CONST NONE = 0
CONST STRAIGHT = 1
CONST CHESS = 2
CONST CROSSWORD = 3
VAR hooperClueType = NONE

VAR hooperConfessed = false

CONST SHOE = 1
CONST BUCKET = 2
VAR smashingWindowItem = NONE

VAR notraitor = false
VAR revealedhooperasculprit = false
VAR smashedglass = false
VAR muddyshoes = false

VAR framedhooper = false

// What did you do with the component? / 你对元件做了什么？
VAR putcomponentintent = false
VAR throwncomponentaway = false
VAR piecereturned = false
VAR longgrasshooperframe = false


// DEBUG mode adds a few shortcuts - remember to set to false in release! / 调试模式添加了一些快捷方式——发布时记得设为 false！
VAR DEBUG = false
{DEBUG:
	IN DEBUG MODE! / 调试模式！
	*	[Beginning...]	-> start / [开始……]	-> start
	*	[Framing Hooper...] -> claim_hooper_took_component / [陷害 Hooper……] -> claim_hooper_took_component
	*	[In with Hooper...] -> inside_hoopers_hut / [跟 Hooper 在一起……] -> inside_hoopers_hut
- else:
	// First diversion: where do we begin? / 第一个转向：我们从哪里开始？
 -> start
}

 /*--------------------------------------------------------------------------------
	Wrap up character movement using functions, in case we want to develop this logic in future / 使用函数封装角色移动，以备将来我们想开发此逻辑
--------------------------------------------------------------------------------*/


 === function lower(ref x)
 	~ x = x - 1

 === function raise(ref x)
 	~ x = x + 1

/*--------------------------------------------------------------------------------

	Start the story! / 开始故事！

--------------------------------------------------------------------------------*/

=== start ===

//  Intro / 开场
	- 	They are keeping me waiting. / 他们让我等着。
		*	Hut 14[]. The door was locked after I sat down. / 14 号小屋[]。我坐下后门就被锁上了。
		I don't even have a pen to do any work. There's a copy of the morning's intercept in my pocket, but staring at the jumbled letters will only drive me mad. / 我连一支笔都没有，没法工作。口袋里有一份今早的拦截密文，但盯着那些杂乱的字母只会让我发疯。
		I am not a machine, whatever they say about me. / 我不是机器，不管他们怎么说我。

	- (opts)
		{|I rattle my fingers on the field table.|} / {|我用手指在野战桌上敲击。|}
 		* 	(think) [Think] / [思考]
 			They suspect me to be a traitor. They think I stole the component from the calculating machine. They will be searching my bunk and cases. / 他们怀疑我是叛徒。他们以为我从计算机上偷了元件。他们会搜查我的铺位和箱子。
			When they don't find it, {plan:then} they'll come back and demand I talk. / 当他们找不到时，{plan:那么}他们会回来要求我开口。
			-> opts
 		*	(plan) [Plan] / [谋划]
 			{not think:What I am is|I am} a problem—solver. Good with figures, quick with crosswords, excellent at chess. / {not think:我是什么？我是|我是一个}解题者。擅长数字，填字快，棋艺精湛。
 			But in this scenario — in this trap — what is the winning play? / 但在这个情境下——在这个陷阱中——制胜的一步是什么？
 			* * 	(cooperate) [Co—operate] / [合作]
	 				I must co—operate. My credibility is my main asset. To contradict myself, or another source, would be fatal. / 我必须合作。我的信誉是我主要的资产。自相矛盾，或与另一个来源矛盾，将是致命的。
	 				I must simply hope they do not ask the questions I do not want to answer. / 我只希望他们不要问我那些我不想回答的问题。
		 			~ lower(forceful)
	 		* * 	[Dissemble] / [掩饰]
		 			Misinformation, then. Just as the war in Europe is one of plans and interceptions, not planes and bombs. / 那么，就假情报吧。正如欧洲战争是计划和情报之战，而非飞机和炸弹之战。
		 			My best hope is a story they prefer to the truth. / 我最大的希望是编织一个他们宁愿相信而非真相的故事。
		 			~ raise(forceful)
	 		* * 	(delay) [Divert] / [转移]
		 			Avoidance and delay. The military machine never fights on a single front. If I move slowly enough, things will resolve themselves some other way, my reputation intact. / 回避和拖延。军事机器从不只在一条战线上作战。如果我行动足够慢，事情会以其他方式自行解决，我的名誉完好无损。
		 			~ raise(evasive)
		*	[Wait]	/ [等待]
	- 	-> waited

= waited
	-	Half an hour goes by before Commander Harris returns. He closes the door behind him quickly, as though afraid a loose word might slip inside. / 半小时过去了，Harris 指挥官才回来。他迅速关上了身后的门，好像害怕有闲言碎语溜进来。
		"Well, then," he begins, awkwardly. This is an unseemly situation. / "好吧，"他尴尬地开口。这是个不体面的局面。
		*	"Commander." / "指挥官。"
			He nods. <> / 他点点头。<>
		*	(tellme) {not start.delay} "Tell me what this is about." / "告诉我这是怎么回事。"
			He shakes his head. / 他摇摇头。
			"Now, don't let's pretend." / "现在，别让我们假装了。"
		*	[Wait] / [等待]
			I say nothing. / 我什么也没说。
	-	He has brought two cups of tea in metal mugs: he sets them down on the tabletop between us. / 他端来了两杯用金属杯装的茶：他把它们放在我们之间的桌面上。
		*	{tellme} [Deny] "I'm not pretending anything." / "我什么也没有假装。"
			{cooperate:I'm lying already, despite my good intentions.} / {cooperate:尽管我本意良好，我已经在撒谎了。}
			Harris looks disapproving. -> pushes_cup / Harris 露出不以为然的表情。
		*	(took) [Take one] / [拿一杯]
			~ teacup = true
			I take a mug and warm my hands. It's <> / 我拿起杯子暖手。它是<>
		*	(what2) {not tellme} "What's going on?" / "发生什么事了？"
			"You know already." / "你已经知道了。"
			-> pushes_cup
		*	[Wait] / [等待]
			I wait for him to speak. / 我等着他开口。
			- - (pushes_cup) He pushes one mug halfway towards me: <> / 他把一个杯子推到我面前一半的距离：<>
	-	a small gesture of friendship. / 一个表示友谊的小小姿态。
		Enough to give me hope? / 足以给我希望吗？
 		* 	(lift_up_cup) {not teacup} [Take it] / [拿起来]
 				I {took:lift the mug|take the mug,} and blow away the steam. It is too hot to drink. / 我{took:拿起杯子|拿起杯子，}吹散蒸汽。太烫了，没法喝。
 				Harris picks his own up and just holds it. / Harris 拿起他自己的杯子，只是端着。
 				~ teacup = true
 				~ lower(forceful)
 		* 	{not teacup} [Don't take it] / [不拿]
 				Just a cup of insipid canteen tea. I leave it where it is. / 不过是一杯淡而无味的食堂茶。我让它留在原处。
 				~ raise(forceful)

		*	{teacup} 	[Drink] / [喝]
				I raise the cup to my mouth but it's too hot to drink. / 我把杯子举到嘴边，但太烫了，没法喝。

		*	{teacup} 	[Wait] / [等待]
			I say nothing as -> lift_up_cup

- 	"Quite a difficult situation," {lift_up_cup:he|Harris} begins{forceful <= 0:, sternly}. I've seen him adopt this stiff tone of voice before, but only when talking to the brass. "I'm sure you agree." / "相当困难的局面，" {lift_up_cup:他|Harris} 开口{forceful <= 0:, 严厉地}。我以前见过他用这种生硬的语气说话，但只在跟高级军官交谈时。"我相信你同意。"
 		* 	[Agree] / [同意]
 				"Awkward," I reply / "尴尬，"我回答
 		* 	(disagree) [Disagree] / [不同意]
 				"I don't see why," I reply / "我不明白为什么，"我回答
				 ~ raise(forceful)
				 ~ raise(evasive)
 		* 	[Lie] -> disagree / [撒谎] -> disagree
 		* 	[Evade] / [回避]
 				"I'm sure you've handled worse," I reply casually / "我相信你处理过更糟的情况，"我随意地回答
 				~ raise(evasive)
	- 	{ teacup:
 			~ drugged  = true
			<>, sipping at my tea as though we were old friends / <>, 啜饮着茶，仿佛我们是老朋友
 	  	}
		<>.

 	-
 		*	[Watch him] / [观察他]
			His face is telling me nothing. I've seen Harris broad and full of laughter. Today he is tight, as much part of the military machine as the device in Hut 5. / 他的脸什么也没告诉我。我见过 Harris 开怀大笑的样子。今天他很紧绷，跟 5 号小屋里的设备一样是军事机器的一部分。

 		*	[Wait] / [等待]
 			I wait to see how he'll respond. / 我等着看他如何回应。

 		*	{not disagree} [Smile] / [微笑]
 			I try a weak smile. It is not returned. / 我试图挤出一个微弱的微笑。没有得到回应。
 			~ lower(forceful)

// Why you're here / 为什么你在这里
	-
		"We need that component," he says. / "我们需要那个元件，"他说。

	-	//"There's no alternative, of course," he continues. / "当然，别无选择，"他继续说。
		{not missing_reel:
			-> missing_reel -> harris_demands_component
		}
	-
 		* 	[Yes] / [是的]
 			"Of course I do," I answer. / "我当然知道了，"我回答。
 		* (no) [No] / [不知道]
 			"No I don't. And I've got work to do..." / "不，我不知道。我还有工作要做……"
			"Work that will be rather difficult for you to do, don't you think?" Harris interrupts. / "这工作对你来说恐怕会相当困难，你不觉得吗？" Harris 打断道。

 		* 	[Evade] / [回避]
 				-> here_at_bletchley_diversion
 		* 	[Lie] / [撒谎]
 				-> no
 	-	-> missing_reel -> harris_demands_component

=== missing_reel ===
	*	[The stolen component...] / [被偷的元件……]
	*	[Shrug] / [耸肩]
		I shrug. / 我耸耸肩。
		->->
	- 	The reel went missing from the Bombe this afternoon. The four of us were in the Hut, working on the latest German intercept. The results were garbage. It was Russell who found the gap in the plugboard. / 今天下午，卷轴从 Bombe 机中丢失了。我们四个人都在小屋里，正在处理最新的德国密文。结果全是垃圾。是 Russell 发现了插线板上的空缺。
	-	Any of us could have taken it; and no one else would have known its worth. / 我们中任何人都可能拿走它；而且没有其他人会知道它的价值。

 		*	{forceful <= 0 }[Panic] They will pin it on me. They need a scapegoat so that the work can continue. I'm a likely target. Weaker than the rest. / [恐慌] 他们会把它栽到我头上。他们需要一个替罪羊，这样工作才能继续。我是一个可能的目标。比别人更软弱。
 			~ lower(forceful)
 		*	[Calculate] My odds, then, are one in four. Not bad; although the stakes themselves are higher than I would like. / [算计] 那么，我的概率是四分之一。不错；虽然赌注本身比我期望的要高。
 			~ raise(evasive)
 		*	{evasive >= 0} [Deny] But this is still a mere formality. The work will not stop. A replacement component will be made and we will all be put back to work. We are too valuable to shoot. / [否认] 但这仍然只是走个形式。工作不会停止。会制造一个替换元件，我们都会被放回去工作。我们太有价值了，不能被枪毙。
 			~ raise(forceful)
 	-	->->


=== here_at_bletchley_diversion
	"Here at Bletchley? Of course." / "在 Bletchley？当然。"
 	~ raise(evasive)
 	~ lower(forceful)
	"Here, now," Harris corrects. "We are not talking to everyone. I can imagine you might feel pretty sore about that. I can imagine you feeling picked on. { forceful < 0:You're a sensitive soul.}" / "这里，现在，" Harris 纠正道。"我们不是找每个人谈话。我可以想象你会因此感到很不痛快。我可以想象你觉得自己被针对了。{ forceful < 0:你是个敏感的人。}"

 	* (fine) "I'm fine[."]," I reply. "This is all some misunderstanding and the quicker we have it cleared up the better." / "我没事[。']"我回答。"这都是一场误会，我们越快澄清越好。"
 		~ lower(forceful)
		"I couldn't agree more." And then he comes right out with it, with an accusation. / "我完全同意。"然后他开门见山，提出了指控。

	*	{forceful < 0}	"What do you mean by that?" / "你这是什么意思？"

 	* (sore) { forceful >= 0 } "Damn right[."] I'm sore. Was it one of the others who put you up to this? Was it Hooper? He's always been jealous of me. He's..." / "说得对[。']我很不痛快。是其他人之一唆使你来的吗？是 Hooper 吗？他一直嫉妒我。他……"
 		~ raise(forceful)
 		~ hooper_mentioned = true
		The Commander moustache bristles as he purses his lips. "Has he now? Of your achievements, do you think?" / 指挥官的胡子在他抿紧嘴唇时竖了起来。"是吗？嫉妒你的成就，你觉得呢？"
 		It's difficult not to shake the sense that he's { evasive > 1 :mocking|simply humouring} me. / 很难不感到他是在{ evasive > 1 :嘲讽|仅仅哄着}我。
		"Or of your brain? Or something else?" / "还是你的脑子？还是别的什么？"
 		* * 	"Of my genius.["] Hooper simply can't stand that I'm cleverer than he is. We work so closely together, cooped up in that Hut all day. It drives him to distraction. To worse." / "我的天才。[。'] Hooper 就是无法忍受我比他聪明。我们如此紧密地合作，整天关在那个小屋里。这让他发疯。甚至更糟。"
				"You're suggesting Hooper would sabotage this country's future simply to spite you?" Harris chooses his words like the military man he is, each lining up to create a ring around me. / "你是在暗示 Hooper 会仅仅为了刁难你就破坏这个国家的未来？" Harris 像他这样的军人一样措辞，每一个字都排列起来在我周围形成包围圈。
 					* * * 	[Yes] / [是的]
	 							"{ forceful > 0:He's petty enough, certainly|I wouldn't put it past him}. He's a creep." { teacup : I set the teacup down.|I wipe a hand across my forehead.} / "{ forceful > 0:他当然够卑鄙了|我敢说他会这么做}。他是个小人。" { teacup : 我把茶杯放下。|我用手擦了一下额头。}
	 							~ raise(forceful)
	 							~ teacup = false
 					* * * 	[No] / [不]
	 							"No, { forceful >0:of course not|I suppose not}." { teacup :I put the teacup back down on the table|I push the teacup around on its base}. / "不，{ forceful >0:当然不会|我想不会}。" { teacup :我把茶杯放回桌上|我把茶杯在底座上转来转去}。
							 	~ lower(forceful)
								~ teacup = false
 					* * * 	[Evade] / [回避]
	 							"I don't know what I'm suggesting. I don't understand what's going on." / "我不知道我在暗示什么。我不明白发生了什么事。"
	 							~ raise(evasive)
								"But of course you do." Harris narrows his eyes. / "但你当然知道。" Harris 眯起眼睛。
								-> done

					- - - 	(suggest_its_a_lie) "All I can say is, ever since I arrived here, he's been looking to ways to bring me down a peg. I wouldn't be surprised if he set this whole affair up just to have me court—martialled." / "我只能说，自从我来到这里，他就一直在找办法让我丢脸。如果他策划这一切就是为了让我上军事法庭，我也不会感到惊讶。"
							"We don't court—martial civilians," Harris replies. "Traitors are simply hung at her Majesty's pleasure." / "我们不对平民进行军事审判，" Harris 回答。"叛国者只需按女王陛下的旨意被绞死。"
 					* * * 	"Quite right[."]," I answer smartly. / "很正确[。']"我爽快地回答。
 					* * * 	(iamnotraitor) "I'm no traitor[."]," I answer{forceful > 0 :smartly|, voice quivering. "For God's sake!"} / "我不是叛徒[。']"我回答{forceful > 0 :爽快地|，声音颤抖着。"看在上帝份上！"}
 					* * * 	[Lie] -> iamnotraitor / [撒谎] -> iamnotraitor
					- - - He stares back at me. / 他盯着我看。

 		* * 	"Of my standing.["] My reputation." { forceful > 0:I'm aware of how arrogant I must sound but I plough on all the same.|I don't like to talk of myself like this, but I carry on all the same.} "Hooper simply can't bear knowing that, once all this is over, I'll be the one receiving the knighthood and he..." / "我的地位。[。'] 我的声誉。" { forceful > 0:我知道这听起来一定很傲慢，但我还是继续说下去。|我不喜欢这样谈论自己，但我还是继续说下去。} "Hooper 实在无法忍受知道，一旦这一切结束，我将是获得爵位的那个人，而他……"
				"No—one will be getting a knighthood if the Germans make landfall," Harris answers sharply. He casts a quick eye to the door of the Hut to check the latch is still down, then continues in more of a murmur: "Not you and not Hooper. Now answer me." / "如果德国人登陆，没有人会获得爵位，" Harris 尖刻地回答。他迅速瞥了一眼小屋的门，确认门闩还插着，然后用更像是低语的声音继续说："不是你，也不是 Hooper。现在回答我。"
				For the first time since the door closed, I wonder what the threat might be if I do <i>not</i>. / 自从门关上以来，我第一次想到，如果我不回答，威胁会是什么。

 		* * 	[Evade] / [回避]
 				~ teacup = false
 				~ raise(forceful)
 				"How should I know?" I reply, defensively. { teacup :I set the teacup back on the table.}  -> suggest_its_a_lie / "我怎么会知道？"我防御性地回答。{ teacup :我把茶杯放回桌上。} -> suggest_its_a_lie


 	* [Be honest] 	-> sore / [诚实] -> sore
 	* [Lie] 		-> fine / [撒谎] -> fine

-	(done) -> harris_demands_component


=== harris_demands_component ===
	"{here_at_bletchley_diversion:Please|So}. Do you have it?" Harris is {forceful > 3:sweating slightly|wasting no time}: Bletchley is his watch. "Do you know where it is?" / "{here_at_bletchley_diversion:请|那么}。你拿着了吗？" Harris {forceful > 3:微微出汗|没有浪费时间}：Bletchley 是他的职责范围。"你知道它在哪里吗？"
	 	* 	[Yes] / [是的]
	 		"I do." / "我知道。"
	 		-> admitted_to_something
	 	* (nope) [No] "I have no idea." / "我不知道。"
	 					-> silence
	 	* [Lie] 		-> nope / [撒谎] -> nope
	 	* [Evade] / [回避]
	 		"The component?" / "那个元件？"
			 ~ raise(evasive)
			 ~ lower(forceful)
			"Don't play stupid," he replies. "{ not missing_reel:The component that went missing this afternoon. }Where is it?" / "别装傻，"他回答。"{ not missing_reel:今天下午丢失的那个元件。}它在哪里？"

	- 	{ not missing_reel:
			-> missing_reel ->
		}
 		* 	[Co-operate] "I know where it is." / [合作] "我知道它在哪里。"
 			-> admitted_to_something
 		* (nothing) [Delay] "I know nothing about it." My voice shakes{ forceful > 0:  with anger|; I'm unaccustomed to facing off against men with holstered guns}. / [拖延] "我对此一无所知。"我的声音在颤抖{ forceful > 0: 因愤怒|; 我不习惯与佩枪的人对抗}。

 		* [Lie] -> nothing / [撒谎] -> nothing
 		* [Evade] / [回避]

			"I don't know what gives you the right to pick on me. { forceful > 0:I demand a lawyer.|I want a lawyer.}" / "我不知道你有什么权利找我的麻烦。{ forceful > 0:我要求见律师。|我要见律师。}"

			"This is time of war," Harris answers.  "And by God, if I have to shoot you to recover the component, I will. Understand?" He points at the mug,-> drinkit / "这是战时，" Harris 回答。"而且，以上帝之名，如果我必须枪毙你才能找回元件，我会的。明白吗？"他指着杯子，-> drinkit

		-	(silence) There's an icy silence. { forceful > 2:I've cracked him a little.|{ evasive > 2:He's tiring of my evasiveness.}} / 一阵冰冷的沉默。{ forceful > 2:我让他有点动摇了。|{ evasive > 2:他对我的回避感到厌倦了。}}

		// Drink tea and talk / 喝茶然后谈话
		- (drinkit) "Now drink your tea and talk." / "现在喝你的茶，然后说话。"
		 * { teacup  }   	[Drink] 			-> drinkfromcup / [喝] -> drinkfromcup
		 * { teacup  }   	[Put the cup down] / [放下杯子]
		 		I set the cup carefully down on the table once more. / 我再次小心地把杯子放在桌上。
				~ teacup = false
				~ raise(forceful)
				-> whatsinit

		 * { not teacup  }  [Take the cup] / [拿起杯子]
		 		- - (drinkfromcup) I lift the cup { teacup :to my lips }and sip. He waits for me to swallow before speaking again. / 我举起杯子{ teacup :到嘴边}啜饮。他等我咽下去才再次说话。
			 		~ drugged  = true
			 		~ teacup    = true
		 * { not teacup  }  [Don't take it] / [不拿]
		 		I leave the cup where it is. / 我让杯子留在原处。
				~ raise(forceful)
				- - (whatsinit) "Why?" I ask coldly. "What's in it?" / "为什么？"我冷冷地问。"里面有什么？"

	- 	"Lapsang Souchong," he {drinkfromcup:remarks|replies}, placing his own cup back on the table untouched. "Such a curious flavour. It might almost not be tea at all. You might say it hides a multitude of sins. As do you. Isn't that right?" / "正山小种，"他{drinkfromcup:评论道|回答}，把自己那杯未动的茶放回桌上。"如此奇特的味道。它几乎可能根本不是茶。你可以说它隐藏了诸多罪恶。就像你一样。难道不是吗？"

		 * (suppose_i_have) [Agree] / [同意]
			 	// Regrets / 遗憾
				"I suppose so," I reply. "I've done things I shouldn't have done." / "我想是的，"我回答。"我做了一些不该做的事。"
				 ~ lower(forceful)
				 -> harris_presses_for_details

		* (nothing_ashamed_of) { not drugged  }   [Disagree] / [不同意]
		 		"I've done nothing that I'm ashamed of." / "我没有做过任何让我感到羞耻的事。"
 				-> harris_asks_for_theory

		 * (cant_talk_right) { drugged  }   [Disagree] / [不同意]
			 	I open my mouth to disagree, but the words I want won't come. It is like Harris has taken a screwdriver to the sides of my jaw. / 我张开嘴想要反驳，但我想说的话说不出来。就像 Harris 用螺丝刀撬开了我的下颌两侧。
 				-> admitted_to_something.ive_done_things

 		 * {drugged} [Lie] 	-> cant_talk_right / [撒谎] -> cant_talk_right
 		 * {not drugged} [Lie] 	-> nothing_ashamed_of / [撒谎] -> nothing_ashamed_of
		 * { drugged  }   [Evade] -> cant_talk_right / [回避] -> cant_talk_right

		 * { not drugged  }   [Evade] / [回避]
		 		"None of us are blameless, Harris. { forceful > 1:But you're not my priest and I'm not yours|But I've done nothing to deserve this treatment}. Now, please. Let me go. I'll help you find this damn component, of course I will." / "我们没有人是无辜的，Harris。{ forceful > 1:但你不是我的牧师，我也不是你的|但我没有做任何该受此待遇的事}。现在，拜托。让我走吧。我会帮你找到这个该死的元件，我当然会的。"
				//   Who do you blame? / 你怪谁？
				He appears to consider the offer. / 他似乎正在考虑这个提议。
				 -> harris_asks_for_theory



=== harris_presses_for_details
// Open to Blackmail / 可被敲诈
	"You mean you've left yourself open," Harris answers. "To pressure. Is that what you're saying?" / "你是说你让自己暴露了，" Harris 回答。"暴露于压力之下。你是这个意思吗？"
	 	* [Yes] -> admit_open_to_pressure / [是] -> admit_open_to_pressure
	 	* { not drugged  } [No] / [不]
	 			"I'm not saying anything of the sort," I snap back. "What is this, Harris? You're accusing me of treachery but I don't see a shred of evidence for it! Why don't you put your cards on the table?" / "我不是在说这种话，"我厉声回应。"这是什么意思，Harris？你在指控我叛国，但我看不到一丝证据！你为什么不肯摊牌？"
			 	~ raise(forceful)


	 	* {drugged} [No] / [不]
	 			I shake my head violently, to say no, that's not it, but whatever is wrong with tongue is wrong with neck too. I look across at the table at Harris' face and realise with a start how sympathetic he is. Such a kind, generous man. How can I hold anything back from him? / 我猛烈地摇头，想说不是的，不是那样的，但舌头不对劲，脖子也不对劲。我隔着桌子看向 Harris 的脸，突然意识到他是多么富有同情心。如此善良、慷慨的人。我怎么能对他有所隐瞒呢？
			 	~ lower(forceful)
				I take another mouthful of the bitter, strange—tasting tea before answering. / 在回答之前，我又喝了一口那苦涩、味道奇怪的茶。
			 	-> admit_open_to_pressure


	 	* { not drugged  } [Evade] / [回避]
	 			"You're the one applying pressure here," I answer { forceful > 1:smartly|somewhat miserably}. "I'm just waiting until you tell me what is really going on." / "在这里施加压力的人是你，"我回答{ forceful > 1:爽快地|有些凄惨地}。"我只是在等你告诉我到底发生了什么事。"
				 ~ raise(evasive)
	 	* { drugged  } [Evade] / [回避]
	 			"We're all under pressure here." / "我们在这里都承受着压力。"
	 			He looks at me with pity. -> harris_has_seen_it_before / 他怜悯地看着我。-> harris_has_seen_it_before

 	-	"It's simple enough," Harris says. -> harris_has_seen_it_before / "很简单，" Harris 说。-> harris_has_seen_it_before

= admit_open_to_pressure
	"That's it," I reply. "There are some things... which a man shouldn't do." / "就是这样，"我回答。"有些事情……是一个人不应该做的。"
	 ~ admitblackmail  = true
	Harris doesn't stiffen. Doesn't lean away, as though my condition might be infectious. I had thought they trained them in the army to shoot my kind on sight. / Harris 没有僵住。没有退后，好像我的状况会传染一样。我原以为军队训练他们就是为了见到我这种人当场击毙。
	He offers no sympathy either. He nods, once. His understanding of me is a mere turning cog in his calculations, with no meaning to it. / 他也没有表示同情。他点了一下头。他对我的理解只是他计算中一个转动的齿轮，没有意义。
 	-> harris_has_seen_it_before


=== admitted_to_something
	// Admitting Something / 承认某事
	{ not drugged  :
		Harris stares back at me. { evasive == 0:He cannot have expected it to be so easy to break me.} / Harris 盯着我看。{ evasive == 0:他不可能料到如此容易就击垮了我。}
	- else:
		Harris smiles with satisfaction, as if your willingness to talk was somehow his doing. / Harris 满意地笑了，好像你愿意开口说话在某种程度上是他的功劳。
	}
	"I see." / "我明白了。"
	There's a long pause, like the delay between feeding a line of cypher into the Bombe and waiting for its valves to warm up enough to begin processing. / 一阵长时间的停顿，就像将一行密文输入 Bombe 后，等待它的真空管加热到足以开始处理的那个延迟。
	"You want to explain that?" / "你想解释一下吗？"
		 * 	[Explain] / [解释]
		 	I pause a moment, trying to choose my words. To just come out and say it, after a lifetime of hiding... that is a circle I cannot square. / 我停顿片刻，试图选择措辞。在隐藏了一辈子之后，就这样脱口而出……这是一个我无法化圆为方的难题。
		 	* * 	[Explain] 	-> ive_done_things / [解释] -> ive_done_things
		 	* * 	{drugged} [Say nothing] 	-> say_nothing / [什么都不说] -> say_nothing
		 	* * 	{not drugged} [Lie] 	-> claim_hooper_took_component / [撒谎] -> claim_hooper_took_component

		 * { not drugged  }   [Don't explain] / [不解释]
		 		"There's nothing to explain," I reply stiffly. -> i_know_where / "没什么需要解释的，"我生硬地回答。-> i_know_where

		 * { not drugged  }   [Lie] -> claim_hooper_took_component / [撒谎] -> claim_hooper_took_component
		 * { not drugged  }   [Evade] / [回避]
		 	"Explain what you should be doing, do you mean, rather than bullying me? Certainly." I fold my arms. -> i_know_where / "你是说解释你应该做什么，而不是欺负我？当然可以。"我抱起双臂。-> i_know_where

		 * (say_nothing) { drugged  }   [Say nothing] / [什么都不说]
		 	I fold my arms, intended firmly to say nothing. But somehow, watching Harris' face, I cannot bring myself to do it. I want to confess. I want to tell him everything I can, to explain myself to him, to earn his forgiveness. The sensation is so strong my will is powerless in the face of it. / 我抱起双臂，决意什么都不说。但不知何故，看着 Harris 的脸，我做不到。我想坦白。我想尽我所能地告诉他一切，向他解释自己，赢得他的原谅。这种感觉如此强烈，我的意志在它面前无能为力。
			Something is wrong with me, I am sure of it. There is a strange, bitter flavour on my tongue. I taste it as words start to form. / 我肯定有什么不对劲。我的舌头上有一股奇怪的苦味。当话语开始形成时，我尝到了它。
		 	-> ive_done_things

= i_know_where
	"I know where your component is because it's obvious where your component is. That doesn't mean I took it, just because I can figure out a simple problem, any more than it means I'm a German spy because I can crack their codes." / "我知道你的元件在哪里，因为它在哪是显而易见的。这并不意味着我拿了它，仅仅因为我能想通一个简单的问题，就像我能破解德国人的密码不意味着我是德国间谍一样。"
	-> harris_asks_for_theory


= ive_done_things
	 "I've done things," I begin{harris_demands_component.cant_talk_right: helplessly}. "Things I didn't want to do. I tried not to. But in the end, it felt like cutting off my own arm to resist." / "我做了一些事，"我{harris_demands_component.cant_talk_right: 无助地}开始说。"我不愿意做的事。我试图不去做。但最终，抗拒的感觉就像砍掉自己的手臂一样。"
	-> harris_presses_for_details




=== harris_asks_for_theory
"Tell me, then," he asks. "What's your theory? You're a smart fellow — as smart as they come around here, and that's saying something. What's your opinion on the missing component? Accident, perhaps? Or do you blame one of the other men? { hooper_mentioned :Hooper?}" / "那么告诉我，"他问道。"你的理论是什么？你是个聪明人——这里最聪明的人之一，这可是很了不起的。你对丢失的元件有什么看法？也许是意外？还是你怪罪其他某个人？{ hooper_mentioned :Hooper？}"
 	* [Blame no—one] / [不怪任何人]
 		-> an_accident
 	* [Blame someone] -> claim_hooper_took_component / [怪某个人] -> claim_hooper_took_component

= an_accident
	"An accident, naturally." I risk a smile. "That damned machine is made from spare parts and string. Even these Huts leak when it rains. It wouldn't take more than one fellow to trip over a cable to shake out a component. Have you tried looking under the thing?" / "意外，当然是意外。"我冒险微笑了一下。"那台该死的机器是用旧零件和绳子拼凑的。下雨时连这些小木屋都漏水。一个家伙只要绊到一根电缆，就能震出一个元件来。你试过看看那东西下面吗？"
	"Do you believe we haven't?" / "你觉得我们会没试过吗？"
	In a sudden moment I understand that his reply is a threat. / 刹那间我明白了，他的回答是一个威胁。
	"Now," he continues. "Are you sure there isn't anything you want to tell me?" / "现在，"他继续说。"你确定没有什么想告诉我的吗？"

	 * [Co-operate] / [合作]
	 	"All right." With a sigh, your defiance collapses. "If you're searched my things then I suppose you've found { evasive > 1: what you need|my letters. Haven't you? In fact, if you haven't, don't tell me}. / "好吧。"随着一声叹息，你的抵抗崩溃了。"如果你搜查了我的东西，那么我猜你已经找到了{ evasive > 1: 你需要的东西|我的信件。不是吗？事实上，如果你还没找到，别告诉我}。
		 ~ admitblackmail  = true
		Harris nods once. / Harris 点了一下头。
		<> -> harris_has_seen_it_before

	 * {evasive > 0} [Evade] "Only that you're being unreasonable, and behaving like a swine." / [回避] "只是你太不讲理了，行为像头猪。"
		// Loses temper / 发脾气
		"You imbecile," Harris replies, with sudden force. He is half out of his chair. "You know the situation as well as I do. Why the fencing? The Hun are poised like rats, ready to run all over this country. They'll destroy everything. You understand that, don't you? You're not so locked up inside your crossword puzzles that you don't see that, are you? This machine we have here — you men — you are the best and only hope this country has. God help her." / "你这个白痴，" Harris 突然用力地回答。他半个身子已经离开了椅子。"你对情况的了解不比我少。为什么还要耍花招？德国佬像老鼠一样蠢蠢欲动，准备踏遍这个国家。他们会摧毁一切。你明白这一点，不是吗？你还没有沉迷在你的填字游戏里到看不见这一点，对吧？我们这里拥有的这台机器——你们这些人——你们是这个国家最好也是唯一的希望。上帝保佑她。"
			~ losttemper  = true
			I sit back, startled by the force of his outburst. His carefully sculpted expression has curled to angry disgust. <i>He really does hate me</i>, I think. <i>He'll have my blood for the taste of it.</i> / 我向后靠，被他爆发的力量惊到了。他那精心塑造的表情已经扭曲成了愤怒的厌恶。<i>他真的恨我</i>，我想。<i>他会为了尝我的血而要了我的命。</i>
		* * [Placate] / [安抚]
			"Now steady on," I reply, gesturing for him to be calm. / "冷静点，"我回答，示意他平静下来。

		* * [Mock] / [嘲讽]
			"I can imagine how being surrounded by clever men is pretty threatening for you, Commander," I reply with a sneer. "They don't train you to think in the Armed Forces." / "我可以想象，被聪明人包围对你来说是多么有威胁性，指挥官，"我带着讥讽回答。"军队不训练你们思考。"
			 ~ raise(forceful)

		* * [Dismiss] / [不予理会]
			"Then I'll be going, on and getting on with my job of saving her, shall I?" I even rise half to my feet, before he slams the tabletop. / "那么我就走了，继续做我拯救她的工作，好吗？"我甚至半站了起来，然后他猛拍了一下桌面。

		- - "Talk," Harris demands. "Talk now. Tell me where you've hidden it or who you passed it to. Or God help me, I'll take your wretched pansy body to pieces looking for it." / "说，" Harris 命令道。"现在就说。告诉我你把它藏在哪里了，或者你把它交给了谁。否则上帝帮我，我会把你那可怜的同性恋身体拆成碎片来找它。"
	 		-> harris_demands_you_speak


(The file is very large. I'll continue with the remaining sections now.)

=== harris_has_seen_it_before
	"I've seen it before. A young man like you — clever, removed. The kind that doesn't go to parties. Who takes himself too seriously. Who takes things too far." / "我以前见过这种情况。像你这样的年轻人——聪明，孤僻。那种不去参加聚会的人。太把自己当回事的人。做得太过分的人。"
	He slides his thumb between two fingers. / 他把拇指滑入两个手指之间。
	"Now they own you." / "现在他们掌控了你。"

	 * [Agree] / [同意]
	 	"What could I do?" I'm shaking now. The night is cold and the heat—lamp in the Hut has been removed. "{ forceful > 2:I won't|I don't want to} go to prison." / "我能怎么办？"我现在在颤抖。夜很冷，小屋里的取暖灯被拿走了。"{ forceful > 2:我不会|我不想}坐牢。"
	 	"Smart man," he replies. "You wouldn't last. / "聪明人，"他回答。"你坚持不了多久的。"

	 * [Disagree] / [不同意]
		 "I can still fix this." / "我还能挽回。"
		Harris shakes his head. "You'll do nothing. This is beyond you now. You may go to prison or may go to firing squad - or we can change your name and move you somewhere where your indiscretions can't hurt you. But right now, none of that matters. What happens to you doesn't matter. All that matters is where that component is. / Harris 摇摇头。"你什么也做不了。这已经超出了你的能力。你可能进监狱，也可能被枪毙——或者我们可以给你改名，把你移到某个你的不检点行为伤害不到你的地方。但现在，这些都不重要。发生在你身上的事不重要。唯一重要的是那个元件在哪里。"

	 * { not drugged  }   [Lie] / [撒谎]
	 	"I wanted to tell you," I tell him. "I thought I could find out who they were. Lead you to them." / "我想告诉你来着，"我告诉他。"我以为我能查出他们是谁。带你找到他们。"
		Harris looks at me with contempt. "You wretch. You'll pay for what you've done to this country today. If a single man loses his life because of your pride and your perversions then God help your soul. / Harris 轻蔑地看着我。"你这个混蛋。你今天对这个国家所做的一切会让你付出代价的。如果有一个士兵因为你的骄傲和变态而丧命，上帝保佑你的灵魂。"

	*  {drugged} {forceful < 0} [Apologise] / [道歉]
		"Harris, I..." / "Harris，我……"
		~lower(forceful)
		"Stop it," he interrupts. "There's no jury here to sway.  And there's no time. / "别说了，"他打断道。"这里没有陪审团可以打动。而且没时间了。"

- 	(tell_me_now) <> So why don't you tell me, right now. Where is it?" / 所以为什么你不现在就告诉我。它在哪里？"
	-> harris_demands_you_speak



=== harris_demands_you_speak
	His eyes bear down like carbonised drill—bits. / 他的眼睛像碳化钻头一样逼视着。
 * [Confess] / [坦白]
	 	{ forceful > 1 :
		"You want me to tell you what happened? You'll be disgusted." / "你想让我告诉你发生了什么？你会感到厌恶的。"
		-else:
			"All right. I'll tell you what happened." And never mind my shame. / "好吧。我会告诉你发生了什么。"别管我的羞耻了。
		}
		"I can imagine how it starts," he replies. / "我能想象是怎么开始的，"他回答。

 * { not drugged  } [Dissemble] -> claim_hooper_took_component / [掩饰] -> claim_hooper_took_component
 * { drugged  } [Dissemble] / [掩饰]
	 	My plan now is to blame Hooper, but I cannot seem to tell the story. Whatever they put in my tea, it rules my tongue. { forceful >1:I fight it as hard as I can but it does no good.|I am desperate to tell him everything. I am weeping with shame.} / 我现在打算责怪 Hooper，但我似乎讲不出这个故事。不管他们在我茶里放了什么，它控制了我的舌头。{ forceful >1:我拼命抵抗，但没有用。|我拼命想告诉他一切。我羞愧地哭泣着。}

		 ~ lower(forceful)
-  -> i_met_a_young_man




=== i_met_a_young_man
	//  Explain Story / 讲述故事
	*	[Talk] / [说]
		"There was a young man. I met him in the town. A few months ago now. We got to talking. Not about work. And I used my cover story, but he seemed to know it wasn't true. That got me wondering if he might be one of us." / "有一个年轻男人。我在镇上遇到的他。大概是几个月前了。我们开始聊天。不是关于工作。我用的是我的掩护身份，但他似乎知道那不是真的。这让我想到他可能是我们的人。"
	-	Harris is not letting me off any more. / Harris 不再对我网开一面了。
		"You seriously entertained that possibility?" / "你真的认真考虑过这种可能性？"
	 * [Yes] / [是的]
	 	"Yes, I considered it. <> / "是的，我考虑过。<>
	 * [No] / [不]
		"No. Not for more than a moment, of course. Everyone here is marked out by how little we would be willing to say about it." / "不。当然，只是片刻之间。这里的每个人的特点就是我们几乎不愿意谈论任何事。"
		"Only you told this young man more than a little, didn't you?" / "只是你告诉这个年轻男人的可不止一点点，不是吗？"
		I nod. "<> / 我点点头。"<>
	* [Lie] / [撒谎]
		"I was quite certain, after a while. After we'd been talking. <> / "过了一阵子，我就相当确定了。在我们交谈之后。<>
- 	He seemed to know all about me. He... he was quite enchanted by my achievements." / 他似乎对我了如指掌。他……他对我的成就相当着迷。"
	The way Harris is staring I expect him to strike me, but he does not. He replies, "I can see how that must have been attractive to you," with such plain—spokeness that I think I must have misheard. / Harris 盯着我的样子让我以为他会打我，但他没有。他回答："我能理解这对你来说一定很有吸引力，"语气如此直白，以至于我觉得我一定听错了。

	 *  [Yes] "It's a lonely life in this place," I reply. "Lonely - and still one never gets a moment to oneself." / [是的] "在这里的生活是孤独的，"我回答。"孤独——而且仍然没有片刻属于自己的时间。"
		"That's how it is in the Service," Harris answers. / "在军情部门就是这样，" Harris 回答。
		* *	[Argue] "I'm not in the Service." / [争论] "我不在军情部门。"
			Harris shakes his head. "Yes, you are." / Harris 摇摇头。"不，你是在的。"
		* * [Agree] "Perhaps. But I didn't choose this life." / [同意] "也许吧。但我没有选择这种生活。"
			Harris shakes his head. "No. And there's plenty of others who didn't who are suffering far worse." / Harris 摇摇头。"是的。还有很多人也没有选择，却遭受着更糟的苦难。"
		- - Then he waves the thought aside. / 然后他把这个想法挥到一边。

	 * (nope) { not drugged  }  [No] "The boy was a pretty simpleton. Quite inferior. His good opinion meant nothing to be. Harris, do not misunderstand. I was simply after his body." / [不] "那个男孩是个漂亮的白痴。相当低等。他对我的好感毫无意义。Harris，不要误解。我只是贪图他的身体。"
			 ~ raise(evasive)
			Harris, to his credit, doesn't flinch; but I can see he will have nightmares of this moment later tonight. I'm tempted to reach out and take his hand to worsen it for him. / Harris 值得称赞的是，他没有畏缩；但我能看出他今晚晚些时候会做这个时刻的噩梦。我甚至想伸出手握住他的手，让这噩梦对他来说更糟糕。

	 * { drugged  }   		[No] / [不]
	 	"It wasn't," I reply. "But I doubt you'd understand." / "不是的，"我回答。"但我怀疑你不会理解。"
	 	He simply nods. / 他只是点点头。
	 * { not drugged  }   	[Lie] -> nope / [撒谎] -> nope

-  "Go on with your confession." / "继续你的坦白。"
- (paused)
	 { not nope:
		That gives me pause. I hadn't thought of it as such. But I suppose he's right. I am about to admit what I did. / 这让我停顿了一下。我没想过这是坦白。但我想他是对的。我正要承认我所做的事。
	}
	"There's not much else to say. I took the part from Bombe computing device. You seem to know that already. I had to. He was going to expose me if I didn't." / "没什么可说的了。我从 Bombe 计算机上拿走了那个零件。你似乎已经知道了。我不得不这么做。如果我不做，他就会揭发我。"
	//  So blackmail? / 所以是敲诈？
	"This young man was blackmailing you over your affair?" / "这个年轻男人用你的私情敲诈你？"

	~ temp harris_thinks_youre_drugged = drugged

	 { drugged:
	 	~ drugged = false
		As Harris speaks I find myself suddenly sharply aware, as if waking from a long sleep. The table, the corrugated walls of the hut, everything seems suddenly more tangible than a moment before. / 随着 Harris 说话，我突然变得异常清醒，仿佛从长眠中醒来。桌子、小屋的波纹墙壁，一切突然变得比刚才更加真实可触。
		Whatever it was they put in my drink is wearing off. / 无论他们在我饮料里放了什么，正在失效。
	}

	 * (yes) [Yes] / [是的]
	 	"Yes. I suppose he was their agent. I should have realised but I didn't. Then he threatened to tell you. I thought you would have me locked up: I couldn't bear the thought of it. I love working here. I've never been so happy, so successful, anywhere before. I didn't want to lose it." / "是的。我猜他是他们的特工。我本应意识到，但我没有。然后他威胁要告诉你。我以为你会把我关起来：我无法忍受这个想法。我热爱在这里工作。我以前从未在任何地方如此快乐、如此成功过。我不想失去它。"
		"So what did you do with the component?" Harris talks urgently. He grips his gloves tightly in one hand, perhaps prepared to lift them and strike if it is required. "Have you passed it to this man already? Have you left it somewhere for him to find?" / "那么你对元件做了什么？" Harris 急切地说。他一只手紧握着手套，也许准备在必要时举起来抽打。"你已经把它交给这个人了吗？你把它放在某个地方让他去找了吗？"
		* * (still_have)	[I have it] / [我拿着]
				"I still have it. Not on me, of course. -> reveal_location_of_component / "我还拿着。当然，不在我身上。-> reveal_location_of_component

		* * (dont_have) 	[I don't have it] 	-> i_dont_have_it / [我没拿着] -> i_dont_have_it
		* * [Lie] 							-> dont_have / [撒谎] -> dont_have
		* * [Tell the truth] 				-> still_have / [说实话] -> still_have

	 * (notright) [No] / [不]
	 	"No, Harris. The young man wasn't blackmailing me." I take a deep breath. "It was Hooper." / "不，Harris。那个年轻男人不是在敲诈我。"我深吸一口气。"是 Hooper。"
		{ not hooper_mentioned:
			"Hooper!" Harris exclaims, in surprise. {harris_thinks_youre_drugged:He does not doubt me for a moment.} / "Hooper！" Harris 惊讶地喊道。{harris_thinks_youre_drugged:他片刻都没有怀疑我。}
		- else:
			"Now look here," Harris interrupts. "Don't start that again." / "听着，" Harris 打断道。"别再提那个了。"
		}
		 "It's the truth, Harris. If I'm going to jail, so be it, but I won't hang at Traitor's Gate. Hooper was the one who told the boy about our work. Hooper put the boy on to me. { forceful < 2:I should have realised, of course. These things don't happen by chance. I was a fool to think they might.} And then, once he had me compromised, he demanded I steal the part from the machine." / "这是事实，Harris。如果我要进监狱，那就进吧，但我不会在叛徒之门被绞死。Hooper 是向那个男孩透露我们工作的人。Hooper 让那个男孩接近我。{ forceful < 2:我本应意识到的，当然。这些事情不会偶然发生。我居然以为可能，真是个傻瓜。} 然后，一旦他把我拖下水，他就要求我从机器上偷走那个零件。"
		 ~ revealedhooperasculprit  = true
		"Which you did." Harris leans forward. "And then what? You still have it? You've stashed it somewhere?" / "你确实偷了。" Harris 向前倾身。"然后呢？你还拿着吗？你把它藏在什么地方了？"
		* * (didnt_have_long) [Yes] / [是的]
			"Yes. I only had a moment. -> reveal_location_of_component / "是的。我只有片刻时间。-> reveal_location_of_component

		* * (passed_on) [No] -> passed_onto_hooper / [不] -> passed_onto_hooper
		* * [Lie] 			-> passed_on / [撒谎] -> passed_on
		* * [Evade] / [回避]
			"I can't remember." / "我记不起来了。"
			He draws his gun and lays it lightly on the field table. / 他拔出枪，轻轻放在野战桌上。
			"I'm sorry to threaten you, friend. But His Majesty needs that brain of yours, and that brain alone. There are plenty of other parts to you that our country could do better without. Now I'll ask you again. Did you hide the component?" / "很抱歉威胁你，朋友。但是国王陛下需要你的那个脑子，而且只需要那个脑子。你身上有很多其他部分，我们这个国家没有它们会更好。现在我再问你一次。你把元件藏起来了吗？"
			* * * [Yes] -> didnt_have_long / [是的] -> didnt_have_long
			* * * (nope_didnt_hide) [No] / [不]
			 		"Very well then." I swallow nervously, to make it look more genuine. -> passed_onto_hooper / "那好吧。"我紧张地咽了口口水，让它看起来更真实。-> passed_onto_hooper
			* * * [Lie] -> nope_didnt_hide / [撒谎] -> nope_didnt_hide

			* * * [Evade] -> i_dont_have_it / [回避] -> i_dont_have_it

	 * [Tell the truth] 	-> yes / [说实话] -> yes
	 * [Lie] 				-> notright / [撒谎] -> notright

= i_dont_have_it
	"I don't have it any more. I passed it through the fence to my contact straight after taking it, before it was discovered to be missing. It would have been idiocy to do differently. It's long gone, I'm afraid." / "我不再拿着它了。拿到后我就马上把它从围栏递给了我的联系人，在它被发现丢失之前。不这样做就是白痴。它早就没了，恐怕。"
	"You fool, Manning," Harris curses, getting quickly to his feet. "You utter fool. Do you suppose you will be any better off living under Hitler? It's men like you who will get us all killed. Men too feeble, too weak in their hearts to stand up and take a man's responsibility for the world. You're happier to stay a child all your life and play with your little childish toys." / "你这个傻瓜，Manning，" Harris 咒骂着，迅速站了起来。"你这个彻底的傻瓜。你以为在希特勒统治下你会过得更好吗？就是像你这样的人会害死我们所有人。太懦弱、内心太软弱，无法站起来承担一个男人对世界的责任。你更乐意当一辈子小孩，玩你那些幼稚的玩具。"
	 * [Answer back] / [回嘴]
	 	"Really, Commander," I reply. "It rather sounds like you want to spank me." / "真的吗，指挥官，"我回答。"听起来你倒是挺想打我的。"
		"For God's sake," he declares with thick disgust, then swoops away out of the room. / "看在上帝份上，"他带着浓重的厌恶宣示，然后迅速离开了房间。

	 * [Say nothing] / [什么都不说]
	 	I say nothing. It's true, isn't it? I can't deny that I know there is a world out there, a complicated world of pain and suffering. And I can't deny that I don't think about it a moment longer than I have to. What use is thinking on a problem that cannot be solved? It is precisely our ability to avoid such endless spirals that makes us human and not machine. / 我什么也没说。这是真的，不是吗？我不能否认我知道外面有一个世界，一个充满痛苦和苦难的复杂世界。我也不能否认，我考虑它的时间不会比必要的多一秒。思考一个无法解决的问题有什么用处？正是我们避免这种无尽循环的能力，才使我们成为人，而不是机器。
		"God have mercy on your soul," Harris says finally, as he gets to his feet and heads for the door. "I fear no—one else will." / "上帝怜悯你的灵魂，" Harris 最后说着，站起来朝门口走去。"我怕没有别人会了。"

	- -> left_alone

= passed_onto_hooper
	~ hooper_mentioned = true
	"No. I passed it on to Hooper." / "不。我把它交给了 Hooper。"
	"I see. And what did he do with it?" / "我明白了。那他怎么处理它的？"
	 * [Evade] / [回避]
	 	"I don't know." / "我不知道。"
		"You can do better than that. Remember, there's a hangman's noose waiting for traitors." / "你可以做得比这更好。记住，绞刑索在等着叛徒。"
		* * 	[Theorise] / [推测]
				"Well, then," I answer, nervously. "What would he do? Either get rid of it straight away — or if that wasn't possible, which it probably wouldn't be, since he'd have to arrange things with his contacts — so most likely, he'd hide it somewhere and wait, until you had the rope around my neck and he could be sure he was safe." / "好吧，那么，"我紧张地回答。"他会怎么做？要么马上处理掉它——要么如果不可能的话，这大概不可能，因为他得和他的联系人安排——所以最有可能的是，他会把它藏在某个地方，然后等待，直到绳子套在我脖子上，他能确定自己是安全的。"
 				-> claim_hooper_took_component.harris_being_convinced

		* * [Shrug] -> claim_hooper_took_component.its_your_problem / [耸肩] -> claim_hooper_took_component.its_your_problem

	 * [Tell the truth] / [说实话]
	 	"I don't think Hooper could have planned this in advance. So he'd need to get word to whoever he's working with, and that would take time. So I think he would have hidden it somewhere, and be waiting to make sure I soundly take the fall. That way, if anything goes wrong, he can arrange for the part to be conveniently re—found." / "我不认为 Hooper 能提前计划这件事。所以他需要给他为之工作的人传递消息，那需要时间。所以我认为他会把它藏在某个地方，然后等着确保我彻底背锅。那样的话，如果有什么事出错，他可以安排让那零件被方便地重新找到。"
 		-> claim_hooper_took_component.harris_being_convinced

	 * [Lie] / [撒谎]
		"I'm sure I saw him this evening, talking to someone by the fence on the woodland side of the compound. He's probably passed it on already. You'll have to ask him." / "我确定今晚我看到他了，在营地树林边的围栏那里跟某人说话。他大概已经把它转交出去了。你得问他。"

		 -> claim_hooper_took_component.harrumphs


/*--------------------------------------------------------------------------------
	Trying to frame Hooper / 试图陷害 Hooper
--------------------------------------------------------------------------------*/


=== claim_hooper_took_component
//  Blame Hooper / 指责 Hooper
	"I saw Hooper take it." / "我看到 Hooper 拿了它。"
	 ~ hooper_mentioned  = true
	 { losttemper  :
		"Did you?" / "是吗？"
		The worst of his rage is passing; he is now moving into a kind of contemptuous despair. I can imagine him wrapping up our interview soon, leaving the hut, locking the door, and dropping the key down the well in the yard. / 他最糟糕的愤怒正在消退；他现在进入了一种轻蔑的绝望。我可以想象他很快会结束我们的谈话，离开小屋，锁上门，然后把钥匙扔进院子里的井里。
		And why wouldn't he? With my name tarnished they will not let me back to work on the Bombe — if there is the slightest smell of treachery about my name I would be lucky not be locked up for the remainder of the war. / 他为什么不呢？我的名声被玷污了，他们不会让我回去继续做 Bombe 的工作——如果我的名字上有一丝叛国气味，我在战争剩余时间里不被关起来就算是幸运了。
	- else:
		 "I see." He is starting to lose his patience. I have seen Harris angry a few times, with lackeys and secretaries. But never with us. With the 'brains' he has always been cautious, treating us like children. / "我明白了。"他开始失去耐心了。我见过 Harris 生气几次，对跟班和秘书。但从不对我们。对"智囊们"，他一直很小心，把我们当孩子一样对待。
		 And now I see that, like a father, he wants to smack us when we disobey him. / 而现在我看到，像一个父亲一样，当我们不服从他时，他就想打我们。
	}
	"Just get to the truth, man. Every <i>minute</i> matters." / "赶紧说真话，老兄。每一<i>分钟</i>都很重要。"
	 * { admitblackmail  }   [Persist with this] / [坚持这么说]
	 		"I know what you're thinking. If I've transgressed once then I must be guilty of everything else... But I'm not. We were close to cracking the 13th's intercept. We were getting correlations in the data. Then Hooper disappeared for a moment, and next minute the machine was down." / "我知道你在想什么。如果我犯过一次错，那么我一定犯了所有其他的事……但我没有。我们差一点就要破解 13 日的密文了。我们正在数据中找到关联。然后 Hooper 消失了一会儿，下一秒机器就停了。"

	 * [Tell the truth] / [说实话]
	 		"Very well. I see there's no point in covering up. You know everything anyway." / "很好。我明白掩盖没有意义了。反正你什么都知道。"
			Harris nods, and waits for me to continue. / Harris 点点头，等着我继续说。
			 -> i_met_a_young_man

	 * { not admitblackmail }   [Persist with this] / [坚持这么说]
	 			"This is the truth." / "这是事实。"

	- 	I have become, somehow, an accustomed liar — the words roll easily off my tongue. Perhaps I am a traitor, I think, now that I dissemble as easily as one. / 不知怎的，我成了一个习惯性的说谎者——话语轻松地从我舌尖滚落。也许我确实是个叛徒，我想，既然我撒谎撒得如此轻松。
		"Go on," Harris says, giving me no indication of whether he believes my tale. / "继续说，" Harris 说，没有给我任何他是否相信我故事的暗示。
		 * 	[Assert] "I saw him take it," I continue. "Collins was outside having a cigarette. Peterson was at the table. But I was at the front of the machine. I saw Hooper go around the side. He leant down and pulled something free. I even challenged him. I said, 'What's that? Someone put a nail somewhere they shouldn't have?' He didn't reply." / [断言] "我看到他拿了它，"我继续说。"Collins 在外面抽烟。Peterson 在桌旁。但我在机器的前面。我看到 Hooper 绕到侧面。他弯下腰，拔出了什么东西。我甚至质问他了。我说，'那是什么？有人把钉子放错了地方？'他没有回答。"
		 	Harris watches me for a long moment. / Harris 盯着我看了很久。

		 * 	[Imply] "At the moment the machine halted, Peterson was at the bench and Collins was outside having a smoke. I was checking the dip—switches. Hooper was the only one at the back of the Bombe. No—one else could have done it." / [暗示] "在机器停止的那一刻，Peterson 在长凳旁，Collins 在外面抽烟。我在检查拨码开关。Hooper 是唯一在 Bombe 后面的人。没有其他人能做了这件事。"
				"That's not quite the same as seeing him do it," Harris remarks. / "这和亲眼看到他做不太一样，" Harris 评论道。
				 * * 	[Logical] / [逻辑的]
				 		"When you have eliminated the impossible..." I begin, but Harris cuts me off. / "当你排除了不可能……"我开始说，但 Harris 打断了我。

				 * * 	[Persuasive] / [有说服力的]
				 		"You have to believe me." / "你必须相信我。"
				 		"We don't have to believe anyone," Harris returns. "I will only be happy with the truth, and your story doesn't tie up. We know you've been leaving yourself open to pressure. We've been watching your activities for some time. But we thought you were endangering the reputation of this site; not risking the country herself. Perhaps I put too much trust in your intellectual pride." / "我们不必相信任何人，" Harris 回道。"我只对真相满意，而你的故事对不上。我们知道你一直在让自己暴露于压力之下。我们观察你的活动有一段时间了。但我们以为你是在危害这个地方的声誉；而不是拿国家本身去冒险。也许我太过信任你的知识分子骄傲了。"
						He pauses for a moment, considering something. Then he continues: / 他停顿片刻，在考虑什么。然后他继续说：
						"It might have been Hooper. It might have been you. -> we_wont_guess / "可能是 Hooper。也可能是你。-> we_wont_guess

				 * * 	[Confident] / [自信的]
					"Ask the others," I reply, leaning back. "They'll tell you. If they haven't already, that's only because they're protecting Hooper. Hoping he'll come to his senses and stop being an idiot. I hope he does too. And if you lock him up in a freezing hut like you've done me, I'm sure he will." / "问其他人吧，"我靠后回答。"他们会告诉你的。如果他们还没有的话，那只是因为他们保护着 Hooper。希望他会清醒过来，不再做个白痴。我也希望他能。如果你像对我一样把他关在一个冰冷的小屋里，我相信他会清醒的。"
						"We have," Harris replies simply. / "我们已经问了，" Harris 简单地回答。
						It's all I can do not to gape. / 我能做的只有忍住不张嘴。
						-> hoopers_hut_3

	- "We are left with two possibilities. You, or Hooper." The Commander pauses to smooth down his moustache. <> / "我们只剩下两种可能。你，或者 Hooper。"指挥官停下来抚平他的胡子。<>
	- (hoopers_hut_3) "Hooper's in Hut 3 with the Captain, having a similar conversation." / "Hooper 在 3 号小屋和上尉在一起，进行着类似的谈话。"

		 * 	"And the other men?["] Do we have a hut each? Are there  enough senior officers to go round?" / "那其他人呢？["] 我们每人一间小屋吗？有足够的高级军官分配给每个人吗？"
			"Collins was outside when it happened, and Peterson can't get round the machine in that chair of his," Harris replies. "That leaves you and Hooper. / "事发时 Collins 在外面，Peterson 坐着他那把轮椅无法绕到机器后面，" Harris 回答。"那就剩下你和 Hooper 了。"
		 * 	"Then you know I'm right.["] You knew all along. Why did you threaten me?" / "那你就是知道我是对的了。[。'] 你一直都知道。为什么还要威胁我？"
			"All we know is that we have a traitor, holding the fate of the country in his hands. / "我们只知道有一个叛徒，掌握着国家的命运。"
	- (we_wont_guess) <> We're not in the business of guessing here at Bletchley. We are military intelligence. We get answers." Harris points a finger. "And if that component has left these grounds, then every minute is critical." / <> 我们 Bletchley 不做猜测的生意。我们是军事情报机构。我们要的是答案。" Harris 伸出一根手指。"如果那个元件已经离开了这片营地，那么每一分钟都至关重要。"
	 * [Co-operate] / [合作]
			"I'd be happy to help," I answer, leaning forwards. "I'm sure there's something I could do." / "我很乐意帮忙，"我回答，向前倾身。"我相信有什么是我可以做的。"
			"Like what, exactly?" / "比如，具体做什么？"
			* * 	"Put me in with Hooper." -> putmein / "让我跟 Hooper 待在一起。" -> putmein
			* * 	"Tell Hooper I've confessed.["] Better yet. Let him see you marching me off in handcuffs. Then let him go, and see what he does. Ten to one he'll go straight to wherever he's hidden that component and his game will be up." / "告诉 Hooper 我已经坦白了。[。'] 更好的是，让他看到你用手铐把我押走。然后放他走，看他做什么。十有八九他会直接去他藏元件的地方，他的把戏就结束了。"
					Harris nods slowly, chewing over the idea. It isn't a bad plan even — except, of course, Hooper has <i>not</i> hidden the component, and won't lead them anywhere. But that's a problem I might be able to solve once I'm out of this place; and once they're too busy dogging Hooper's steps from hut to hut. / Harris 慢慢点头，仔细斟酌着这个主意。这甚至不是一个坏计划——只是，当然，Hooper <i>没有</i>藏元件，也不会把他们引到任何地方。但这是我一离开这个地方也许就能解决的问题；一旦他们忙着在小屋之间跟踪 Hooper 的每一步。
					"Interesting," the Commander muses. "But I'm not so sure he'd be that stupid. And if he's already passed the part on, the whole thing will only be a waste of time." / "有意思，"指挥官沉思道。"但我不太确定他会那么蠢。如果他已经把零件转交出去了，整件事就只是浪费时间。"
					* * * 	"Trust me. He hasn't.["] If I know that man, and I do, he'll be wanting to keep his options open as long as possible. If the component's gone then he's in it up to his neck. He'll take a week at least to make sure he's escaped suspicion. Then he'll pass it on." / "相信我。他还没有。[。'] 如果我了解那个人，我确实了解，他会想尽可能长地保持选择余地。如果元件丢了，那么他就彻底陷进去了。他至少会花一周时间来确保自己摆脱了嫌疑。然后他才会转交出去。"
							"And if we keep applying pressure to him, you think the component will eventually just turn up?" / "如果我们持续对他施加压力，你觉得元件最终会自己出现吗？"
							* * * * "Yes.["] Probably under my bunk." / "是的。[。'] 大概在我铺位下面。"
									Harris smiles wryly. "We'll know that for a fake, then. We've looked there already. / Harris 苦笑。"那我们就会知道那是假的。我们已经在那边找过了。"
							* * * * "Or be thrown into the river." / "或者被扔进河里。"
									"Hmm." Harris chews his moustache thoughtfully. "Well, that would put us in a spot, seeing as how we'd never know for certain. We'd have to be ready to change our whole approach just in case the part had got through to the Germans. / "嗯。" Harris 若有所思地咬着胡子。"好吧，那会让我们陷入困境，因为我们将永远无法确定。我们将不得不准备改变整个策略，以防那零件已经落到德国人手中。"
							- - - -	 <> I don't mind telling you, this is a disaster, this whole thing. What I want is to find that little bit of mechanical trickery. I don't care where. In your luncheon box or under Hooper's pillow. Just somewhere, and within the grounds of this place." / <> 我不介意告诉你，这整件事是一场灾难。我想要的就是找到那一个小机械零件。我不在乎在哪。在你的午餐盒里或 Hooper 的枕头下。只要在某个地方，在这个地方的范围内。"
							* * * * "Then let him he think he's off the hook.["] Make a show of me. And then you'll get your man." / "那就让他以为他脱身了。[。'] 把我演一出戏。然后你就能抓住你的人。"
									<i>Somehow</i>, I think. But that's the part I need to work. / <i>以某种方式</i>，我想。但那是需要我努力的部分。
									 -> harris_takes_you_to_hooper

							* * * * "Then you'd better get searching[."]," I reply, tiring of his complaining. A war is a war, you have to expect an enemy. -> its_your_problem / "那你最好开始搜吧[。']"我回答，厌倦了他的抱怨。战争就是战争，你得料到有敌人。-> its_your_problem

					* * * 	"You're right. Let me talk to him[."], then. As a colleague. Maybe I can get something useful out of him." / "你说得对。那就让我跟他谈谈[。']。以同事的身份。也许我能从他那里得到一些有用的东西。"
	 						-> putmein

					* * * "You're right." -> shake_head / "你说得对。" -> shake_head

	 * [Block] -> its_your_problem / [阻止] -> its_your_problem


= harris_being_convinced
	"Makes sense," Harris agrees, cautiously. { evasive > 1:I can see he's still not entirely convinced by my tale, as well he might not be — I've hardly been entirely straight with him.|I can see he's still not certain whether he can trust me.} "Which means the question is, what can we do to rat him out?" / "有道理，" Harris 谨慎地同意。{ evasive > 1:我看得出他还没有完全被我故事说服，他本来也不该被说服——我对他几乎没有完全坦诚。|我看得出他还不确定是否可以信任我。} "这意味着问题是，我们能做些什么来揭发他？"
	 * [Offer to help] / [主动帮忙]
	 	"Maybe I can help with that." / "也许我能帮忙。"
		"Oh, yes? And how, exactly?" / "哦，是吗？具体怎么帮？"
		 * * 	"I'll talk to him." / "我会跟他谈谈。"
				"What?" / "什么？"
				"Put me in with Hooper with him. Maybe I can get something useful out of him." / "让我跟 Hooper 待在一起。也许我能从他那里得到一些有用的东西。"
			 	-> putmein
		 * * 	"We'll fool him.["] He's waiting to be sure that I've been strung up for this, so let's give him what he wants. If he sees me taken away, clapped in irons — he'll go straight to that component and set about getting rid of it." / "我们骗他。[。'] 他在等着确定我因为这件事被绞死了，所以我们就给他他想要的。如果他看到我被带走，铐上镣铐——他会直接去那个元件那里，开始处理掉它。"
	 			-> harris_takes_you_to_hooper

	 * [Don't offer to help] / [不主动帮忙]
	 	I lean back.  -> its_your_problem / 我向后靠。-> its_your_problem

= putmein
	Harris shakes his head. / Harris 摇摇头。
	"He despises you. I don't see why he'd give himself up to you." / "他看不起你。我不明白他为什么会在你面前投降。"
	 * [Insist] "Try me. Just me and him." / [坚持] "试试看。就我和他。"
	 	-> go_in_alone
	 * [Give in] "You're right." / [让步] "你说得对。"
	 	-> shake_head


= shake_head
	// Can't help / 帮不上忙
	<> I shake my head. "You're right. I don't see how I can help you. So there's only one conclusion." / <> 我摇摇头。"你说得对。我看不出我怎么能帮到你。所以只有一个结论。"
	"Oh, yes? And what's that?" / "哦，是吗？那是什么？"
	 -> its_your_problem


= its_your_problem
// Won't Help / 不会帮忙
	"It's your problem. Your security breach. So much for your careful vetting process." / "这是你的问题。你的安全漏洞。你所谓的仔细审查也不过如此。"
	I lean back in my chair and fold my arms so the way they shake will not be visible. / 我靠在椅背上，抱起双臂，让它们的颤抖不被看见。
	"You'd better get on with solving it, instead of wasting your time in here with me." / "你最好赶紧去解决它，而不是在我这里浪费时间。"
 	-> harrumphs

= harrumphs
	Harris harrumphs. He's thinking it all over. / Harris 哼了一声。他正在全面思考。
 	* { putmein  }   	[Wait] / [等待]
 		"All right," he declares, gruffly. "We'll try it. But if this doesn't work, I might just put the both of you in front of a firing squad and be done with these games. Worse things happen in time of war, you know." / "好吧，"他粗声宣布。"我们试试。但如果这不行，我可能会把你们两个都推到行刑队面前，结束这些把戏。战时会发生更糟的事，你知道的。"
		"Alone," I add. / "单独，"我补充道。
		 -> go_in_alone

 	* { not putmein  }  [Wait] / [等待]
	 	"No," Harris declares, finally. "I think you're lying about Hooper. I think you're a clever, scheming young man — that's why we hired you — and you're looking for the only reasonable out this situation has to offer. But I'm not taking it. We know you were in the room with the machine, we know you're of a perverted persuasion, we know you have compromised yourself. There's nothing more to say here. Either you tell me what you've done with that component, or we will hang you and search just as hard. It's your choice." / "不，" Harris 最终宣布。"我认为你在 Hooper 的事情上撒谎。我认为你是一个聪明、有心计的年轻人——这就是我们雇用你的原因——你正在寻找这个局面所提供的唯一合理的出路。但我不接受。我们知道你在有那台机器的房间里，我们知道你有变态的倾向，我们知道你已经让自己被拖下水了。这里没什么可说的了。要么你告诉我你对那个元件做了什么，要么我们绞死你，然后同样努力地去搜。这是你的选择。"
	 -> harris_threatens_lynching


= go_in_alone
	"Alone?" / "单独？"
	"Alone." / "单独。"
	Harris considers it. I watch his eyes, flicking backwards and forwards over mine, like a ribbon—reader loading its program. / Harris 考虑了一下。我观察他的眼睛，在我的眼睛上来回扫动，像读带机加载程序一样。
	* 	[Patient] "Well?" / [耐心] "怎么样？"
	* 	[Impatient] "For God's sake, man, what do you have to lose?" / [不耐烦] "看在上帝份上，老兄，你有什么可损失的？"
	 	~ raise(forceful)
	- 	"We'll be outside the door," Harris replies, seriously. "The first sign of any funny business and we'll have you both on the floor in minutes. You understand? The country needs your brain, but it's not too worried about your legs. Remember that." / "我们会在门外，" Harris 严肃地回答。"有任何异常，我们几分钟内就会把你们两个都按在地上。你明白吗？国家需要你的脑子，但对你的腿不太担心。记住这一点。"
		Then he gets to his feet, and opens the door, and marches me out across the yard. The evening is drawing in and there's a chill in the air. My mind is racing. I have one opportunity here — a moment in which to put the fear of God into Hooper and make him do something foolish that places him in harm's way. But how to achieve it? / 然后他站起来，打开门，押着我穿过院子。夜幕正在降临，空气中有寒意。我的思绪飞转。我在这里有一个机会——一个时刻，可以把对上帝的敬畏注入 Hooper 心中，让他做一些把自己置于险境的蠢事。但如何做到呢？
		"You ready?" Harris demands. / "你准备好了吗？" Harris 问道。
 	* (yes) [Yes] / [是的]
 			"Absolutely." / "当然。"
 	* 	[No] / [不]
 			"No." / "没有。"
			"Too bad." / "太糟了。"
 	* 	[Lie] -> yes / [撒谎] -> yes

	- 	-> inside_hoopers_hut


/*--------------------------------------------------------------------------------
	Quick visit to see Hooper / 快速拜访 Hooper
--------------------------------------------------------------------------------*/

=== harris_takes_you_to_hooper
	// Past Hooper / 经过 Hooper
	Harris gets to his feet. "All right," he says. "I should know better than to trust a clever man, but we'll give it a go." / Harris 站起来。"好吧，"他说。"我应该知道不该相信一个聪明人，但我们试试看。"
	Then, he smiles, with all his teeth, like a wolf. / 然后，他笑了，露出所有牙齿，像一匹狼。
	 { claim_hooper_took_component.hoopers_hut_3:
		"Especially since this is a plan that involves keeping you in handcuffs. I don't see what I have to lose." / "尤其是这是一个涉及让你戴着手铐的计划。我看不出我有什么可损失的。"
	- else:
		"Hooper's in Hut 3 being debriefed by the Captain. Let's see if we can't get his attention somehow." / "Hooper 在 3 号小屋被上尉盘问。看看我们能不能以某种方式引起他的注意。"
	}
	// Leading you past Hooper / 带你经过 Hooper
	He raps on the door for the guard and gives the man a quick instruction. He returns a moment later with a cool pair of iron cuffs. / 他敲了敲门叫卫兵，给那人一个简短的指示。过了一会儿他回来了，拿着一副冰冷的铁手铐。
	"Put 'em up," Harris instructs, and I do so. The metal closes around my wrists like a trap. I stand and follow Harris willingly out through the door. / "举起来，" Harris 指示，我照做了。金属像陷阱一样扣紧我的手腕。我站起来，顺从地跟着 Harris 走出了门。
	But whatever I'm doing with my body, my mind is scheming. <i>Somehow,</i> I'm thinking, <i>I have to get away from these men long enough to get that component behind Hut 2 and put it somewhere Hooper will go. Or, otherwise, somehow get Hooper to go there himself...</i> / 但不管我的身体在做什么，我的脑子在谋划。<i>以某种方式，</i>我在想，<i>我必须离开这些人足够长的时间，去拿到 2 号小屋后面的那个元件，把它放在 Hooper 会去的地方。或者，以某种方式，让 Hooper 自己去那里……</i>
	Harris marches me over to Hut 3, and gestures for the guard to stand aside. Pushing me forward, he opens the door nice and wide. / Harris 押着我走到 3 号小屋，示意卫兵让开。他把我往前推，把门大大地打开。
	// Hut 3 / 3 号小屋
	"Captain. Manning talked. If you'd step out for a moment?" / "上尉。Manning 招了。你能出来一下吗？"
	 * 	[Play the part, head down] / [扮演角色，低着头]
	 	From where he's sitting, I know Hooper can see me, so I keep my head down and look guilty as sin. The bastard is probably smiling. / 从他坐的位置，我知道 Hooper 能看到我，所以我低着头，看起来罪大恶极。那个混蛋大概在笑。


	 * 	[Look inside the hut] / [往小屋里看]
		I look in through the door and catch Hooper's expression. I had half expected him to be smiling be he isn't. He looks shocked, almost hurt. "Iain," he murmurs. "You couldn't..." / 我透过门往里看，捕捉到了 Hooper 的表情。我本有些预料他会笑，但他没有。他看起来震惊，几乎是受伤的。"Iain，"他喃喃道。"你不可能……"

	 * 	(shouted) [Call to Hooper] / [朝 Hooper 喊]
	 	I have a single moment to shout something to Hooper before the door closes. / 在门关上之前，我只有一瞬间朝 Hooper 喊些什么。
		"I'll get you Hooper, you'll see!" I cry. Then: / "我会抓住你的 Hooper，你等着瞧！"我喊道。然后：

		 	* * "Queen to rook two, checkmate!"[] I call, then laugh viciously, as if I am damning him straight to hell. / "后到车二，将军！[]"我喊道，然后恶毒地大笑，好像我把他直接诅咒入地狱一样。
			 	~ hooperClueType = CHESS
			- - (only_catch) I only catch Hooper's reaction for a moment — his eyebrow lifts in surprise and alarm. Good. If he thinks it is a threat then he just might be careless enough to go looking for what it might mean. / 我只能捕捉到 Hooper 反应的一瞬间——他的眉毛在惊讶和警觉中抬起。好。如果他认为这是威胁，那么他可能会不小心去探究它可能意味着什么。

		 	* * "Ask not for whom the bell tolls!" / "不要问丧钟为谁而鸣！"
			He stares back at me, as if were a madman and perhaps for a split second I see him shudder. / 他盯着我看，好像我是疯子，也许在那一瞬间我看到他颤抖了一下。


		 	* * "Two words: messy, without one missing!"[] I cry, laughing. It isn't the best clue, hardly worthy of The Times, but it will have to do. / "两个字：messy，没有少一个字母！[]"我笑着喊道。这不是最好的线索，几乎配不上《泰晤士报》的填字，但它必须管用。
		 		~ hooperClueType = CROSSWORD
 			-> only_catch

- 	The Captain comes outside, pulling the door to. "What's this?" he asks. "A confession? Just like that?" / 上尉走出来，拉上门。"这是什么？"他问道。"招供了？就这样？"
	"No," the Commander admits, in a low voice. "I'm afraid not. Rather more a scheme. The idea is to let Hooper go and see what he does. If he believes we have Manning here in irons, he'll try to shift the component." / "不，"指挥官低声承认。"恐怕不是。更像是一个计策。想法是放 Hooper 走，看他做什么。如果他认为我们把 Manning 铐在这里，他会试图转移元件。"
	"If he has it." / "如果他有的话。"
	"Indeed." / "是的。"
	The Captain peers at me for a moment, like I was some kind of curious insect. / 上尉盯着我看了一会儿，好像我是什么奇怪的昆虫。
	"Sometimes, I think you people are magicians," he remarks. "Other times you seem more like witches. Very well." / "有时候，我觉得你们这些人是魔术师，"他评论道。"其他时候你们更像女巫。好吧。"
	With that he opens the door to the Hut and goes back inside. The Commander uses the moment to hustle me roughly forward. / 说着他打开小屋的门，走回里面。指挥官利用这一刻把我粗暴地往前推。
	 { shouted  :
		"And what was all that shouting about?" he hisses in my ear as we move towards the barracks. "Are you trying to pull something? Or just make me look incompetent?" / "刚才那大喊大叫是怎么回事？"他朝兵营走去时在我耳边嘶声说。"你是想耍什么花招？还是只是想让我看起来很无能？"
	- else:
		"This scheme of yours had better come off," he hisses in my ear. "Otherwise the Captain is going to start having men tailing <i>me</i> to see where I go on Saturdays." / "你的这个计策最好能成功，"他在我耳边嘶声说。"否则上尉就会开始派人跟踪<i>我</i>，看我周六去哪里了。"
	}
	* 	[Reassure] / [安抚]
		{ not shouted :
			"It will. Hooper's running scared," I reply, hoping I sound more confident than I feel. / "会的。Hooper 在害怕，"我回答，希望自己听起来比我感觉的更自信。
		- else:
			"Just adding to the drama," I tell him, confidently. "I'm sure you can understand that." / "只是在增加戏剧性，"我自信地告诉他。"我相信你能理解。"
		}
		"I think we've had enough drama today already," Harris replies. "Let's hope for a clean kill." / "我想我们今天已经有够多的戏剧了，" Harris 回答。"希望我们能干净利落地解决。"

	* 	[Dissuade] / [劝阻]
		{ not shouted:
			"The Captain thought it was a good scheme. You'll most likely get a promotion." / "上尉认为这是个好计策。你很有可能会升职。"
		- else:
			"I'm not trying to do anything except save my neck." / "我除了救自己的命，没想做什么。"
		}
		"Let's hope things work out," Harris agrees darkly. / "希望事情能顺利解决，" Harris 阴沉地同意。

	* 	[Evade] / [回避]
		"We're still in ear—shot if they let Hooper go. Best get us inside and then we can talk, if we must." / "如果他们把 Hooper 放了，我们还在他能听到的范围内。最好让我们进去，如果必须的话再谈。"
		"I've had enough of your voice for one day," Harris replies grimly. <> / "我今天已经听够你的声音了，" Harris 冷酷地回答。<>

	* 	[Say nothing] / [什么都不说]
		I let him have his rant. <> / 我让他发他的牢骚。<>
- 	He hustles me up the steps of the barracks, keeping me firmly gripped as if I had any chance of giving him, a trained military man, the slip. It's all I can do not to fall into the room. / 他把我推上兵营的台阶，紧紧抓住我，好像我有任何机会能从一个训练有素的军人手中溜走似的。我所能做的就是不要跌进房间。
 	-> slam_door_shut_and_gone



=== inside_hoopers_hut
	-  	Harris opens the door and pushes me inside. "Captain," he calls. "Could I have a moment?" / Harris 打开门，把我推了进去。"上尉，"他喊道。"我能占用一点时间吗？"
		The Captain, looking puzzled, steps out. The door is closed. Hooper stares at me, open—mouthed, about to say something. I probably have less than a minute before the Captain storms back in and declares this plan to be bunkum. / 上尉看起来困惑地走了出来。门关上了。Hooper 盯着我，张着嘴，正要说什么。我大概只有不到一分钟的时间，在上尉冲回来宣布这个计划是胡扯之前。
	 *	 [Threaten] / [威胁]
	 		"Listen to me, Hooper. We were the only men in that hut today, so we know what happened. But I want you to know this. I put the component inside a breeze—block in the foundations of Hut 2, wrapped in one of your shirts. They're going to find it eventually, and that's going to be what tips the balance. And there's nothing you can do to stop any of that from happening." / "听着，Hooper。今天我们两个是那个小屋里唯一的人，所以我们知道发生了什么。但我想让你知道这一点。我把元件放在了 2 号小屋地基的一个煤渣砖洞里，用你的一件衬衫包着。他们最终会找到它，那将是打破平衡的关键。而你完全无法阻止这一切发生。"
	 		~ hooperClueType = STRAIGHT

		His eyes bulge with terror. "What did I do, to you? What did I ever do?" / 他的眼睛因恐惧而突出。"我对你做了什么？我到底做了什么？"
		 * * 	[Tell the truth] / [说实话]
		 		"You treated me like vermin. Like something abhorrent." / "你把我当害虫一样对待。当令人憎恶的东西一样对待。"
				"You are something abhorrent." / "你就是令人憎恶的东西。"
				"I wasn't. Not when I came here. And I won't be, once you're gone." / "我不是。我来这里的时候不是。等你走了，我也不会是。"

		 * * 	[Lie] / [撒谎]
		 		"Nothing," I reply. "You're just the other man in the room. One of us has to get the blame." / "没什么，"我回答。"你只是房间里另一个人。我们中得有一个背锅。"

		 * * 	[Evade] / [回避]
		 		"It doesn't matter. Just remember what I said. I've beaten you, Hooper. Remember that." / "没关系。只要记住我说的话。我打败了你，Hooper。记住这一点。"
		- - 	I get to my feet and open the door of the Hut. The Captain storms back inside and I'm quickly thrown out. -> hustled_out / 我站起来，打开小屋的门。上尉冲回里面，我很快被扔了出去。-> hustled_out


	 * [Bargain] / [交易]
		 "Hooper, I'll make a deal with you. We both know what happened in that hut this afternoon. I know because I did it, and you know because you know you didn't. But once this is done I'll be rich, and I'll split that with you. I'll let you have the results, too. Your name on the discovery of the Bombe. And it won't hurt the war effort — you know as well as me that the component on its own is worthless, it's the wiring of the Bombe, the usage, that's what's valuable. So how about it?" / "Hooper，我跟你做个交易。我们都知道今天下午那个小屋里发生了什么。我知道是因为我做了，你知道是因为你知道你没做。但一旦这事完了，我就会富起来，我会跟你分。我也会让你拿到成果。你的名字出现在 Bombe 的发现上。而且这不会损害战争努力——你跟我一样清楚，元件本身没有价值，有价值的是 Bombe 的接线，是使用方式。所以怎么样？"
		Hooper looks back at me, appalled. "You're asking me to commit treason?" / Hooper 惊骇地看着我。"你在要求我叛国？"
		 * * 	[Yes] / [是的]
		 		"Yes, perhaps. But also to ensure your name goes down in the annals of mathematics. -> back_of_hut_2 / "是的，也许。但也是确保你的名字载入数学史册。-> back_of_hut_2
		 * * 	[No] / [不]
			 	"No. It's not treason. It's a trade, plain and simple." / "不。这不是叛国。这是一笔交易，简单明了。"

		 * * 	(lie) [Lie] / [撒谎]
		 		"I'm suggesting you save your own skin. I've wrapped that component in one of your shirts, Hooper. They'll be searching this place top to bottom. They'll find it eventually, and when they do, that's the thing that will swing it against you. So take my advice now. Hut 2." / "我是在建议你保自己的命。我把那个元件用你的一件衬衫包起来了，Hooper。他们会把这里从上到下搜个遍。他们最终会找到它，当他们找到时，那将是让你定罪的关键。所以现在听我的建议。2 号小屋。"
				 ~ hooperClueType = STRAIGHT

		 * * 	[Evade] -> lie / [回避] -> lie
		- - 	 -> no_chance

	 * [Plead] / [恳求]
		"Please, Hooper. You don't understand. They have information on me.  I don't need to tell you what I've done, you know. Have a soul. And the component — it's nothing. It's not the secret of the Bombe. It's just a part. The German's think it's a weapon — a missile component. Let them have it. Please, man. Just help me." / "求你了，Hooper。你不明白。他们有关于我的信息。我不需要告诉你我做过什么，你知道的。有点同情心吧。还有那个元件——它什么也不是。它不是 Bombe 的秘密。它只是一个零件。德国人以为它是武器——一个导弹零件。让他们拿去吧。求你了，兄弟。帮帮我。"
		"Help you?" Hooper stares. "Help you? You're a traitor. A snake in the grass. And you're <i>queer</i>." / "帮你？" Hooper 盯着看。"帮你？你是个叛徒。一条草丛中的蛇。而且你是<i>同性恋</i>。"
		 * * 	[Deny] / [否认]
		 		"I'm no traitor. You <i>know</i> I'm not. How much work have I done here against the Germans? I've given my all. And you know as well as I do, if the Reich were to invade, I would be a dead man. Please, Hooper. I'm not doing any of this lightly." / "我不是叛徒。你<i>知道</i>我不是。我在这里对德国人做了多少工作？我付出了我的一切。你跟我一样清楚，如果帝国入侵，我会是个死人。求你了，Hooper。我做这些事没有一件是轻松的。"

		 * * 	[Accept] / [接受]
		 		"I am what I am," I reply. "I'm the way I was made. But they'll hang me unless you help, Hooper. Don't let them hang me." / "我就是我，"我回答。"我是生来如此。但如果你不帮忙，他们会绞死我的，Hooper。别让他们绞死我。"

		 * * 	[Evade] / [回避]
		 		"That's not important now. What matters is what you do, this evening." / "那现在不重要了。重要的是你今晚做什么。"

		 - - 	"Assuming I wanted to help you," he replies, carefully. "Which I don't. What would I do?" / "假设我想帮你，"他小心翼翼地回答。"但我不想。我会怎么做？"
				"Nothing. Almost nothing. / "什么都不做。几乎什么都不做。"
				-> back_of_hut_2

= back_of_hut_2
	<> All you have to do is go to the back of Hut 2. There's a breeze—block with a cavity. That's where I've put it. I'll be locked up overnight. But you can pick it up and pass it to my contact. He'll be at the south fence around two AM." / <> 你所需要做的就是去 2 号小屋后面。有一个带空洞的煤渣砖。那就是我放它的地方。我会被关一整夜。但你可以取走它，交给我的联系人。他会在凌晨两点左右在南边围栏那里。"
	~ hooperClueType = STRAIGHT
	 -> no_chance

= no_chance
	"If you think I'll do that then you're crazy," Hooper replies. / "如果你以为我会这么做，那你就是疯了。" Hooper 回答。
	At that moment the door flies open and the Captain comes storming back inside. / 就在那一刻，门猛地打开，上尉冲了回来。
	 -> hustled_out

= hustled_out
	// To Barracks / 去兵营
	Harris hustles me over to the barracks. "I hope that's the end of it," he mutters. / Harris 把我推到兵营。"我希望这就是结局了，"他嘟哝道。
	"Just be sure to let him out," I reply. "And then see where he goes." / "只要确保把他放出去就行，"我回答。"然后看他去哪里。"
	 -> slam_door_shut_and_gone



/*--------------------------------------------------------------------------------
	Left alone overnight / 被独自关了一夜
--------------------------------------------------------------------------------*/


=== slam_door_shut_and_gone
	Then they slam the door shut, and it locks. / 然后他们把门猛地关上，锁住了。
	{ hooperClueType == NONE :
		<> How am I supposed to manage anything from in here? / <> 我在里面能做什么呢？
		*   [Try the door] -> try_the_door / [试试门] -> try_the_door
		* 	[Try the windows] -> try_the_windows / [试试窗户] -> try_the_windows

	- else:
		I can only hope that Hooper bites. If he thinks I'm bitter enough to have framed him, and arrogant enough to have taunted him with {hooperClueType > STRAIGHT:a clue to} where the damning evidence is hidden... / 我只能希望 Hooper 上钩。如果他认为我怀着足够的怨恨来陷害他，又足够傲慢地嘲弄他{hooperClueType > STRAIGHT:用线索}指出那致命证据的藏匿处……
		If he hates me enough, and is paranoid enough, then he might {hooperClueType > STRAIGHT:unravel my little riddle and} go searching around Hut 2. / 如果他恨我足够深，又足够偏执，那么他可能会{hooperClueType > STRAIGHT:解开我的小谜语然后}去 2 号小屋附近搜索。
	}

	 * 	[Wait] 	-> night_falls / [等待] -> night_falls


= try_the_door
	I try the door. It's locked, of course. / 我试了试门。当然是锁着的。
	 -> from_outside_heard

= from_outside_heard
	From outside, I hear a voice. Hooper's. He's haranguing someone. / 从外面，我听到一个声音。是 Hooper 的。他在斥责某人。
	- (opts)
	*  (listened) [Listen at the keyhole] / [在钥匙孔处听]
			I put my ear down to the keyhole, but there's nothing now. Probably still a guard outside, of course, but they're keeping mum. / 我把耳朵凑到钥匙孔上，但现在什么也听不到。外面大概还有卫兵，当然，但他们保持沉默。
			-> opts

	* { not try_the_windows  }   [Try the window] -> try_the_windows / [试试窗户] -> try_the_windows
	* { not try_the_door  } {listened}   [Try the door] -> try_the_door / [试试门] -> try_the_door
	* { try_the_windows  }   [Smash the window] -> try_to_smash_the_window / [砸碎窗户] -> try_to_smash_the_window
	* { try_the_door  && try_the_windows  }   [Wait] / [等待]
	 		It's useless. There's nothing I can do but hope. I sit down on one corner of the bunk to wait. / 没用的。除了希望，我什么也做不了。我坐在铺位的一角等着。
 			-> night_falls

= try_the_windows
	I go over to the window and try to jimmy it open. Not much luck, but in my struggling I notice this window only backs on the thin little brook that runs down the back of the compound. Which means, if I smashed it, I might get away with no—one seeing. / 我走到窗边，试着撬开它。运气不佳，但在挣扎中我注意到这扇窗只靠着营地后面那条小溪。这意味着，如果我砸碎它，也许可以在没人看到的情况下逃脱。
	 -> from_outside_heard


= try_to_smash_the_window
	The window is my only way out of here. I just need a way to smash it. / 窗户是我离开这里的唯一通道。我只需要一个打碎它的方法。
	 * [Punch it] / [用拳头砸]
	 	I suppose my fist would do a good enough job. But I'd cut myself to ribbons, most likely. <> / 我觉得我的拳头也许能行。但我很可能会把自己割得遍体鳞伤。<>

	 * (use_bucket) [Find something] / [找点东西]
			 ~ smashingWindowItem = BUCKET
			I cast around the small room. There's a bucket in one corner for emergencies — I suppose I could use that. I pick it up but it's not very easy to heft. <> / 我在小房间里四处寻找。角落里有一个应急用的桶——我想我可以用它。我拿起它，但要挥动它并不容易。<>
	 * [Use something you've got] / [用你带着的东西]
		 	I pat down my pockets but all I'm carrying is the intercept, which is no good at all. / 我拍了拍口袋，但我身上只带着那份密文，完全没用。
			* * [Something you're wearing?] / [身上穿的东西？]
					Ah, but of course! I slip off one shoe and heft it by the toe. The heel will make a decent enough hammer, if I give it enough wallop. / 啊，当然！我脱下一只鞋，捏着鞋头掂量。如果我用足够大的力道，鞋跟可以当一把不错的锤子。
					 ~ smashingWindowItem  = SHOE
					But I'll cut my hand to ribbons doing it. <> / 但这样做我会把手割得遍体鳞伤。<>
			* * [Look around] -> use_bucket / [环顾四周] -> use_bucket
	- 	And the noise would be terrible. There must be a way of making this easier. I'm supposed to be a thief now. What would a burglar do? / 而且噪音会很大。一定有办法让它更容易。我现在应该算是个贼了。一个窃贼会怎么做？
	 	* [Work slowly] / [慢慢来]
	 		Work carefully? It's difficult to work carefully when all one's has is { smashingWindowItem == BUCKET :a bucket. It's rather like the sledgehammer for the proverbial nut|{ smashingWindowItem == SHOE :a shoe|nothing but brute force}}. / 小心翼翼地？当你所有的只是{ smashingWindowItem == BUCKET :一个桶——有点像用大锤砸坚果|{ smashingWindowItem == SHOE :一只鞋|只是蛮力}}时，很难做到小心翼翼。
			 * * 	[Just do it] -> time_to_move_now / [就做吧] -> time_to_move_now
			 * * 	[Look around for something] / [找点东西]
	 	* [Find something to help] / [找点能帮忙的东西]
	- -> find_something_to_smash_window


= time_to_move_now
	Enough of this. There isn't any time to lose. Right now they'll be following Hooper as he goes to bed, and goes to sleep; and then that's it. The minute he closes his eyelids and drifts off that's the moment that this trap swings shut on me. / 够了。没有时间可以浪费了。现在他们正跟着 Hooper 回床睡觉；然后就这样了。他一闭上眼睛入睡的那一刻，就是这个陷阱对我彻底关闭的时刻。
	So I punch out the glass with my { smashingWindowItem == BUCKET :bucket|{ smashingWindowItem == SHOE :shoe|fist}} and it shatters with a terrific noise. Then I stop, and wait, to see if anyone will come in through the door. / 于是我用我的{ smashingWindowItem == BUCKET :桶|{ smashingWindowItem == SHOE :鞋|拳头}}砸碎了玻璃，伴随着巨大的声响。然后我停下来，等着，看是否有人会从门口进来。
	Nothing. / 没有。
	 * (pause) [Wait a little longer] / [再等一会儿]
		 I pause for a moment longer. It doesn't do to be too careless... / 我再停顿了一会儿。太不小心可不行……
	 * [Clear the frame of shards] / [清理窗框上的碎玻璃]
		With my jacket wrapped round my arm, I sweep out the remaining shards of glass. It's not a big window, but I'm not a big man. If I was Harris, I'd be stuffed, but as it is... / 用外套裹住手臂，我扫掉剩下的碎玻璃。窗户不大，但我也不大。如果我是 Harris，就卡住了，但事实上……

	 -	Then the door locks turns. The door opens. Then Jeremy — one of the guards, rather — sticks his head through the door. "I thought I heard..." / 然后门锁转动。门开了。然后 Jeremy——确切说是一个卫兵——把头探进门来。"我以为我听到了……"
		He stops. Looks for a moment. { smashingWindowItem ==BUCKET :Sees the bucket in my hand.|Sees the broken window.} Then without a moment's further thought he blows his shrill whistles and hustles into the hut, grabbing me roughly by my arms. / 他停下来。看了一会儿。{ smashingWindowItem ==BUCKET :看到我手里的桶。|看到碎了窗户。} 然后不假思索地吹响哨子，冲进小屋，粗暴地抓住我的手臂。
		{ pause:
			I'll never know if I hadn't have waited that extra moment — maybe I still could have got away. But, how far? / 我永远也不会知道如果我没有多等那一下——也许我还能逃脱。但，能走多远？
		}
		I'm hustled into one of the huts. Nowhere to sleep, but they're not interested in my comfort any longer. Harris comes in with the Captain. / 我被推进一间小屋。没地方睡觉，但他们不再关心我的舒适了。Harris 和上尉一起进来了。
		"So," Harris remarks. "Looks like your little trap worked. Only it worked to show <i>you</i> out for what you are." / "那么，" Harris 评论道。"看来你的小陷阱奏效了。只是它起作用的结果是揭示了你<i>自己</i>的真面目。"
		* 	[Tell the truth] / [说实话]
			 { i_met_a_young_man  :
				"Please, Harris. You can't understand the pressure they put me under. You can't understand what it's like, to be in love but be able to do nothing about it..." / "拜托，Harris。你无法理解他们对我施加的压力。你无法理解那是什么感觉，爱着却不能做任何事……"
			- else:
				"Harris. They were blackmailing me. They knew about... certain indiscretions. You can understand, can't you, Harris? I was in an impossible bind..." / "Harris。他们在敲诈我。他们知道……某些不检点的行为。你能理解吧，Harris？我处于一个不可能的困境中……"
			}
		* 	[Lie] / [撒谎]
			 "I had to get out, Harris. I had to provoke Hooper into doing something that would incriminate himself fully. He's too clever, you see..." / "我必须出去，Harris。我必须激怒 Hooper，让他做出彻底自陷罪责的事。他太聪明了，你看……"

		* 	[Evade] / [回避]
		 	"This proves nothing," I reply stubbornly. "You still don't have the component and without it, I don't see what you can hope to prove." / "这什么也证明不了，"我固执地回答。"你仍然没有那个元件，没有它，我不认为你能证明什么。"

	 -	"Be quiet, man. We know all about your and your sordid affairs." The Captain curls his lip. "Don't you know there's a war on? Do you know the kind of place they would have sent you if it haven't had been for that brain of yours? Don't you think you owe it to your country to use it a little more?" / "住口，老兄。我们对你的肮脏勾当全都知道。"上尉翘起嘴唇。"你不知道在打仗吗？你知道要不是因为你的那个脑子，他们会把你送到什么样的地方吗？你不觉得你欠你的国家点东西，该好好使用它吗？"

		<i>Do I</i>, I wonder? <i>Do I owe this country anything, this country that has spurned who and what am I since the day I became a man?</i> / <i>我欠吗</i>，我想？<i>我欠这个国家什么吗，这个自从我成为男人的那一天起就唾弃我是谁和我是什么的国家？</i>
		 * [Yes] / [是的]
			 	My anger deflates like a collapsing equation, all arguments cancelling each other out. The world, of course, owes me nothing; and I owe it everything. / 我的愤怒像崩溃的方程式一样泄了气，所有论点互相抵消。世界，当然，不欠我什么；而我欠它一切。

		 * 	(alone) [No] / [不]
				 <i>Of course not. I am alone; that is what they wanted me to be, because of who and what I love. So I have no nation, no country.</i> / <i>当然不。我是孤身一人；这就是他们想让我成为的，因为我爱的是谁、是什么。所以我没有民族，没有国家。</i>


		 * [Lie] 	-> alone / [撒谎] -> alone
		 * [Evade] / [回避]
		 		<i>But what is a country, after all? A country is not a concept, not an ideal. Every country falls, its borders shift and move, its language disappears to be replaced by another. Neither the Reich nor the British Empire will survive forever, so what use is my loyalty to either? </i> / <i>但说到底，一个国家是什么？一个国家不是一个概念，不是一个理想。每个国家都会灭亡，它的边界会变迁和移动，它的语言会消失并被另一种取代。帝国或大英帝国都不会永存，那么我对其中任何一个的忠诚有什么用？</i>
				<i>I may as well, therefore, look after myself. Something I have attempted, but failed miserably, to do.</i> / <i>因此，我不妨照顾好自己。这是我一直尝试但惨败的事情。</i>

	- //  Tell us where / 告诉我们在哪里
		"I'm afraid we have only one option, Manning," Harris says. "Please, man. Tell us where the component is." / "恐怕我们只有一个选择，Manning，" Harris 说。"求你了，老兄。告诉我们元件在哪里。"
		 ~ notraitor  = true
		 ~ losttemper = false
		 * [Tell them] / [告诉他们]
		 	~ revealedhooperasculprit = false
		 	"All right." I am beaten, after all. "<>-> reveal_location_of_component / "好吧。"毕竟，我被打败了。"<>-> reveal_location_of_component

		 * [Say nothing] -> my_lips_are_sealed / [什么都不说] -> my_lips_are_sealed

= find_something_to_smash_window
	Let me see. There's the bunk, { not smashingWindowItem == BUCKET :a bucket,} nothing else. I have my jacket but nothing in the pockets — no handkerchief, for instance. / 让我看看。有那张铺位，{ not smashingWindowItem == BUCKET :一个桶，}别的没了。我有外套但口袋里什么都没有——没有手帕，比如说。
	- (opts)
	*   [The bunk] / [铺位]
		The bunk has a solid metal frame, a blanket, a pillow, nothing more. / 铺位有一个结实的金属框架、一条毯子、一个枕头，没别的了。
		- - (bunk_opts)
		* *  [The frame] / [框架]
			 	The frame is heavy and solid. I couldn't lift it or shift it without help from another man. And it wouldn't do me any good here anyway. I can reach the window perfectly well. / 框架又重又结实。没有别人的帮助，我抬不动也挪不了它。而且在这里它对我也没有用处。我完全可以够到窗户。
				 -> bunk_opts
		* * [The blanket] / [毯子]
		 		The blanket. Perfect. I scoop it up off the bed and hold it in place over the window. -> smash_the_window / 毯子。完美。我从床上抓起它，把它固定在窗户上。-> smash_the_window
		* * [The pillow] / [枕头]
		 		The pillow is fat and fluffy. I could put it over the window and it would muffle the sound of breaking glass, certainly; but I wouldn't be able to break any glass through it either. / 枕头又厚又软。我可以把它盖在窗户上，它当然会消减碎玻璃的声音；但我也无法隔着它打碎玻璃。
				 -> bunk_opts

		* * {bunk_opts > 1} [Something else] -> opts / [别的什么] -> opts

	* [The jacket] / [外套]
			I slip off my jacket and hold it with one hand over the glass. -> smash_the_window / 我脱下外套，用一只手把它按在玻璃上。-> smash_the_window
	* { not smashingWindowItem == BUCKET  }   [The bucket] / [桶]
	 		The bucket? Hardly. The bucket might do some good if I wanted to sweep up the glass afterwards, but it won't help me smash the glass quietly. / 桶？不太行。如果我想事后扫碎玻璃，桶也许有用，但它帮不了我安静地砸碎玻璃。
		 	-> opts


=== smash_the_window
	//  Smashing glass / 砸玻璃
		Then I heft { smashingWindowItem == BUCKET :up the bucket — this really is quite a fiddly thing to be doing in cuffs — |{ smashingWindowItem == SHOE : my shoe by its toe, |back my arm, }} and take a strong swing, trying to imagine it's Harris' face on the other side. / 然后我举起{ smashingWindowItem == BUCKET :桶——戴着镣铐做这件事真的很费劲——|{ smashingWindowItem == SHOE :我的鞋捏着鞋头，|我的手臂，}}用力一挥，试图想象玻璃另一面是 Harris 的脸。
	 	~ smashedglass  = true
	 	~ smashingWindowItem = NONE
		*	[Smash!] / [砸！]
	-	The sound of the impact is muffled. With my arm still covered, I sweep out the remaining glass in the frame. / 撞击的声音被闷住了。我的手臂还裹着，我扫掉窗框里剩下的玻璃。
	-	I'm ready to escape. The only trouble is — when they look in on me in the morning, there will be no question what has happened. It won't help me one jot with shifting suspicion off my back. / 我准备好逃跑了。唯一的问题是——当他们早上来看我时，毫无疑问发生了什么。这对我摆脱嫌疑一点帮助也没有。
		* [Wait] / [等待]
		 		So perhaps I should wait it out, after all. Who knows? I might have a better opportunity later. / 所以也许我还是该等下去。谁知道呢？也许以后会有更好的机会。
			 	-> night_passes
		* [Slip out] / [溜出去]
		 		Moving quickly and quietly, I hoist myself up onto the window—frame and worm my way outside into the freezing night air. Then I am away, slipping down the paths between the Huts, sticking to the shadows, on my way to Hut 2. / 我快速而安静地行动，把自己撑上窗框，蠕动着钻出去，进入冰冷的夜空气中。然后我就走了，沿着小屋之间的小路溜过去，贴着阴影，前往 2 号小屋。
	// Out at night / 夜间外出
	-
		 * [Go the shortest way] / [走最短的路]
			 	There's no time to lose. Throwing caution to the wind I make my way quickly to Hut 2, and around the back. I don't think I've been seen but if I have it is too late. My actions are suspicious enough for the noose. I have no choice but to follow through. / 没有时间可浪费了。我把谨慎抛在脑后，快速走到 2 号小屋，绕到后面。我觉得没有被看到，但如果被看到了，也已经太晚了。我的行动足以让人疑心到被绞死。我别无选择，只能坚持到底。
		 * [Take a longer route] / [走更长的路]
		 		In case I'm being followed, I divert around the perimeter of the compound. It's a much longer path, and it takes me across some terrain that's difficult to negotiate in the dark — muddy, and thick with thistles and nestles. / 以防被跟踪，我绕道营地的外围。这条路长得多，带我穿过一些在黑暗中难以行进的地形——泥泞，布满蓟草和荨麻。
				~ muddyshoes  = true
				Still, I can be confident no—one is behind me. I crouch down behind the rear wall of Hut 2. <> / 不过，我可以确定身后没有人。我蹲在 2 号小屋的后墙后面。<>
	- 	The component is still there, wrapped in a tea—towel and shoved into a cavity in a breeze—block at the base of the Hut wall. / 元件还在那里，用一块茶巾包着，塞在小屋墙根处的煤渣砖洞里。
	 	* [Take it] / [拿走]
	 		Quickly, I pull it free, and slip it into the pocket of my jacket. / 我迅速把它拔出来，滑进外套口袋里。
			~ gotcomponent  = true

	 	* [Leave it] / [留下]
	 		Still there means no—one has found it, which means it is probably well—hidden. And short of skipping the compound now, I can afford to leave it hidden there a while longer. So I leave it in place. / 还在那里意味着没有人找到它，这意味着它可能藏得很好。除非现在就逃离营地，我可以让它再藏在那里一段时间。所以我让它留在原处。
	-  Where now? / 现在去哪？
	 	* 	[Back to the barracks] -> return_to_room_after_excursion / [回兵营] -> return_to_room_after_excursion
	 	* 	{ gotcomponent  }  [Go to Hooper's dorm] -> go_to_hoopers_dorm / [去 Hooper 的宿舍] -> go_to_hoopers_dorm
 		* 	[Escape the compound] / [逃离营地]
			Enough of this place. Time for me to get moving. I can get to the train station on foot, catch the postal train to Scotland and be somewhere else before anyone realises that I'm gone. / 受够了这个地方。该出发了。我可以步行到火车站，搭邮政列车去苏格兰，在任何人发现我走了之前到达别的地方。

			Of course, then they'll be looking for me in earnest. { not framedhooper :As a confirmed traitor.|Perhaps not as a traitor — they might take the idea that Hooper was involved with the theft — but certainly as a valuable mind, one containing valuable secrets and all too easily threatened. They will think I am running away because of my indiscretions. I suppose, in fairness, that I am.} / 当然，然后他们就会认真地寻找我了。{ not framedhooper :作为一个确认的叛徒。|也许不是作为一个叛徒——他们可能会接受 Hooper 参与了盗窃的想法——但肯定作为一个宝贵的头脑，一个包含宝贵秘密且太容易被胁迫的头脑。他们会以为我是因为我的不检点行为而逃跑。公平地说，我想我确实是。}
			* * [Go] 			-> live_on_the_run / [走] -> live_on_the_run
			* * [Don't go] / [不走]
				 	It's no good. That's only half a solution. I couldn't be happy with that. / 不行。那只是半个解决方案。我不会对此满意。
					* * * 	[Back to the barracks] 			-> return_to_room_after_excursion / [回兵营] -> return_to_room_after_excursion
					* * * 	{ gotcomponent   && not go_to_hoopers_dorm  }  [To Hooper's dorm] -> go_to_hoopers_dorm / [去 Hooper 的宿舍] -> go_to_hoopers_dorm



=== go_to_hoopers_dorm
	// Hooper's Dorm / Hooper 的宿舍
	I creep around the outside of the huts towards Hooper's dorm. Time to wrap up this little game once and for all. A few guards patrol the area at night but not many — after all, very few know this place even exists. / 我沿着小屋的外围爬向 Hooper 的宿舍。是时候一劳永逸地结束这场小游戏了。夜间有几个卫兵巡逻该区域，但不多——毕竟，很少有人知道这个地方存在。
	Our quarters are arranged away from the main house; where we sleep is of less importance than where we work. We each have our own hut, through some are less permanent than others. Hooper's is a military issue tent: quite a large canopy, with two rooms inside and a short porch area where he insists people leave their shoes. It's all zipped up for the night and no light shines from inside. / 我们的宿舍远离主楼布置；我们睡觉的地方不如工作的地方重要。我们各人有自己的小屋，有些比其他更不固定。Hooper 的是一个军用帐篷：相当大的篷顶，里面有两个房间，还有一个短门廊区域，他坚持让人在那里脱鞋。整夜都拉着拉链，里面没有光亮透出来。
	I hang back for a moment. If Harris is keeping to the terms of our deal then someone will be watching this place. But I can see no—one. / 我犹豫了一会儿。如果 Harris 遵守我们交易的条件，那么会有人在看着这个地方。但我看不到任何人。
	 * (outer_zip) [Open the outer zip] / [打开外层拉链]
		 	I creep forward to the tent, intent on lifting the zip to the front porch area just a little — enough to slip the component inside, and without the risk of the noise waking Hooper from his snoring. / 我爬向帐篷，意图将前面门廊区域的拉链拉开一点点——刚好够把元件塞进去，而且没有声音吵醒打鼾的 Hooper 的风险。
			The work is careful, and more than little fiddly — Hooper has tied the zips down on the inside, the fastidious little bastard! — but after a little work I manage to make a hole large enough for my hand. / 这工作很小心，而且相当费力——Hooper 从里面把拉链系住了，这个挑剔的小混蛋！——但费了一番功夫后，我成功弄出了一个能让我的手通过的洞。
			* * [Slip in the component] / [塞入元件]
					I slide the component into the tent, work the zip closed, and move quickly away into the shadows. It takes a few minutes for my breath to slow, and my heart to stop hammering, but I see no other movement. If anyone is watching Hooper's tent, they are asleep at their posts. / 我把元件滑进帐篷，把拉链拉回原位，然后迅速退入阴影中。几分钟后我的呼吸才平缓下来，心跳不再猛跳，但我没有看到其他动静。如果有人在看着 Hooper 的帐篷，他们在岗位上睡着了。
					 ~ putcomponentintent  = true
					 ~ gotcomponent = false
					 -> return_to_room_after_excursion
			* * [No, some other way] / [不，换个方法]
					Then pause. This is too transparent. Too blatant. If I leave it here, like this, Hooper will never be seen to go looking for it: he will stumble over it in plain sight, and the men watching will wonder why it was not there when he went to bed. / 然后停下来。这太透明了。太明显了。如果我就这样把它留在这里，Hooper 永远不会被发现去寻找它：他会在众目睽睽之下绊到它，暗中监视的人会奇怪为什么他上床睡觉时它不在那里。
					No, I must try something else — or nothing at all. / 不，我必须尝试别的——或者什么都不做。
					* * * 	[On top of the tent] -> put_component_on_tent / [帐篷顶上] -> put_component_on_tent
					* * * 	[Throw the component into the long grass] / [把元件扔进长草丛]
					 	From inspiration — or desperation, I am not certain — a simple approach occurs to me. -> toss_component_into_bushes / 来自灵感——或绝望，我不确定——一个简单的方法在我脑海中浮现。-> toss_component_into_bushes
					* * * 	[Give up] / [放弃]
							There is nothing to be gained here. I have the component now; maybe it will be of some value tomorrow. / 这里什么也得不到。我现在有元件了；也许明天它会有一些价值。
							* * * * [Return to my barrack] -> return_to_room_after_excursion / [回我的兵营] -> return_to_room_after_excursion
							* * * * [Escape the compound] -> live_on_the_run / [逃离营地] -> live_on_the_run

	 * (wide_circuit) [Look for another opening] / [寻找另一个开口]
		 	Making a wide circuit I creep around the tent. It has plenty of other flaps and openings, tied down with Gordian complexity. But nothing afford itself to slipping the component inside. / 绕一个大圈，我围着帐篷爬。它有很多其他的翻盖和开口，以难以解开的复杂方式系着。但没有任何一个适合把元件塞进去。
			* * [Try the porch zip] 			-> outer_zip / [试门廊拉链] -> outer_zip
			* * [Try on top of the tent] 		-> put_component_on_tent / [试帐篷顶上] -> put_component_on_tent
			* * [Give up] / [放弃]
				It's no good. Nothing I can do will be any less than obvious — something appearing where something was not there before. The men watching Hooper will know it is a deception and Hooper's protestations will be taken at face value. / 不行。无论我做什么都不会不显得明显——某物出现在之前没有的地方。监视 Hooper 的人会知道这是一个骗局，Hooper 的否认会被信以为真。
				If I can't find a way for Hooper to pick the component up, as if from a hiding place of his own devising, and be caught doing it, then I have no plan at all. / 如果我找不到办法让 Hooper 拿起元件，好像从他自己的藏匿处拿起的，并被抓个正着，那么我就完全没有计划。
				* * * [Return to my barrack] -> return_to_room_after_excursion / [回我的兵营] -> return_to_room_after_excursion
				* * * [Escape the compound] -> live_on_the_run / [逃离营地] -> live_on_the_run
				* * * [Toss the component into the bushes] -> toss_component_into_bushes / [把元件扔进灌木丛] -> toss_component_into_bushes

	 * [Hide the component somewhere] / [把元件藏在某处]
	 		If I leave the component here somewhere it should be somewhere I can rely on Hooper finding it, but no—one before Hooper. In particular. / 如果我把元件留在这里的某处，它应该在一个我能依赖 Hooper 找到的地方，但 Hooper 之前没有人找到。尤其如此。
			* * [Behind the tent]			 	-> wide_circuit / [帐篷后面] -> wide_circuit
			* * [Inside the porch section] 		-> outer_zip / [门廊区域内] -> outer_zip
			* * [On top of the canvas] 			-> put_component_on_tent / [帆布顶上] -> put_component_on_tent


= put_component_on_tent
	A neat idea strikes me. If I could place it on top of the canvas, somewhere in the middle where it would bow the cloth inwards, then it would be invisible to anyone passing by. But to Hooper, it would be above him: a shadow staring him in the face as he awoke. What could be more natural than getting up, coming out, and looking to see what had fallen on him during the night? / 一个巧妙的主意突然出现在我脑海中。如果我能把它放在帆布顶上，放在中间某个使布料向内凹陷的地方，那么它对任何路过的人来说都是看不见的。但对 Hooper 来说，它会在他上面：一个阴影，在他醒来时盯着他的脸。有什么比起床、出来、看看夜里有什么掉在他身上更自然的呢？

	It's the work of a moment. I was once an excellent bowler for the second XI back at school. This time I throw underarm, of course, but I still land the vital missing component exactly where I want it to go. / 片刻的功夫。我曾在学校的二队是个优秀的投球手。这次我当然用低手投，但我仍然让那个关键的缺失元件准确地落在我想要的位置上。
	 ~ framedhooper  = true
	 ~ gotcomponent = false
	For a second I hold my breath, but nothing and no—one stirs. -> return_to_room_after_excursion / 我屏住呼吸一秒钟，但没有任何人事物动弹。-> return_to_room_after_excursion


= toss_component_into_bushes
	I toss the component away into the bushes behind Hooper's tent and return to my barrack, wishing myself a long sleep followed by a morning, free of this business. / 我把元件扔进 Hooper 帐篷后面的灌木丛中，回到我的兵营，希望自己一觉睡到天亮，摆脱这桩事。
	 ~ gotcomponent = false
	 ~ throwncomponentaway  = true
	 -> return_to_room_after_excursion



=== live_on_the_run
	Better to live on the run than die on the spit. Creeping around the edge of the compound{ gotcomponent :, the Bombe component heavy in my pocket}, I make my way to the front gate. As always, it's manned by two guards, but I slip past their box by crawling on my belly. / 宁愿亡命天涯也不要被串起来烤死。我沿着营地边缘爬行{ gotcomponent :, Bombe 元件在我口袋里沉甸甸的}，走到前门。一如既往，有两个人看守，但我匍匐爬过了他们的岗亭。
	And then I'm on the road. Walking, not running. Silent. Free. / 然后我就上了路。走着，不是跑着。安静地。自由了。
	//  End - Run Away / 结局——逃跑
	For the moment, at least. / 至少，此刻如此。
	-> END



=== return_to_room_after_excursion
	{ gotcomponent :The weight of the Bombe component safely in my jacket|Satisfied}, I return the short way up the paths between the huts to the barrack block and the broken window. / { gotcomponent :Bombe 元件的重量安全地在我外套里|满意地}，我沿小屋之间的小路走捷径回到兵营和那扇破窗。
	It's a little harder getting back through — the window is higher off the ground than the floor inside — but after a decent bit of jumping and hauling I manage to get my elbows up, and then one leg, and finally I collapse inside, quite winded and out breath. / 回去稍微难一点——窗户离地面的高度比里面地板高——但经过一阵像样的跳跃和拉扯，我成功撑起了肘部，然后一条腿，最终我瘫倒在里面，气喘吁吁。
	 *  [Wait]  	-> night_passes / [等待] -> night_passes



=== night_passes
// In room smashed glass / 房间里有碎玻璃
	The rest of the night passes slowly. I sleep a little, dozing mostly. Then I'm woken by the rooster in the yard. The door opens, and Harris comes in. He takes one look at the broken window and frowns with puzzlement. / 后半夜慢慢过去。我睡了一小会儿，大多是打盹。然后被院子里的公鸡叫醒。门开了，Harris 走进来。他看了一眼碎窗户，困惑地皱起眉头。
	{ putcomponentintent: -> put_component_inside_tent }

	"What happened there?" / "那边发生了什么？"
 	* [Confess] / [坦白]
	 	"I broke it," I reply. There doesn't seem any use in trying to lie. "I thought I could escape. But I couldn't get myself through." / "我打碎的，"我回答。撒谎似乎没有任何用处。"我以为我可以逃走。但我钻不过去。"
		The Commander laughs. -> glad_youre_here / 指挥官笑了。-> glad_youre_here

	* (deny) [Deny] / [否认]
	 	"I'm not sure. I was asleep: I woke up when someone broke the window. I looked out to see who it was, but they were already gone." / "我不确定。我在睡觉：有人打碎窗户时我醒了过来。我往外看是谁，但已经走了。"
		Harris looks at me with puzzlement. "Someone came by to break the window, and then ran off? That's absurd. That's utterly absurd. Admit it, Manning. You tried to escape and you couldn't get through." / Harris 困惑地看着我。"有人来砸碎窗户，然后跑掉了？太荒谬了。简直荒谬至极。承认吧，Manning。你试图逃跑但钻不过去。"
		* * [Admit it] / [承认]
	 		"All right. {forceful>1:Damn you.} That's exactly it." / "好吧。{forceful>1:该死。} 正是如此。"
	 		-> glad_youre_here

	 	* * { not framedhooper  }   [Deny it] / [否认]
	 		"If I wanted to escape, I would have made damn sure that I could," I tell him sternly. / "如果我想逃跑，我一定会确保我能，"我严厉地告诉他。
	 		-> harris_certain_is_you

	 	* * { framedhooper  }   [Deny it] / [否认]
		 	"I tell you, someone broke it. Someone wanted to threaten me, I think." / "我告诉你，有人打碎的。有人想威胁我，我想。"
			Harris shakes his head. "Well, we can look into that matter later. For now, you probably want to hear the more pressing news. -> found_missing_component / Harris 摇摇头。"好吧，我们稍后再查那件事。现在，你大概想听更紧迫的消息。-> found_missing_component

 	* { gotcomponent  }   [Show him the component] -> someone_threw_component / [给他看元件] -> someone_threw_component

= put_component_inside_tent
	He takes one look around, and sighs, a deep, wistful sigh. / 他环顾了一圈，叹了口气，一声深深的、怅然的叹息。
	"Things just get worse and worse for you, Manning," he remarks. "You are your own worst enemy." / "事情对你来说越来越糟，Manning，"他评论道。"你是你自己最大的敌人。"
	 * [Agree] / [同意]
	 	"I've thought so before." { admitblackmail :Certainly in the matter of getting blackmailed.} / "我以前也这么想过。" { admitblackmail :当然是在被敲诈这件事上。}
		"Let me tell you what happened this morning. <> / "让我告诉你今天早上发生了什么。<>

	 * [Disagree] / [不同意]
	 	"Right now, I think you take that role, Harris," I reply coolly. / "现在，我觉得那个角色是你，Harris，"我冷静地回答。
	 	- - (droll)	"Very droll," he replies. "Let me tell you what happened this morning. It will take the smile off your face. <> / "很滑稽，"他回答。"让我告诉你今天早上发生了什么。这会让你笑不出来的。<>

	 * [Evade] / [回避]
	 	"I'm looking forward to having a wash and a change of clothes; which should make me a little less evil to be around." / "我期待着洗个澡换身衣服；这应该会让我没那么令人讨厌。"
	 	-> droll

	-	Our men watching Hooper's tent saw Hooper wake up, get dressed, clamber out of his tent and then step on something in at the entrance of his tent." / 我们监视 Hooper 帐篷的人看到 Hooper 醒来，穿好衣服，爬出帐篷，然后在帐篷入口处踩到了什么东西。
	 	~ piecereturned  = true
	 * [Be interested] / [感兴趣]
	 	"You mean he didn't even hide it? He put it in his shoe?" / "你是说他甚至没有藏起来？他把它放在鞋里了？"
	 	- - (not_that) "No," Harris replies. "That isn't really what I mean. <> / "不，" Harris 回答。"那不是我真的意思。<>

	 * 	[Be dismissive] / [不以为意]
	 	"So he's an idiot, and he hid it in his shoe." / "所以他是个白痴，把它藏在鞋里了。"
		 -> not_that

	 * [Say nothing] / [什么都不说]
	 	I say quiet, listening, not sure how this will go. / 我安静地说着，听着，不确定这会如何发展。
		"In case I'm not making myself clear," Harris continues, "<> / "如果我没说清楚的话，" Harris 继续说，"<>

	- 	I mean, he managed to find it, by accident, somewhere where it wasn't the night before. And at the same time, you're sitting here with your window broken. So, I rather think you've played your last hand and lost. It's utterly implausible that Hooper stole that component and then left it lying around in the doorway of his tent. So I came to tell you that the game is up, for you." / 我的意思是，他偶然在人前一天晚上它不在的地方找到了它。同时，你坐在这里，窗户碎了。所以，我相当认为你已经打完了你的最后一张牌，输了。Hooper 偷了那个元件然后把它扔在帐篷门口，这完全难以置信。所以我是来告诉你，游戏结束了，对你来说。"
		He nods and gets to his feet. -> left_alone / 他点点头，站起来。-> left_alone



= someone_threw_component
	"Someone threw this in through the window over night," I reply, and open my jacket to reveal the component from the Bombe. "I couldn't see who, it was too dark. But I know what it is." / "有人夜里把这个从窗户扔了进来，"我回答，打开外套露出 Bombe 的元件。"我看不清是谁，太暗了。但我知道这是什么。"
	He reaches out and takes it. "Well, I'll be damned," he murmurs. "That's it all right. And you didn't have it on you when we put you in here. But it can't have been Hooper — I had men watching him all night. And there's no—one else it could have been." / 他伸手接过。"好吧，我见鬼了，"他喃喃道。"就是它没错。我们把你关进来的时候你身上没有。但也不可能是 Hooper——我有整夜让人看着他。而且也不可能是别的人。"
	He turns the component over in his hands, bemused. / 他把元件在手中翻来翻去，困惑着。
	 ~ piecereturned  = true
	 * [Suggest something] / [提出点什么]
	 	"Perhaps Hooper had an accomplice. Someone else who works on site." / "也许 Hooper 有同谋。其他在这个地方工作的人。"
		Harris shakes his head, distractedly. "That doesn't make sense," he says. "Why go to all the trouble of stealing it only to give it back? And why like this?" / Harris 心烦意乱地摇摇头。"这说不通，"他说。"为什么费这么大劲偷了又还回来？为什么像这样？"
		 * * [Suggest something] / [再提出点什么]
		 	"Perhaps the accomplice thought it was Hooper being kept in here. Maybe they saw the guard..." / "也许同谋以为被关在这里的是 Hooper。也许他们看到了卫兵……"
		 	-> all_too_farfetched
		 * * [Suggest nothing] / [不提]
	 * [Suggest nothing] / [不提]
	- 	I shrug, eloquently. / 我意味深长地耸耸肩。
	- 	-> all_too_farfetched


= glad_youre_here
	"Shame," he remarks. "I should have left that window open and put a guard on you. Might have been interesting to see where you went. Anyway, I'm glad you're still here, even if you do smell like a dog." / "可惜，"他评论道。"我应该让那扇窗开着，派个卫兵盯你。看看你去了哪里可能会很有意思。反正，我很高兴你还在这里，即使你闻起来像条狗。"

	* { not framedhooper  }   [Be optimistic] / [乐观]
	 	-> night_falls.morning_not_saved.optimism
	* { not framedhooper  }   [Be pessimistic] / [悲观]
		-> night_falls.morning_not_saved.pessimism

	* { framedhooper  }   [Be optimistic] / [乐观]
	 		"I'm looking forward to having a bath." / "我期待着洗个澡。"
			//  Framed Hooper / 陷害 Hooper
			"Well, you should enjoy it. <> / "好吧，你应该好好享受。<>

	* { framedhooper  }   [Be pessimistic] / [悲观]
	 		"I imagine I'll smell worse after another couple of days of this." / "我想再这样过几天我会更臭。"
			"That won't be necessary. <> / "那不需要了。<>
	- -> found_missing_component


= found_missing_component
	// Framed Hooper / 陷害 Hooper
	We found the missing component. Or rather, Hooper found it for us. He snuck out and retrieved it from on top. Of all the damnest places — you would never have known it was there. He claimed ignorance when we jumped him, of course. But it's good enough for me." / 我们找到了丢失的元件。更准确地说，Hooper 为我们找到的。他偷偷溜出去从顶上取回了它。在所有最该死的地方——你永远不会知道它在那里。当然，我们跳出来抓他时他声称不知情。但这对我来说足够了。"
	 * (devil) [Approve] / [赞同]
			"I can't tell you enough, I'm glad to hear it. I've had a devil of a night." / "我不知道怎么说，很高兴听到这个。我度过了一个糟糕的夜晚。"
			 His gaze flicks to the broken window, but only for a moment. I think he genuinely cannot believe I could have done it. / 他的目光扫过碎窗户，但只是一瞬间。我想他是真心不能相信我能做到。
	 * [Disapprove] / [不赞同]
	 		"You should never have hired him. A below-average intelligence can't be expected to cope with the pressure of our work." / "你根本不应该雇他。一个中下智力的人不能指望承受我们工作的压力。"
 	- 	Harris rolls his eyes, but he might almost be smiling. "You'd better get along, { devil :and work through your devils|Mr Intelligent}. There's a 24—hour—late message to be tackled and we're a genius short. So you'd better be ready to work twice as hard." / Harris 翻了个白眼，但他几乎可能在笑。"你最好赶紧，{ devil :去处理你的恶魔们|聪明先生}。有一份晚了 24 小时的消息要处理，我们还缺一个天才。所以你最好准备好加倍努力。"
 		* 	[Thank him] / [感谢他]
 			"I'll enjoy it. Thank you for helping me clear this up." / "我会享受的。谢谢你帮我澄清这件事。"
			"Don't thank me yet. There's still a war to fight. Now get a move on." / "先别谢我。还有一场仗要打。现在赶紧走吧。"
			I nod, and hurry out of the door. The air outside has never tasted fresher and more invigorating. <> / 我点点头，匆忙走出门。外面的空气从来没有这样清新和令人振奋。<>

 		* 	[Argue with him] / [跟他争辩]
 				"I'll work as hard as I work." / "我会按我的节奏工作。"
				"Get out," Harris growls. "Before I decide to arrest you as an accessory." / "出去，" Harris 咆哮道。"在我决定以从犯逮捕你之前。"
				I do as he says. Outside the barrack, the air has never smelt sweeter. / 我照他说的做了。兵营外面，空气从来没有这么甜美过。
	- -> head_for_my_dorm_free


=== night_falls ===
//  Night falls / 夜幕降临
	Night falls. The clockwork of the heavens keeps turning, whatever state I might be in. No—one can steal the components that make the sun go down and the stars come out. I watch it performing its operations. I can't sleep. / 夜幕降临。天上的发条继续转动，不管我处于什么状态。没有人能偷走让太阳落下、星星出现的零件。我看着它运行操作。我睡不着。
	{ hooperClueType > NONE  :
		Has Hooper taken my bait? / Hooper 上我的钩了吗？
	}
	* 	[Look of out the window] / [看向窗外]
			I peer out of the window, but it looks out onto the little brook at the back of the compound, with no view of the other huts or the House. Who knows if there are men up, searching the base of Hut 2, following one another with flashlights... / 我往窗外窥视，但它只能看到营地后面的小溪，看不到其他小屋或主楼。谁知道是不是有士兵在活动，搜查 2 号小屋的基底，用手电筒互相跟着……
			 {inside_hoopers_hut.back_of_hut_2:
			 	Perhaps Hooper is there, in the dark, trying to help me after all? / 也许 Hooper 在那里，在黑暗中，毕竟想要帮我？
			 }
	* 	[Listen at the door] / [在门边听]
			I put my ear to the keyhole but can make out nothing. Are there still guards posted? { hooperClueType > NONE :Perhaps, if Hooper has managed to incriminate himself, the guards have been removed?|Perhaps the component has been found and the crisis is over.} / 我把耳朵凑到钥匙孔上，但什么也听不出来。还有卫兵站岗吗？{ hooperClueType > NONE :也许，如果 Hooper 成功让自己入罪了，卫兵已经被撤走了？|也许元件被找到了，危机结束了。}
			Perhaps the door is unlocked and they left me to sleep? / 也许门没锁，他们让我睡觉了？
			* * 	[Try it] I try the handle. No such luck. / [试试] 我试了试把手。没那运气。
			* * 	[Leave it] I don't touch it. I don't want anyone outside thinking I'm trying to escape. / [别碰] 我不碰它。我不想让外面的人以为我想逃跑。

	* 	[Wait] / [等待]
			There is nothing I can do to speed up time. / 我无法加快时间。

	- 	The night moves at its own pace. I suppose by morning I will know my fate. / 夜晚以自己的节奏行进。我想到了早上我就会知道我的命运。
 	* 	{ hooperClueType > NONE  }   	[Wait] / [等待]
 		// Hooper now arrested / Hooper 现在被捕了
		Morning comes. I'm woken by a rooster calling from the yard behind the House. I must have slept after all. I pull myself up from the bunk, shivering slightly. There is condensation on the inside of the window. I have probably given myself a chill. / 早晨到来。我被主楼后面院子里的公鸡叫声唤醒。我毕竟还是睡着了。我从铺位上爬起来，微微发抖。窗户内侧有水汽凝结。我可能让自己着凉了。
		Without knocking, Harris comes inside. "You're up," he remarks, and then, "You smell like an animal." / 没有敲门，Harris 走了进来。"你起来了，"他评论道，然后，"你闻起来像动物一样。"
		* * 	[Be friendly] / [友善]
				"I suppose I do rather." I laugh, but Harris does not. / "我想我是有点像。"我笑了，但 Harris 没有。
				"This damn business gets worse and worse," he says, talking as he goes over to unlock and throw open the window. <> / "这桩该死的生意越来越糟，"他说，一边说着一边走过去开锁推开了窗户。<>
		* * 	[Be cold] / [冷淡]
				"So would you," I reply tartly. Harris shrugs. / "你也会的，"我尖刻地回答。Harris 耸耸肩。
				"I've been through worse than this," he replies matter—of—factly. "It's hardly my fault if you sleep in your clothes." / "我经历过比这更糟的，"他实事求是地回答。"你穿着衣服睡觉，这可不是我的错。"
				I glare back. He goes over to the window, unlocks it and throws it open, relishing the fresh air from outside. / 我瞪回去。他走到窗边，开锁推开它，享受着外面的新鲜空气。
		- - 	"Hooper's confessed, you know." / "Hooper 招了，你知道。"
		* * 	[Be eager] / [急切]
				"He has? I knew he would. The worm." / "他招了？我就知道他会。这个蠕虫。"
				"Steady now. Matters aren't over yet. <> / "稳住。事情还没完。<>
		* * 	[Be cautious] / [谨慎]
				"Oh, yes?" / "哦，是吗？"
				"Yes. For what that's worth. <> / "是的。不管这值什么。<>
		- -		(hooper_didnt_give_himself_up) There's still the issue of the component. It hasn't turned up. He didn't lead us to it. I guess he figured you must have had something on him. I don't know." / 还有元件的问题。它还没有出现。他没有把我们引到它那里。我猜他觉得你一定有他的把柄。我不知道。"

				He looks quite put out by the whole affair. He is not the kind of man to deal well with probabilities. / 他对这整件事实在很烦恼。他不是那种善于处理概率问题的人。
 		* * 	[Be interested] / [感兴趣]
 				"You mean he confessed of his own accord? You didn't catch him?" / "你是说他自愿招供了？你们没抓住他？"

 		* * 	[Be disinterested] / [不感兴趣]
 				"Well, I'm glad his conscience finally caught up with him," I reply dismissively. / "好吧，很高兴他的良心终于追上了他，"我轻蔑地回答。
		- - 	"The Captain went back into that hut and he confessed immediately. We were so surprised we didn't let you go." He wrinkles his nose. "I'm rather sorry about that now. I suggest you have a wash." / "上尉回到那个小屋后他立刻就招了。我们太惊讶了，都没放你走。"他皱起鼻子。"我现在对此相当抱歉。我建议你洗个澡。"
				And with that he gestures to the doorway. / 说着他指了指门口。
 			* * 	[Go] / [走]
 			* * 	[Wait] / [等等]
 				I hang back a moment. Something does not seem quite right. After all, Hooper did not steal the component. He has no reason to confess to anything. Perhaps this is another trap? / 我犹豫了一下。有什么似乎不太对。毕竟，Hooper 没有偷元件。他没有理由招认任何事。也许这又是一个陷阱？
				"Well?" Harris asks. "What are you waiting for? Please don't tell me <i>you</i> want to confess now as well, I don't think my head could stand it." / "嗯？" Harris 问道。"你在等什么？请别告诉我<i>你</i>现在也想招供，我想我的脑袋受不住。"
	 				* * * 	[Confess] / [招供]
	 						After a chance like this? A chance — however real — to save my neck? To hand it over — what, to save Hooper's worthless skin? / 在这样一个机会之后？一个机会——无论多真实——来救我的命？把它交出来——什么，为了救 Hooper 那不值钱的皮囊？
 							* * * * [Confess] / [招供]
 									I see. Perhaps you think I bullied the man into giving himself up. Perhaps he understood my little clue far enough to know it was a threat against him, but not well enough to understand where he should look to find it. So he took the easy route out and folded. Gave me the hand. / 我明白了。也许你认为我胁迫了那个人让他自首。也许他把我的小线索理解到知道那是对他的威胁，但没理解到去哪里找它。所以他选了容易的路，投降了。把手牌给了我。
									 ~ hooperConfessed  = true
										Hardly sporting, of course. / 当然，不太公平。
									* * * * * [Confess] / [招供]
												Well, then. I suppose this must be what it feels like to have a conscience. I suppose I had always wondered. / 好吧，那么。我想这一定就是有良心的感觉。我想我一直想知道。
												"Harris, sir. I don't know what Hooper's playing at, sir. But I can't let him do this." / "Harris，长官。我不知道 Hooper 在玩什么把戏，长官。但我不能让他这么做。"
												"Do what?" / "做什么？"
												"Take the rope for this. I took it, sir. / "为这事上绞架。是我拿的，长官。"
												 ~ revealedhooperasculprit = false
												 ~ losttemper = false
												 -> reveal_location_of_component
									* * * * * [Don't confess] / [不招供]
 							* * * * [Don't confess] / [不招供]
	 				* * * 	[Don't confess] / [不招供]
	 				- - - 	"I certainly don't. But still, I'm surprised. I had Hooper down for a full—blown double agent, a traitor. He knows he'll face the rope, doesn't he?" / "我当然不。但话说回来，我很惊讶。我一直认为 Hooper 是个彻头彻尾的双面间谍，一个叛徒。他知道他会面对绞索，不是吗？"
							"Don't ask me to explain why he did what he did," Harris sighs. "Just be grateful that he did, and you're now off the hook." / "别问我解释他为什么做了他所做的，" Harris 叹了口气。"只管感激他做了，你现在脱身了。"
		- - 	Curiouser and curiouser. I nod once to Harris and slip outside into the cold morning air. / 越来越奇怪了。我对 Harris 点了一次头，溜到外面寒冷的早晨空气中。
				 { hooperClueType == NONE  :
					Hooper's confession only makes sense in one fashion{ hooperConfessed :, and that is his being dim—witted and slow| — if I successfully implied to him that I had him framed, but he did not unpack my little clue well enough to go looking for the component. Well, I had figured him for a more intelligent opponent, but a resignation from the game will suffice}. Or perhaps he knew he would be followed if he went to check, and decided he would be doomed either way. / Hooper 的招供只以一种方式说得通{ hooperConfessed :，即他是迟钝和缓慢的|——如果我成功地对他暗示我陷害了他，但他没有充分解读我的小线索去搜寻元件。好吧，我本以为他是个更聪明的对手，但从牌局中认输也够了}。或者也许他知道如果他去检查会被跟踪，认为无论如何都是注定失败的。
				- else:
					Hooper's confession only makes sense in one way — and that's that he believed me. He reasoned that he would be followed. To try and uncover the component would have got him arrested, and to confess was the same. / Hooper 的招供只以一种方式说得通——那就是他相信了我。他推断自己会被跟踪。试图找出元件会让他被捕，而招供也是同样的结果。
					He simply caved, and threw in his hand. / 他只是屈服了，扔出了手牌。
				}
				// Outside, possibly free / 在外面，可能自由了
				Of course, however, there is only one way to be certain that Harris is telling the truth, and that is to check the breeze—block at the back of Hut 2. / 当然，然而，只有一种办法可以确定 Harris 说的是真话，那就是去检查 2 号小屋后面的煤渣砖。
			* * [Check] -> go_to_where_component_is_hidden / [检查] -> go_to_where_component_is_hidden
			* * [Don't check] / [不检查]
					But there will time for that later. If there is nothing there, then Hooper discovered the component after all and Harris' men will have swooped on him, and the story about his confession is just a ruse to test me out. / 但以后还有时间。如果那里什么也没有，那么 Hooper 毕竟发现了元件，Harris 的人已经扑向了他，关于他招供的说法只是一个试探我的伎俩。
					And if the component is still there — well. It will be just as valuable to my contact in a week's time, and his deadline of the 31st is not yet upon us. / 如果元件还在那里——好吧。一周后它对我的联系人来说同样有价值，而他 31 日的截止日期还没到。
					 -> head_for_my_dorm_free

 	* 	{ hooperClueType == NONE  }   	[Wait] -> morning_not_saved / [等待] -> morning_not_saved

= morning_not_saved
	// Not saved / 没救成
	Morning comes with the call of a rooster from the yard of the House. I must have slept after all. I pull myself up off the bunk, shivering slightly. There is condensation on the inside of the window. I have probably given myself a chill. / 早晨随着主楼院子里公鸡的叫声到来。我毕竟还是睡着了。我从铺位上爬起来，微微发抖。窗户内侧有水汽凝结。我可能让自己着凉了。
	It's not long after that Harris enters the hut. He closes the door behind him, careful as ever, then takes a chair across from me. / 不久后 Harris 进入小屋。他像往常一样小心地关上门，然后在我对面拉了把椅子坐下。
	"You smell like a dog," he remarks. / "你闻起来像条狗，"他评论道。
	* 	(optimism) [Be optimistic] / [乐观]
	 	"I'm looking forward to a long bath," I reply. "And getting back to work." / "我期待着洗个长澡，"我回答。"然后回去工作。"
	* 	(pessimism) [Be pessimistic] / [悲观]
	 	"So would you after the night I've had." / "你要是经历了我昨晚也会的。"

	- 	-> harris_certain_is_you


=== harris_certain_is_you
	"Well, I'm afraid it is going to get worse for you," Harris replies soberly. "We followed Hooper, and he took himself neatly to bed and slept like a boy scout. Which puts us back to square one, and you firmly in the frame. And I'm afraid I don't have time for any more games. I want you to tell me where that component is, or we will hang you as a traitor." / "好吧，恐怕对你来说会更糟，" Harris 严肃地回答。"我们跟踪了 Hooper，他老老实实上床睡觉了，像个童子军一样。这让我们回到了原点，你稳稳地在嫌疑框里。而且恐怕我没有时间再玩任何把戏了。我要你告诉我那个元件在哪里，否则我们会把你当作叛徒绞死。"
	 ~ revealedhooperasculprit = false
	 ~ losttemper = false
	 -> harris_threatens_lynching



=== head_for_my_dorm_free
I head for my dorm, intent on a bath, breakfast, a glance at the crossword before the other men get to it, and then on with work. They should have replaced the component in the Bombe by now. We will only be a day behind. / 我朝我的宿舍走去，打算洗个澡、吃个早饭、在其他人拿到之前看一眼填字游戏，然后继续工作。他们现在应该已经把元件装回 Bombe 了。我们只会落后一天。
 { not framedhooper  :
	And then everything will proceed as before. The component will mean nothing to the Germans — this is the one fact I could never have explained to a man like Harris, even though the principle behind the Bombe is the same as the principle behind the army. The individual pieces — the men, the components — do not matter. They are identical. It is how they are arranged that counts. / 然后一切会像以前一样继续。这个元件对德国人来说毫无意义——这是我永远无法向 Harris 这样的人解释的一个事实，尽管 Bombe 背后的原理和军队背后的原理是一样的。单个零件——士兵、元件——并不重要。它们是相同的。重要的是它们如何排列。
}
I bump into Russell in the dorm hut. / 我在宿舍小屋碰到了 Russell。
"Did you hear?" he whispers. "Terrible news about Hooper. Absolutely terrible." / "你听说了吗？"他低声说。"关于 Hooper 的可怕消息。绝对可怕。"
 * [Yes] / [听说了]
 	"Quite terrible. I would never have guessed." / "非常可怕。我绝不会猜到。"
	"Well." Russell harrumphs. / "嗯。" Russell 哼了一声。
	- - (quince) "Quince was saying this morning, apparently his grandfather was German. So perhaps it's to be expected. See you there?" / "Quince 今早说，显然他的祖父是德国人。所以也许这在意料之中。那边见？"

 * [No] / [没有]
	"Heard what?" / "听说什么？"
 	- - (hooper_taken) "Hooper's been taken away. They caught him, uncovering that missing Bombe component from a hiding place somewhere, apparently about to take it to his contact." Russell harrumphs. -> quince / "Hooper 被带走了。他们抓到他了，正在从某个藏匿处挖出那个丢失的 Bombe 元件，显然正要带去找他的联系人。" Russell 哼了一声。-> quince
 * [Lie] / [撒谎]
 	"I don't know what you're talking about." / "我不知道你在说什么。"
 	-> hooper_taken
 * [Evade] / [回避]
		"If you'll excuse me, Russell. I was about to take a bath." / "如果你不介意的话，Russell。我正要去洗澡。"
		"Oh, of course. Worked all night, did you? Well, you'll hear soon enough. Can hardly hide the fact there'll only be three of us from now on." / "哦，当然。工作了一整夜，是吗？好吧，你很快就会听到的。难以掩盖从今往后只有我们三个人的事实。"

- I wave to him and move away, my thoughts turning to the young man in the village. My lover. My contact. My blackmailer. Hooper may have taken the fall for the missing component, but { not framedhooper :if he did recover it from Hut 2 then | its recovery does mean }I have nothing to sell to save my reputation{ i_met_a_young_man :, if I have any left}. / 我朝他挥挥手走开了，思绪转向了村里的那个年轻男人。我的爱人。我的联系人。我的敲诈者。Hooper 可能为丢失的元件背了锅，但{ not framedhooper :如果他确实从 2 号小屋取回了它，那么|它的找回确实意味着}我没有任何东西可以卖来挽救我的声誉{ i_met_a_young_man :，如果我还剩下任何声誉的话}。
 { not framedhooper  :
If he didn't, of course, and Harris was telling the truth about his sudden confession, then I will be able to buy my freedom once and for all. / 如果他没有，当然，而且 Harris 说的他突然招供是实话，那么我就能一劳永逸地买到我的自由。
}
 * { not framedhooper  }   [Get the component] -> go_to_where_component_is_hidden / [去拿元件] -> go_to_where_component_is_hidden
 * { not framedhooper  }   [Leave it] / [别管了]
 	I will have to leave that question for another day. To return there now, when they're probably watching my every step, would be suicide. After all, if Hooper { hooperClueType == STRAIGHT :followed|understood} my clue, he will have explained it to them to save his neck. They won't believe him — but they won't quite disbelieve him either. We're locked in a cycle now, him and me, of half—truth and probability. There's nothing either of us can do to put the other entirely into blame. / 我只能把那问题留到改天。现在回去那里，当他们可能在监视我的每一步时，那是自杀。毕竟，如果 Hooper { hooperClueType == STRAIGHT :沿着|理解了}我的线索，他会为了救自己的命而向他们解释。他们不会相信他——但他们也不会完全不相信他。我们现在陷入了一个循环，他和我，半真半假和概率的循环。我们谁都做不了任何事来把对方完全归咎。
 	-> ending_return_to_normal
 * [Act normal] / [照常行事]
 	But there is nothing to be done about it. -> ending_return_to_normal / 但对此无能为力。-> ending_return_to_normal



=== ending_return_to_normal
Nothing, that is, except to act as if there is no game being played. I'll have a bath, then start work as normal. I've got a week to find something to give my blackmailer{ i_met_a_young_man : — or give him nothing: it seems my superiors know about my indiscretions now already}. / 没什么，也就是说，除了表现得好像没有游戏在进行中。我会洗个澡，然后开始正常工作。我有一周时间找东西给我的敲诈者{ i_met_a_young_man : ——或者什么都不给他：看来我的上级现在已经知道我的不检点行为了}。
 * [Co-operate] / [合作]
 	Something will turn up. It always does. An opportunity will present itself, and more easily now that Hooper is out of the way. / 会有东西出现的。总会有。机会会出现，而且现在 Hooper 不在了，更容易了。
	But for now, there's yesterday's intercept to be resolved. / 但现在，有昨天的密文要破解。

 * [Dissemble] / [掩饰]
 	Or perhaps I might hand my young blackmailer over my superiors instead for being the spy he is. / 或者也许我可以把我的年轻敲诈者交给我的上级，因为他就是间谍。
	Perhaps that would be the moral thing to do, even, and not just the most smart. / 也许那甚至是道德上该做的事，而不仅仅是最聪明的做法。
	But not today. Today, there's an intercept to resolve. / 但不是今天。今天，有一份密文要破解。

 * [Lie] / [撒谎]
 	In a week's time, this whole affair will be in the past and quite forgotten. I'm quite sure of that. -> moreimportant / 一周之后，这整件事就会成为过去，完全被遗忘。我对此非常确定。-> moreimportant
 * (moreimportant) [Evade] I've more important problems to think about now. There's still yesterday's intercept to be resolved. / [回避] 我现在有更重要的问题要考虑。还有昨天的密文要破解。
-  The Bombe needs to be set up once more and set running. / Bombe 需要重新设置并启动。
It's time I tackled a problem I can solve. / 是时候解决一个我能解决的问题了。
//  End - Scot Free / 结局——逍遥法外
-> END


=== go_to_where_component_is_hidden
	It won't take a moment to settle the matter. I can justify a walk past Hut 2 as part of my morning stroll. It will be obvious in a moment if the component is still there. / 解决这件事用不了一会儿。我可以把走过 2 号小屋辩解为我早晨散步的一部分。如果元件还在那里，马上就会很明显。
	On my way across the paddocks, between the huts and the House, I catch sight of young Miss Lyon, arriving for work on her bicycle. She giggles as she sees me and waves. / 在穿过围场、经过小屋和主楼之间的路上，我看到年轻的 Lyon 小姐骑自行车来上班。她看到我时咯咯笑着挥手。
 	* 	[Wave back] / [挥手回应]
	 		I wave cheerily back and she giggles, almost drops her bicycle, then dashes away inside the House. Judging by the clock on the front gable, she's running a little late this morning. / 我愉快地挥手回应，她咯咯笑着，差点掉了自行车，然后冲进了主楼。从前面山墙上的钟来看，她今早有点迟到了。
 	* 	[Ignore her] / [不理她]
 			I give no reaction. She sighs to herself, as if this kind of behaviour is normal, and trots away inside the House to begin her duties. / 我不做任何反应。她自己叹了口气，好像这种行为很正常，然后快步走进主楼开始她的职责。
	- 	I turn the corner of Hut 3 and walk down the short gravel path to Hut 2. It was a good spot to choose — Hut 2 is where the electricians work, and they're generally focussed on what they're doing. They don't often come outside to smoke a cigarette so it's easy to slip past the doorway unnoticed. / 我转过 3 号小屋的拐角，沿着短碎石路走到 2 号小屋。这是个选得不错的地方——2 号小屋是电工工作的地方，他们通常专注于手中工作。他们不常出来抽烟，所以很容易不被注意地溜过门口。
 	* 	[Check inside] / [查看里面]
 			I hop up the steps and put my head inside all the same. Nobody about. Still too early in the AM for sparks, I suppose. <> / 我还是跳上台阶把头探进去看了看。没人在。我想对电工来说上午还是太早了。<>
 	* 	[Go around the back] / [绕到后面]

	- 	I head on around the back of the hut. The breeze—block with the cavity is on the left side. / 我继续绕到小屋后面。有空洞的煤渣砖在左侧。
 	* 	(check) [Check] / [检查]
 			No time to waste. I drop to my knees and check the breeze—block. Sure enough, there's nothing there. <i>Hooper took the bait.</i> / 没时间浪费了。我跪下来检查煤渣砖。果然，那里什么也没有。<i>Hooper 上钩了。</i>
			Suddenly, there's a movement behind me. I look up to see, first a snub pistol, and then, Harris. / 突然，我身后有动静。我抬头看到，先是一把短管手枪，然后是 Harris。

 	* 	[Look around] / [环顾]
 			I pause to glance around, and catch a glimpse of movement. Someone ducking around the corner of the hut. Or a canvas sheet flapping in the light breeze. Impossible to be sure. / 我停下来环顾，瞥见一个动静。有人在小屋拐角处躲闪。或者是轻风中飘动的油布。不可能确定。
  			* * 	[Check the breeze—block] -> check / [检查煤渣砖] -> check
 			* * 	[Check around the side of the hut] / [检查小屋侧面]
 						But too important to guess. I move back around the side of the hut. / 但太重要了，不能猜测。我绕回小屋侧面。
						Harris is there, leaning in against the wall. He holds a stub pistol in his hand. / Harris 在那里，靠在墙上。他手里握着一把短管手枪。

	- 	{ hooperClueType > STRAIGHT  :
			"{ hooperClueType == CHESS:Queen to rook two|Messy without one missing whatever it was}," he declares. "I wouldn't have fathomed it but Hooper did. Explained it right after we sprung him doing what you're doing now. We weren't sure what to believe but now, you seem to have resolved that for us." / "{ hooperClueType == CHESS:后到车二|Messy without one missing 不管那是什么}，"他宣布。"我自己不会参透，但 Hooper 参透了。就在我们逮到他做你现在做的事之后，他解释了。我们不确定该相信什么，但现在，你似乎为我们解决了那个问题。"
		- else:
			"Hooper said you'd told him where to look. I didn't believe him. Or, well. I wasn't sure what to believe. Now I rather think you've settled it." / "Hooper 说你告诉他去哪里找了。我不相信他。或者说，好吧。我不确定该相信什么。现在我倒觉得你已经解决了。"
		}
	 * 	[Agree] / [同意]
		 	"I have, rather." I put my hands into my pockets. "I seem to have done exactly that." / "我倒是解决了。"我把手放进口袋。"我似乎正是这么做的。"
			"I'm afraid my little story about Hooper confessing wasn't true. I wanted to see if you'd go to retrieve the part." Harris gestures me to start walking. "You were close, Manning, I'll give you that. I wanted to believe you. But I'm glad I didn't." / "恐怕我说的 Hooper 招供的小故事不是真的。我想看看你是否会去取那个零件。" Harris 示意我开始走。"你很接近了，Manning，我承认。我想相信你。但我很高兴我没有。"
			-> done
	 * 	[Lie] / [撒谎]
		 	"I spoke to Russell. He said he saw Hooper doing something round here. I wanted to see what it was." / "我和 Russell 谈过了。他说他看到 Hooper 在这附近做些什么。我想看看到底是什么。"

	 * 	[Evade] / [回避]
		 	"Harris, you'd better watch out. He's planted a time—bomb here." / "Harris，你最好小心点。他在这里埋了定时炸弹。"
			Harris stares at me for a moment, then laughs. "Oh, goodness. That's rich." / Harris 盯着我看了片刻，然后笑了。"哦，天哪。太可笑了。"
			I almost wish I had a way to make the hut explode, but of course I don't. / 我几乎希望我有办法让小屋爆炸，但我当然没有。

	- 	"Enough." Harris gestures for me to start walking. "This story couldn't be simpler. You took it to cover your back. You hid it. You lied to get Hooper into trouble, and when you thought you'd won, you came to scoop your prize. A good hand but ultimately, { hooperClueType <= STRAIGHT  :if it hadn't have been you who hid the component, then you wouldn't be here now|you told Hooper where to look with your little riddle}." / "够了。" Harris 示意我开始走。"这个故事不能更简单了。你拿了它来自保。你藏了它。你撒谎让 Hooper 陷入麻烦，当你以为你赢了，你来取走你的奖品。好一手牌，但最终，{ hooperClueType <= STRAIGHT  :如果不是你藏了元件，那么你现在就不会在这里|你用你的小谜语告诉了 Hooper 去哪里找}。"

 	- (done)
	//   End - Caught in AM / 结局——早上被抓
		He leads me across the yard. Back towards Hut 5 to be decoded, and taken to pieces, once again. / 他领着我穿过院子。走回 5 号小屋，再次被解码、被拆解。
		-> END



=== harris_threatens_lynching
 	{ harris_certain_is_you:He passes a hand across his eyes with a long look of despair.|He gets to his feet, and gathers his gloves from the table top.} / { harris_certain_is_you:他用手擦过眼睛，带着长久的绝望神情。|他站起来，从桌面上拿起他的手套。}
	"I'm going to go outside and organise a rope. That'll take about twelve minutes. That's how long you have to decide." / "我要出去弄条绳子。大概需要十二分钟。那就是你必须做决定的时间。"
	 * [Protest] / [抗议]
	 	"You can't do this!" I cry. "It's murder! I demand a trial, a lawyer; for God's sake, man, you can't just throw me overboard, we're not barbarians...!" / "你不能这么做！"我喊道。"这是谋杀！我要求审判、律师；看在上帝份上，老兄，你不能就这样把我扔下船，我们不是野蛮人……！"
		- - (too_clever) "You leave me no choice," Harris snaps back, eyes cold as gun—metal. "You and your damn cyphers. Your damn clever problems. If men like you didn't exist, if we could just all be <i>straight</i> with one another." He gets to his feet and heads for the door. "I fear for the future of this world, with men like you in. Reich or no Reich, Mr Manning, people like you simply <i>complicate</i> matters." / "你让我别无选择，" Harris 厉声回答，眼神像枪管一样冰冷。"你和你那该死的密码。你那该死的聪明问题。如果像你这样的人不存在，如果我们都能彼此<i>坦诚相待</i>。"他站起来朝门口走去。"我为这个世界的未来感到担忧，有像你这样的人在。不管有没有帝国，Manning 先生，像你这样的人只会把事情<i>复杂化</i>。"
		 -> left_alone
	 * { not gotcomponent   && not throwncomponentaway  }   [Confess] / [招供]
	 		I nod. "I don't need twelve minutes. -> reveal_location_of_component / 我点点头。"我不需要十二分钟。-> reveal_location_of_component
	 * [Stay silent] -> my_lips_are_sealed / [保持沉默] -> my_lips_are_sealed
	 * { gotcomponent  }   			[Show him the component] / [给他看元件]
	 		"I don't need twelve minutes. Here it is." / "我不需要十二分钟。在这里。"
			I open my jacket and pull the Bombe component out of my pocket. Harris takes it from me, whistling, curious. / 我打开外套，从口袋里掏出 Bombe 元件。Harris 从我手中接过，吹着口哨，好奇地。
			"Well, I'll be. That's it all right." / "好吧，真是。就是它没错。"
			"That's it." / "就是它。"
			"But you didn't have it on you yesterday." / "但你昨天没有带着它。"
			* * [Explain] / [解释]
			 	"I climbed out of the window overnight," I explain. "I went and got this from where it was hidden, and brought it back here." / "我夜里从窗户爬出去，"我解释道。"我去从它藏着的地方拿到了这个，把它带回了这里。"
			* * [Don't explain] / [不解释]
				"No. I didn't." / "是的。我没有。"
			- -> all_too_farfetched

	 * { throwncomponentaway  }   	[Confess] / [招供]
		 	"I don't need twelve minutes. The component is in the long grass behind Hooper's tent. I threw it there hoping to somehow frame him, but now I see that won't be possible. I was naive, I suppose." / "我不需要十二分钟。元件在 Hooper 帐篷后面的长草丛里。我把它扔在那里希望能以某种方式陷害他，但现在我明白那不可能了。我想我是太天真了。"
			 ~ piecereturned  = true
			 -> reveal_location_of_component.harris_believes

	 * { throwncomponentaway  }   [Frame Hooper] / [陷害 Hooper]
		 	"Look, I know where it is. The missing piece of the Bombe is in the long grasses behind Hooper's tent. I saw him throw it there right after we finished work. He knew you'd scour the camp but I suppose he thought you'd more obvious places first. I suppose he was right about that. Look there. That <i>proves</i> his guilt." / "听着，我知道它在哪里。Bombe 丢失的零件在 Hooper 帐篷后面的长草丛里。我看到他工作结束后立刻把它扔在了那里。他知道你会搜遍营地，但我想他以为你会先搜更明显的地方。我想他对此是对的。在那里找找。那<i>证明</i>了他的罪行。"
			 ~ longgrasshooperframe  = true
			 ~ piecereturned  = true
			"That doesn't prove anything," Harris returns sharply. "But we'll check what you say, all the same." He gets to his feet and heads out of the door. / "那证明不了什么，" Harris 尖锐地回应。"但我们会查你说的，不管怎样。"他站起来，走出门去。
			 -> left_alone



=== reveal_location_of_component
	<> The missing component of the Bombe computer is hidden in a small cavity in a breeze—block supporting the left rear post of Hut 2. I put in there anticipating a search. I intended to { revealedhooperasculprit:pass it to Hooper|dispose of it} once the fuss had died down. I suppose I was foolish to think that it might." / <> Bombe 计算机丢失的元件藏在支撑 2 号小屋左后柱的煤渣砖的一个小空腔里。我把它放在那里是预料到会有搜查。我打算在风波平息后{ revealedhooperasculprit:把它交给 Hooper|处理掉它}。我想我居然以为可能做到，真是太愚蠢了。"
	~ piecereturned  = true
	-> harris_believes
= harris_believes
 	{ not night_falls.hooper_didnt_give_himself_up  :
		"Indeed. And Mr Manning: God help you if you're lying to me." / "确实。还有 Manning 先生：如果你对我撒谎，上帝保佑你。"
	- else:
		"I thought as much. I hadn't expected you to give it out so easily, however. You understand, Hooper has said nothing, of course. In fact, he went to Hut 2 directly after we released him and uncovered the component. But he told us you had instructed him where to go. Hence my little double bluff. Frankly, I'll be glad when I'm shot of the lot of you mathematicians." / "我也这么想。不过，我没想到你会这么容易地说出来。你知道，Hooper 当然什么也没说。事实上，我们放他走后他直接去了 2 号小屋，取出了元件。但他告诉我们是你指示他去那里的。因此我搞了个小双诈。坦白说，等我摆脱你们这群数学家，我会很高兴的。"
	}
	Harris stands, and slips away smartly. -> left_alone / Harris 站起来，利落地溜走了。-> left_alone



=== my_lips_are_sealed
	I say nothing, my lips tightly, firmly sealed. It's true I am a traitor, to the very laws of nature. The world has taught me that since a very early age. But not to my country — should the Reich win this war, I would hardly be treated as an honoured hero. I was doomed from the very start. / 我什么也不说，双唇紧闭封得牢牢的。的确，我是一个叛徒，对自然的法则而言。世界从我很小的时候就教会了我这一点。但对我国家而言不是——如果帝国赢得这场战争，我几乎不会被当作荣誉英雄对待。我从一开始就注定失败。
	 ~ notraitor  = true
	I explain none of this. How could a man like Harris understand? / 这些我都不解释。像 Harris 这样的人怎么能理解？
	The Commander takes one look back from the doorway as he pulls it to. / 指挥官在拉上门时从门口回头看了一眼。
	"It's been a pleasure working with you, Mr Manning," he declares. "You've done a great service to this country. If we come through, I'm sure they'll remember you name. I'm sorry it had to end this way and I'll do my best to keep it quiet. No—one need know what you did." / "和你共事很愉快，Manning 先生，"他宣布。"你为这个国家做出了巨大贡献。如果我们挺过来了，我相信他们会记住你的名字。很抱歉必须这样结束，我会尽力保密。没有人需要知道你所做的事。"
	 -> left_alone



=== all_too_farfetched
	//  Returned Component / 元件被归还
	"This is all too far—fetched," Harris says. "I'm glad to have this back, but I need to think." / "这一切都太牵强了，" Harris 说。"我很高兴拿回了这个，但我需要思考。"
	Getting to his feet, he nods once. "You'll have to wait a little longer, I'm afraid, Manning." / 站起来，他点了一次头。"恐怕你得多等一会儿了，Manning。"
	Then he steps out of the door, muttering to himself. / 然后他走出门，自言自语着。
	 -> make_your_peace



=== left_alone
	//  Alone, about to die / 孤独，即将死去
	{ slam_door_shut_and_gone.time_to_move_now :The Commander holds the door for his superior, and follows him out.} Then the door closes. I am alone again, as I have been for most of my short life. / { slam_door_shut_and_gone.time_to_move_now :指挥官为他的上级扶门，跟着他出去了。} 然后门关上了。我再次孤独一人，就像我短暂生命中大部分时间一样。
	 -> make_your_peace


=== make_your_peace
	* [Make your peace] / [做好心理准备]
	-	I am waiting again. I have no God to make my peace with. I find it difficult to believe in goodness of any kind, in a world such as this. / 我再次等待。我没有上帝可以与之和解。在这样的世界里，我发现很难相信任何种类的善。
 		{ not notraitor:
 			~ notraitor  = true
			But I am no traitor. Not to my country. To my sex, perhaps. But how could I support the Reich? If the Nazis were to come to power, I would be worse off than ever. / 但我不是叛徒。不是对我国家而言。对我的性别而言，也许是。但我怎么能支持帝国？如果纳粹上台，我比以往任何时候都更糟。
		}
 		{ harris_threatens_lynching.too_clever:
			In truth, it is men like Harris who are complex, not men like me. I live to make things ordered, systematic. I like my pencils sharpened and lined up in a row. I do not deal in difficult borders, or uncertainties, or alliances. If I could, I would reduce the world to something easier to understand, something finite. / 事实上，是像 Harris 这样的人复杂，而不是像我这样的人。我活着是为了让事物有序、系统化。我喜欢铅笔削尖、排成一排。我不处理困难的边界、不确定性或联盟。如果我可以，我会把世界简化为更容易理解的东西，某种有限的东西。
			But I cannot, not even here, in our little haven from the horrors of the war. / 但我不能，即使在这里，在我们躲避战争恐怖的小避风港里也不能。
		}
		I have no place here. No way to fit. I am caught, in the middle, cryptic and understood only thinly, through my machines. / 我在这里没有位置。没有办法融入。我被困在中间，难以理解，只能通过我的机器被薄薄地理解。
 			* 	I must seem very calm. / 我一定看起来很平静。
 			* 	Perhaps I should try to escape.[] But escape to where? I am already a prisoner. Jail would be a blessing. -> monastic / 也许我该试着逃跑。[] 但逃到哪里？我本来就是个囚犯。监狱会是种福气。-> monastic
	- 	<> I suppose I do not believe they will hang me. They will lock me up and continue to use my brain, if they can. I wonder what they will tell the world — perhaps that I have taken my own life. That would be simplest. The few who know me would believe it. / <> 我想我不相信他们会绞死我。他们会把我关起来，继续用我的脑子，如果他们能做到的话。我不知道他们会怎样告诉世人——也许说我自杀了。那将是最简单的。认识我的那几个人会相信。
		Well, then. Not a bad existence, in prison. Removed from temptation. / 那么好吧。在监狱里，不算太坏的存在。远离诱惑。
	-	(monastic) A monastic life, with plenty of problems to keep me going. / 一种修道院式的生活，有足够多的问题让我继续下去。
		I wonder what else I might yet unravel before I'm done? / 我想知道在我结束之前，还有什么我可能尚未解开的？
 			* The door is opening.[] Harris is returning. Our little calculation here is complete. { not piecereturned: I can only hope one of the others will be able to explain to him that the part I stole will mean nothing to the Germans.|We are just pieces in this machine; interchangeable and prone to wear.} / 门开了。[] Harris 回来了。我们的小计算完成了。{ not piecereturned: 我只能期望其他人能向他解释，我偷的那个零件对德国人来说毫无意义。|我们只是这台机器中的零件；可互换且易于磨损。}
	- 	That is the true secret of the calculating engine, and the source of its power. It is not the components that matter, they are quite repetitive. What matters is how they are wired; the diversity of the patterns and structures they can form. Much like people — it is how they connect that determines our victories and tragedies, and not their genius. / 这就是计算机的真正秘密，也是其力量的来源。重要的不是元件，它们相当重复。重要的是它们如何接线；它们能形成的模式和结构的多样性。就像人一样——决定我们胜利与悲剧的是他们如何连接，而不是他们的天才。
		Which makes me wonder. Should I give { i_met_a_young_man :up my beautiful young man|the young man who put me in this spot} to them as well as myself? / 这让我想。我是不是应该把{ i_met_a_young_man :我美丽的年轻男人|把我置于此地的那个年轻男人}和我自己一起交出去？
		 * 	[Yes] / [是的]
		 		But of course I will. { forceful > 2:Perhaps I can persuade them to put him in my cell.|A little vengeance, disguised as doing something good.} / 但我当然会的。{ forceful > 2:也许我能说服他们把他关进我的牢房。|一点小小的复仇，伪装成做一件好事。}
		 * 	[No] / [不]
		 		No. What would be the use? He will be long gone, and the name he told me is no doubt hokum. No: I was alone before in guilt, and I am thus alone again. / 不。有什么用呢？他早就远走高飞了，他告诉我的名字无疑是假的。不：我从前在罪责中是孤独的，因此我再次孤独。
		 * 	[Lie] / [撒谎]
		 		No. Why would I? He is no doubt an innocent himself, trapped by some dire circumstance. Forced to act the way he did. I have every sympathy for him. / 不。我为什么要？他本人无疑也是无辜的，被某种可怕的境况所困。被迫那样行事。我对他充满同情。
				Of course I do. / 我当然有。
		 * 	[Evade] / [回避]
		 		It depends, perhaps, on what his name his worth. If it were to prove valuable, well; perhaps I can concoct a few more such lovers with which to ease my later days. / 这也许取决于他的名字值什么。如果它能证明是有价值的，好吧；也许我可以编造更多这样的情人来宽慰我的余生。
				{ hooper_mentioned: Hooper, perhaps. He wouldn't like that. } / { hooper_mentioned: Hooper，也许。他不会喜欢。}
	- 	{ not longgrasshooperframe  :
			Harris put the cuffs around my wrists. "I still have the intercept in my pocket," I remark. "Wherever we're going, could I have a pencil?" / Harris 把手铐铐在我手腕上。"我口袋里还有那份密文，"我说道。"不管我们去哪里，能给我一支铅笔吗？"
		- else:
			"We recovered the part, just where you said it was," Harris reports, as he puts the cuffs around my wrists. "Of course, a couple of the men swear blind they searched there yesterday, so I'm afraid, what with the broken window... we've formed a perfectly good theory which doesn't bode well for you." / "我们找回了零件，就在你说的地方，" Harris 报告着，把手铐铐在我手腕上。"当然，有几个人发誓他们昨天在那里搜过，所以恐怕，加上碎窗……我们已经形成了一个完美的理论，对你来说不是好兆头。"
		}
	 	~ piecereturned  = true
		{ longgrasshooperframe  :
		"I see." It doesn't seem worth arguing any further. "I still have the intercept in my pocket," I remark. "Wherever we're going, could I have a pencil?" / "我明白了。"似乎不值得再争辩了。"我口袋里还有那份密文，"我说道。"不管我们去哪里，能给我一支铅笔吗？"
		}
		He looks me in the eye. / 他直视着我的眼睛。
		{ not losttemper  :
			"Of course. And one of your computing things, if I get my way. And when we're old, and smoking pipes together in The Rag like heroes, I'll explain to you the way that decent men have affairs. / "当然。还有你的一台计算设备，如果我能如愿的话。等我们老了，在 The Rag 一起像英雄一样抽着烟斗，我会向你解释正直的男人如何处理私情。"
		- else:
			"I'll give you a stone to chisel notches in the wall. And that's all the calculations you'll be doing. And as you sit there, pissing into a bucket and growing a beard down to your toes, you have a think about how a <i>smart</i> man would conduct his illicit affairs. With a bit of due decorum you could have learnt off any squaddie. / "我会给你一块石头，让你在墙上凿刻痕。这就是你将要做的所有计算。当你坐在那里，往桶里撒尿，胡子长到脚趾，你好好想想一个<i>聪明</i>人该如何处理他的不伦私情。稍微体面点，这你从任何士兵那里都能学到。"
		}
		<> You scientists." / <> 你们科学家。"
		He drags me up to my feet. / 他把我拖起来站起来。
		"You think you have to re—invent everything." / "你觉得你得重新发明一切。"
		With that, he hustles me out of the door and I can't help thinking that, with a little more strategy, I could still have won the day. But too late now, of course. / 说着，他把我推出门，我忍不住想，再多一点谋略，我仍然可以赢得那一天。但现在当然太晚了。
		-> END
