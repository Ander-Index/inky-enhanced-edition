/*
	Determines the type of a generic ink variable. By @IFcoltransG on the inkle discord.
	/ 确定通用 ink 变量的类型。作者：inkle Discord 上的 @IFcoltransG。


	Usage: / 用法：

	VAR x = "Hello!" / "你好！"
	VAR y = 14
	LIST z = (Hat), (Coat)

	{type_of(x) == Number:
		This is a number, so it's safe to divide it by 2. / 这是一个数字，所以可以安全地除以 2。
		{x / 2}
	}


*/


LIST Type = List, String, Number, Bool
=== function type_of(val)
    {"{val + val}":
        - "{val}{val}":
            {val ? val:
                ~ return String
            - else:
                ~ return List // empty / 空
            }

        - "{val}":
            { "{val}" == "0":
                ~ return Number // zero / 零
            - else:
                ~ return List
            }

        - else:
            {"{not not val}" == "{val}":
                ~ return Bool
            }
            ~ return Number
    }
