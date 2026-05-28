/*
    Prints the correct form of the indefinite article before a noun. / 输出名词前不定冠词的正确形式。

    Usage:  / 用法：

    VAR firstAnimal = "cat"
    VAR secondAnimal = "elephant"
    VAR thirdAnimal = "elongated badger"
    I put {a(firstAnimal)} and {a(secondAnimal)} into {a("{~old|nice} box")} with {a(thirdAnimal)}. / 我把{a(firstAnimal)}和{a(secondAnimal)}连同{a(thirdAnimal)}一起放进了{a("{~old|nice} box")}。



*/


=== function a(x)
    ~ temp stringWithStartMarker = "^" + x
    { stringWithStartMarker ? "^a" or stringWithStartMarker ? "^A" or stringWithStartMarker ? "^e" or  stringWithStartMarker ? "^E"  or stringWithStartMarker ? "^i" or stringWithStartMarker ? "^I"  or stringWithStartMarker ? "^o" or stringWithStartMarker ? "^O" or stringWithStartMarker ? "^u"  or stringWithStartMarker ? "^U"  :
            an {x}

    // this could be extended to check for "^hi" if you wanted "an historic..." / 可扩展为检查 "^hi" 以支持 "an historic..."
    - else:
        a {x}
    }
