const $ = window.jQuery = require('./jquery-2.2.3.min.js');
const i18n = require('./i18n.js');

var events = {};
var lastFadeTime = 0;
var $textBuffer = null;
var instructionPrefix = null;
var animationEnabled = true;
var $lastTextParagraph = null;
var $previousTextParagraph = null;

var textParagraphs = [];
var tagQueue = [];
var processingTagQueue = false;

document.addEventListener("keyup", function(){
    $("#player").removeClass("altKey");
});
document.addEventListener("keydown", function(){
    $("#player").addClass("altKey");
});

// Initial default: append to visible buffer
$textBuffer = $("#player .innerText.active");

function shouldAnimate() {
    return $textBuffer.hasClass("active");
}

function showSessionView(sessionId) {
    var $player = $("#player");

    var $hiddenContainer = $player.find(".hiddenBuffer");
    var $hidden = $hiddenContainer.find(".innerText");

    var $active = $("#player .innerText.active");
    if( $active.data("sessionId") == sessionId ) {
        return;
    }

    if( $hidden.data("sessionId") == sessionId ) {
        // Swap buffers
        $active.removeClass ("active");
        $hiddenContainer.append($active);
        $hidden.insertBefore($hiddenContainer);
        $hidden.addClass("active");

        // Also make this the active buffer
        $textBuffer = $hidden;
    }
}

function fadeIn($jqueryElement) {

    const minimumTimeSeparation = 200;
    const animDuration = 1000;

    var currentTime = Date.now();
    var timeSinceLastFade = currentTime - lastFadeTime;

    var delay = 0;
    if( timeSinceLastFade < minimumTimeSeparation )
        delay = minimumTimeSeparation - timeSinceLastFade;

    $jqueryElement.css("opacity", 0);
    $jqueryElement.delay(delay).animate({opacity: 1.0}, animDuration);

    lastFadeTime = currentTime + delay;
}

function contentReady() {

    var $scrollContainer = $("#player .scrollContainer");
    $scrollContainer.stop();

    // Need to save these ones because we are resetting height, so these are lost
    var savedScrollTop = $scrollContainer.scrollTop();
    var prevHeight = $textBuffer.height();

    // Need to reset first, otherwise ($textBuffer[0].scrollHeight) is always not less than $textBuffer.height() and it only expands (bad when story has huge list of choices)
    $textBuffer.height(0);
    var newHeight = $textBuffer[0].scrollHeight;

    // Expand to fit or keep same (we will shrink it later, after animating scroll, this way scroll animation is prettier)
    if( prevHeight < newHeight ) {
        $textBuffer.height(newHeight);
    } else {
        $textBuffer.height(prevHeight);
    }

    // Scroll?
    if( shouldAnimate() ) {
        
        var offset = newHeight + 60 - $scrollContainer.outerHeight(); // +60 because: ("#player .innerText { padding: 10px 0 50px 0; }")

        // Need to set previous, as it was reset when we reset height
        $scrollContainer.animate({scrollTop: savedScrollTop}, 0);

        $scrollContainer.animate({
            scrollTop: (offset)
        }, animationEnabled ? 500 : 100, function(){
            // Shrink, if needed
            if( prevHeight > newHeight ) {
                $textBuffer.height(newHeight);
            }
        });

    }
}

function prepareForNewPlaythrough(sessionId) {

    $textBuffer = $("#player .hiddenBuffer .innerText");
    $textBuffer.data("sessionId", sessionId);

    $textBuffer.text("");
    $textBuffer.height(0);

    $lastTextParagraph = null;
    $previousTextParagraph = null;

    textParagraphs = [];
    tagQueue = [];
    processingTagQueue = false;
}

