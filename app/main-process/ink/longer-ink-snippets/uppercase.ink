/*
	Converts text to uppercase. Doesn't have an inky fallback.
	/ 将文本转换为大写。没有纯 ink 的回退方案。

	Usage: / 用法：

	"Give me wine. {UPPERCASE("Give me wine!")}
	/ "给我酒。{UPPERCASE("给我酒！")}

	Required C# code: / 需要的 C# 代码：

	The external binding is as follows. / 外部绑定如下。

		story.BindExternalFunction("UPPERCASE", (string txt) =>
	    {
	        return txt.ToUpper();
	    });

*/

EXTERNAL UPPERCASE(txt)
=== function UPPERCASE(txt)
    {txt}