function addTextSection(text)
{
    var $paragraph = $("<p class='storyText'></p>");

    // Game-specific instruction prefix, e.g. >>> START CAMERA: Wide shot
    if( instructionPrefix && text.trim().startsWith(instructionPrefix) ) {
        $paragraph.addClass("customInstruction");
    }

    // Split individual words into span tags, so that they can be underlined
    // when the user holds down the alt key, and so that they can be individually
    // clicked in order to jump to the source.
    var splitIntoSpans = text.split(" ");
    var textAsSpans = "<span>" + splitIntoSpans.join("</span> <span>") + "</span>";

    $paragraph.html(textAsSpans);

    // Keep track of the offset of each word into the content,
    // starting from the end of the last choice (it's global in the current play session)
    var previousContentLength = 0;
    var $existingLastContent = $textBuffer.children(".storyText").last();
    if( $existingLastContent ) {
        var range = $existingLastContent.data("range");
        if( range ) {
            previousContentLength = range.start + range.length + 1; // + 1 for newline
        }
    }
    $paragraph.data("range", {start: previousContentLength, length: text.length});

    // Append the actual content
    $textBuffer.append($paragraph);

    // Track text paragraphs so that delayed standalone tags (e.g. # CLEAR on its own line)
    // can be reattached to the paragraph they belong to, instead of appearing one line late.
    $paragraph.data('isEmpty', text.trim().length === 0);
    $previousTextParagraph = $lastTextParagraph;
    $lastTextParagraph = $paragraph;

    textParagraphs.push({
        $paragraph: $paragraph,
        range: {start: previousContentLength, length: text.length},
        text: text
    });

    // Find the offset of each word in the content, for clickability
    var offset = previousContentLength;
    $paragraph.children("span").each((i, element) => {
        var $span = $(element);
        var length = $span.text().length;
        $span.data("range", {start: offset, length: length});
        offset += length + 1; // extra 1 for space
    });

    // Alt-click handler to jump to source
    $paragraph.find("span").click(function(e) {
        if( e.altKey ) {

            var range = $(this).data("range");
            if( range ) {
                var midOffset = Math.floor(range.start + range.length/2);
                events.jumpToSource(midOffset);
            }

            e.preventDefault();
        }
    });

    if( animationEnabled && shouldAnimate() )
        fadeIn($paragraph);
}

function addTags(tags)
{
    // If we have the source text event provided by controller.js, try to place the tag
    // at the correct source line. Otherwise fall back to the heuristic inline placement.
    if (events.getAllSourceTexts && textParagraphs.length > 0) {
        tagQueue.push(tags);
        processTagQueue();
    } else {
        renderTagsHeuristic(tags);
    }
}

function renderTagsHeuristic(tags)
{
    var tagsStr = tags.join(", ");
    var $targetParagraph = null;
    if ($lastTextParagraph && !$lastTextParagraph.data('isEmpty')) {
        $targetParagraph = $lastTextParagraph;
    } else if ($previousTextParagraph) {
        $targetParagraph = $previousTextParagraph;
    } else if ($lastTextParagraph) {
        $targetParagraph = $lastTextParagraph;
    }

    if ($targetParagraph) {
        var $tags = $(`<span class='tags'> # ${tagsStr}</span>`);
        $targetParagraph.append($tags);
        if (animationEnabled && shouldAnimate()) fadeIn($tags);
    } else {
        var $tags = $(`<p class='tags'># ${tagsStr}</p>`);
        $textBuffer.append($tags);
        if (animationEnabled && shouldAnimate()) fadeIn($tags);
    }
}

function processTagQueue()
{
    if (processingTagQueue || tagQueue.length === 0) return;
    processingTagQueue = true;

    while (tagQueue.length > 0) {
        var tags = tagQueue.shift();
        var placement = determineTagPlacementSync(tags);
        renderTagsWithPlacement(tags, placement);
    }

    processingTagQueue = false;
}

function determineTagPlacementSync(tags)
{
    var allSources = events.getAllSourceTexts ? events.getAllSourceTexts() : [];
    if (allSources.length === 0 || textParagraphs.length === 0) {
        return {targetIndex: textParagraphs.length - 1, fallback: true};
    }

    var lastIndex = textParagraphs.length - 1;
    var lastText = textParagraphs[lastIndex].text;

    // Find the source file that contains the last text paragraph.
    var sourceContent = null;
    for (var i = 0; i < allSources.length; i++) {
        if (findSourceLineOfText(lastText, allSources[i].content) !== null) {
            sourceContent = allSources[i].content;
            break;
        }
    }

    if (!sourceContent) {
        return {targetIndex: lastIndex, fallback: true};
    }

    // Find the source line of each text paragraph in this file.
    var paraLines = findParagraphLinesInSource(textParagraphs, sourceContent);

    // Find the tag's source line, choosing the occurrence closest to the last paragraph.
    var lastParaLine = paraLines[lastIndex] !== null ? paraLines[lastIndex] : 1;
    var tagLine = findTagLineNearestTo(tags, sourceContent, lastParaLine);

    if (tagLine === null) {
        return {targetIndex: lastIndex, fallback: true};
    }

    // Attach the tag to the last paragraph that appears at or before the tag's source line.
    var targetIndex = -1;
    for (var i = 0; i < paraLines.length; i++) {
        if (paraLines[i] !== null && paraLines[i] <= tagLine) {
            targetIndex = i;
        }
    }
    if (targetIndex === -1) targetIndex = 0;

    // inklecate truncates tags that contain colons (e.g. # IMAGE: https://...). Recover the
    // full tag text from the source line so the preview shows the complete tag.
    var sourceLines = sourceContent.split('\n');
    var sourceLine = tagLine >= 1 && tagLine <= sourceLines.length ? sourceLines[tagLine - 1] : null;
    var fullTags = tags;
    if (sourceLine) {
        fullTags = tags.map(function(tag) {
            return extractFullTagFromSourceLine(sourceLine, tag);
        });
    }

    return {
        targetIndex: targetIndex,
        tagLine: tagLine,
        targetLine: paraLines[targetIndex] !== null ? paraLines[targetIndex] : null,
        fallback: false,
        fullTags: fullTags
    };
}

function findSourceLineOfText(text, content, startLine)
{
    var firstLine = text.split('\n').map(function(l) { return l.trim(); }).filter(function(l) { return l.length > 0; })[0];
    if (!firstLine) return null;

    var lines = content.split('\n');
    var startIndex = startLine ? Math.max(0, startLine - 1) : 0;
    for (var i = startIndex; i < lines.length; i++) {
        if (lines[i].indexOf(firstLine) !== -1) {
            return i + 1;
        }
    }
    return null;
}

function findParagraphLinesInSource(paragraphs, content)
{
    var lines = [];
    var searchStartLine = 1;

    for (var i = 0; i < paragraphs.length; i++) {
        var foundLine = findSourceLineOfText(paragraphs[i].text, content, searchStartLine);
        lines.push(foundLine);
        if (foundLine !== null) {
            searchStartLine = foundLine + 1;
        }
    }

    return lines;
}

function findTagLineNearestTo(tags, sourceText, targetLine)
{
    var bestLine = null;
    var bestDistance = Infinity;

    tags.forEach(function(tag) {
        var escapedTag = tag.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
        var regex = new RegExp("#\\s*" + escapedTag, "g");
        var match;
        while ((match = regex.exec(sourceText)) !== null) {
            var line = sourceText.substring(0, match.index).split('\n').length;
            var distance = Math.abs(line - targetLine);
            if (distance < bestDistance) {
                bestDistance = distance;
                bestLine = line;
            }
        }
    });

    return bestLine;
}

function extractFullTagFromSourceLine(sourceLine, truncatedTag)
{
    var idx = sourceLine.indexOf(truncatedTag);
    if (idx === -1) return truncatedTag;

    // Find the '#' that starts this tag
    var start = idx;
    while (start > 0 && sourceLine[start - 1] !== '#') {
        start--;
    }
    if (start > 0 && sourceLine[start - 1] === '#') {
        start = start - 1;
    } else {
        start = idx;
    }

    // Find the end of the tag (end of line or start of next tag)
    var end = idx + truncatedTag.length;
    while (end < sourceLine.length && sourceLine[end] !== '#') {
        end++;
    }

    var tagText = sourceLine.substring(start, end).trim();
    // Strip the leading '#' since the render functions already prepend one.
    if (tagText.charAt(0) === '#') {
        tagText = tagText.substring(1).trim();
    }
    return tagText;
}

function renderTagsWithPlacement(tags, placement)
{
    var displayTags = placement.fullTags || tags;
    var tagsStr = displayTags.join(", ");

    if (placement.targetIndex === null || placement.targetIndex < 0 || placement.targetIndex >= textParagraphs.length) {
        var $tags = $(`<p class='tags'># ${tagsStr}</p>`);
        $textBuffer.append($tags);
        if (animationEnabled && shouldAnimate()) fadeIn($tags);
        return;
    }

    var $target = textParagraphs[placement.targetIndex].$paragraph;

    // Source lookups failed: fall back to appending after the target paragraph.
    if (placement.fallback || placement.tagLine === null || placement.targetLine === null) {
        var $tags = $(`<p class='tags'># ${tagsStr}</p>`);
        $target.after($tags);
        if (animationEnabled && shouldAnimate()) fadeIn($tags);
        return;
    }

    if (placement.tagLine === placement.targetLine) {
        // Tag is on the same source line as the target paragraph: append inline.
        var $tags = $(`<span class='tags'> # ${tagsStr}</span>`);
        $target.append($tags);
        if (animationEnabled && shouldAnimate()) fadeIn($tags);
    } else if (placement.tagLine < placement.targetLine) {
        // Tag is on an earlier source line than the target: insert a separate tag paragraph before it.
        var $tags = $(`<p class='tags'># ${tagsStr}</p>`);
        $target.before($tags);
        if (animationEnabled && shouldAnimate()) fadeIn($tags);
    } else {
        // Tag is on a later source line than the target: insert a separate tag paragraph after it.
        var $tags = $(`<p class='tags'># ${tagsStr}</p>`);
        $target.after($tags);
        if (animationEnabled && shouldAnimate()) fadeIn($tags);
    }
}

function findTagLineNearestTo(tags, sourceText, targetLine)
{
    var bestLine = null;
    var bestDistance = Infinity;

    tags.forEach(function(tag) {
        var escapedTag = tag.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
        var regex = new RegExp("#\\s*" + escapedTag, "g");
        var match;
        while ((match = regex.exec(sourceText)) !== null) {
            var line = sourceText.substring(0, match.index).split('\n').length;
            var distance = Math.abs(line - targetLine);
            if (distance < bestDistance) {
                bestDistance = distance;
                bestLine = line;
            }
        }
    });

    return bestLine;
}

function addChoice(choice, callback)
{
    // New format (since ink can have tags directly on choices)
    // choice: {
    //    choice: {
    //      text: "this is a choice",
    //      tags: ["a tag", "another tag"]
    //    },
    //    ... other stuff, e.g. choice number ...
    // }
    var $choice = $("<a href='#'>"+choice.choice.text+"</a>");
    var $tags = null;
    if( choice.choice.tags != null && choice.choice.tags.length > 0 ) {
        var tagsStr = "# " + choice.choice.tags.join(" # ");
        $tags = $(` <span class='tags'>${tagsStr}</span>`);
    }

    // Append the choice
    var $choicePara = $("<p class='choice'></p>");
    $choicePara.append($choice);
    if( $tags != null ) $choicePara.append($tags);
    $textBuffer.append($choicePara);

    // Fade it in
    if( animationEnabled && shouldAnimate() )
        fadeIn($choicePara);

    // When this choice is clicked...
    $choice.on("click", (event) => {

        var existingHeight = $textBuffer.height();
        $textBuffer.height(existingHeight);

        // Remove any existing choices, and add a divider
        $(".choice").remove();

        addHorizontalDivider();

        event.preventDefault();

        callback();
    });
}

function addTerminatingMessage(message, cssClass)
{
    var $message = $(`<p class='${cssClass}'>${message}</p>`);
    $textBuffer.append($message);

    if( animationEnabled && shouldAnimate() )
        fadeIn($message);
}

function addLongMessage(message, cssClass)
{
    var $message = $(`<pre class='${cssClass}'>${message}</pre>`);
    $textBuffer.append($message);

    if( animationEnabled && shouldAnimate() )
        fadeIn($message);
}

function addHorizontalDivider()
{
    if (($textBuffer[0].lastChild == null) || ($textBuffer[0].lastChild.tagName != "HR")) {
        $textBuffer.append("<hr/>");
    }
    $lastTextParagraph = null;
    $previousTextParagraph = null;
    textParagraphs = [];
    tagQueue = [];
    processingTagQueue = false;
}

function addLineError(error, callback)
{
    var $aError = $(`<a href='#'>${i18n._("Line")} ${error.lineNumber}: ${error.message}</a>`);
    $aError.on("click", callback);

    var $paragraph = $("<p class='error'></p>");
    $paragraph.append($aError);
    $textBuffer.append($paragraph);
}

function addEvaluationResult(result, error)
{   
    var $result;
    if( error ) {
        $result = $(`<div class="evaluationResult error"><span>${error}</span></div>`);
    } else {
        $result = $(`<div class="evaluationResult"><span>${result}</span></div>`);
    }
    $textBuffer.append($result);
}

function previewStepBack()
{
    var $lastDivider = $("#player .innerText.active").find("hr").last();
    $lastDivider.nextAll().remove();
    $lastDivider.remove();
}

function setInstructionPrefix(prefix) {
    if( instructionPrefix == prefix ) return;

    instructionPrefix = prefix;

    // Refresh any existing content
    let $storyChunks = $textBuffer.find("p.storyText");
    for(let storyChunk of $storyChunks) {
        let $storyChunk = $(storyChunk);
        $storyChunk.removeClass("customInstruction");

        if( storyChunk.textContent.trim().startsWith(instructionPrefix) ) {
            $storyChunk.addClass("customInstruction");
        }
    }
}

function setAnimationEnabled(animEnabled) {
    animationEnabled = animEnabled;
}

exports.PlayerView = {
    setEvents: (e) => { events = e; },
    contentReady: contentReady,
    prepareForNewPlaythrough: prepareForNewPlaythrough,
    addTextSection: addTextSection,
    addTags: addTags,
    addChoice: addChoice,
    addTerminatingMessage: addTerminatingMessage,
    addLongMessage: addLongMessage,
    addHorizontalDivider: addHorizontalDivider,
    addLineError: addLineError,
    addEvaluationResult: addEvaluationResult,
    showSessionView: showSessionView,
    previewStepBack: previewStepBack,
    setInstructionPrefix: setInstructionPrefix,
    setAnimationEnabled: setAnimationEnabled
};  