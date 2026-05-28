const editor = ace.edit("editor");
const Range = ace.require("ace/range").Range;
const TokenIterator = ace.require("ace/token_iterator").TokenIterator;
const language_tools = ace.require("ace/ext/language_tools");

// Expose settings panel translations for ACE's ext-settings_menu
window.__inkyI18n = require("./settingsI18n.js");

// Player font settings (preview pane)
editor.setFont_PlayerSize = function(size) {
    var num = Number(size);
    if (isNaN(num) || num <= 0) num = 14;
    var el = document.getElementById("player");
    if (el) el.style.fontSize = num + "px";
    require("electron").ipcRenderer.send("save-font-setting", "playerFontSize", num);
};
editor.getFont_PlayerSize = function() {
    var el = document.getElementById("player");
    return el ? parseInt(el.style.fontSize) || 14 : 14;
};
editor.setFont_PlayerFamily = function(family) {
    if (!family || !family.trim()) family = "system-ui";
    var el = document.getElementById("player");
    if (el) el.style.fontFamily = family;
    require("electron").ipcRenderer.send("save-font-setting", "playerFontFamily", family);
};
editor.getFont_PlayerFamily = function() {
    var el = document.getElementById("player");
    var f = el ? el.style.fontFamily || "system-ui" : "system-ui";
    return f.replace(/["']/g, '');
};

// Add setFontFamily/getFontFamily so ACE settings panel can discover it
editor.setFontFamily = function(family) {
    this.setOption("fontFamily", family);
};
editor.getFontFamily = function() {
    var f = this.getOption("fontFamily") || "";
    return f.replace(/["']/g, '');
};

// Fix: ACE settings panel passes string values, ensure font size gets a number
var _origSetFontSize = editor.setFontSize;
editor.setFontSize = function(size) {
    var num = Number(size);
    if (isNaN(num) || num <= 0) num = 12;
    _origSetFontSize.call(this, num);
    require("electron").ipcRenderer.send("save-font-setting", "fontSize", num);
};

// Notify main process when font family changes
editor.setFontFamily = (function(orig) {
    return function(family) {
        if (!family || !family.trim()) family = "monospace";
        orig.call(this, family);
        require("electron").ipcRenderer.send("save-font-setting", "fontFamily", family);
    };
})(editor.setFontFamily);

const inkCompleter = require("./inkCompleter.js").inkCompleter;

var editorMarkers = [];
var editorAnnotations = [];

// Used when reloading files so that cursor doesn't jump back to the top
var savedCursorPos = null;
var savedScrollRow = null;

// Overriden by controller.js
var events = {
  change: () => {},
  jumpToInclude: () => {},
  jumpToSymbol: () => {},
  changedLine: () => {},
};

editor.setShowPrintMargin(false);
editor.setOptions({
  enableBasicAutocompletion: true, // defaults only, will be overriden by setAutoCompleteDisabled
  enableLiveAutocompletion: true,
});
editor.on("change", () => {
  events.change();
});
editor.on("changeSelection", () => {
  events.changedLine(editor.getCursorPosition());
});

// Exclude language_tools.textCompleter but add the Ink completer
editor.completers = editor.completers.filter(
  (completer) => completer !== language_tools.textCompleter,
);
editor.completers.push(inkCompleter);

// Unbind windows CTRL-P: "Jump to matching bracket" since it collides with
// our "go to anything" command.
editor.commands.removeCommand("jumptomatching");

// Unbind CMD-ALT-S from Ace so we can use it for save js only
editor.commands.removeCommand("sortlines");

// Unfortunately standard jquery events don't work since
// Ace turns pointer events off
editor.on("click", function (e) {
  if (e.domEvent.altKey) {
    tryClickCodeLink(e);
  } else {
    setImmediate(() => events.navigate());
  }
});

function tryClickCodeLink(event) {
  var editor = event.editor;
  var pos = editor.getCursorPosition();
  var searchToken = editor.session.getTokenAt(pos.row, pos.column);

  if (searchToken && searchToken.type == "include.filepath") {
    events.jumpToInclude(searchToken.value);
    return;
  }

  if (searchToken && searchToken.type == "divert.target") {
    event.preventDefault();
    var targetPath = searchToken.value;
    events.jumpToSymbol(targetPath, pos);
    return;
  }
}

// Unfortunately standard CSS for hover doesn't work in the editor
// since they turn pointer events off.
editor.on("mousemove", function (e) {
  var editor = e.editor;

  // Have to hold down modifier key to jump
  if (e.domEvent.altKey) {
    var character = editor.renderer.screenToTextCoordinates(e.x, e.y);
    var token = editor.session.getTokenAt(character.row, character.column);
    if (!token) return;

    var tokenStartPos = editor.renderer.textToScreenCoordinates(
      character.row,
      token.start,
    );
    var tokenEndPos = editor.renderer.textToScreenCoordinates(
      character.row,
      token.start + token.value.length,
    );

    const lineHeight = 12;
    if (
      e.x >= tokenStartPos.pageX &&
      e.x <= tokenEndPos.pageX &&
      e.y >= tokenStartPos.pageY &&
      e.y <= tokenEndPos.pageY + lineHeight
    ) {
      if (token) {
        if (token.type == "divert.target" || token.type == "include.filepath") {
          editor.renderer.setCursorStyle("pointer");
          return;
        }
      }
    }
  }

  editor.renderer.setCursorStyle("default");
});

function addError(error) {
  var editorErrorType = "error";
  var editorClass = "ace-error";
  if (error.type == "WARNING") {
    editorErrorType = "warning";
    editorClass = "ace-warning";
  } else if (error.type == "TODO") {
    editorErrorType = "information";
    editorClass = "ace-todo";
  }

  editorAnnotations.push({
    row: error.lineNumber - 1,
    column: 0,
    text: error.message,
    type: editorErrorType,
  });
  editor.getSession().setAnnotations(editorAnnotations);

  var aceClass = "ace-error";
  var markerId = editor.session.addMarker(
    new Range(error.lineNumber - 1, 0, error.lineNumber, 0),
    editorClass,
    "line",
    false,
  );
  editorMarkers.push(markerId);
}

function setErrors(errors) {
  clearErrors();
  errors.forEach(addError);
}

function clearErrors() {
  var editorSession = editor.getSession();
  editorSession.clearAnnotations();
  editorAnnotations = [];

  for (var i = 0; i < editorMarkers.length; i++) {
    editorSession.removeMarker(editorMarkers[i]);
  }
  editorMarkers = [];
}

exports.EditorView = {
  clearErrors: clearErrors,
  setEvents: (e) => {
    events = e;
  },
  getValue: () => {
    return editor.getValue();
  },
  setValue: (v) => {
    editor.setValue(v);
  },
  insert: (txt) => editor.insert(txt),
  gotoLine: (row, col) => {
    editor.gotoLine(row, col);
    editor.focus();
  },
  addError: addError,
  setErrors: setErrors,
  setFiles: (inkFiles) => {
    inkCompleter.inkFiles = inkFiles;
  },
  showInkFile: (inkFile) => {
    clearErrors();
    editor.setSession(inkFile.getAceSession());
    editor.focus();
  },
  showSettings: () => {
    editor.execCommand("showSettingsMenu");
  },
  focus: () => {
    editor.focus();
  },
  saveCursorPos: () => {
    savedCursorPos = editor.getCursorPosition();
    savedScrollRow = editor.getFirstVisibleRow();
  },
  restoreCursorPos: () => {
    if (savedCursorPos) {
      editor.moveCursorToPosition(savedCursorPos);
      editor.scrollToRow(savedScrollRow);
    }
  },
  getCurrentCursorPos: () => {
    return editor.getCursorPosition();
  },
  setFontSize: (size) => {
    editor.setFontSize(size);
  },
  setFontFamily: (family) => {
    editor.setFontFamily(family);
  },
  syncFontSizeFromZoom: (size) => {
    editor.setFontSize(size);
    // Also persist player font size from zoom
    var playerEl = document.getElementById('player');
    if (playerEl) {
        var playerSize = parseInt(playerEl.style.fontSize);
        if (playerSize) {
            require('electron').ipcRenderer.send('save-font-setting', 'playerFontSize', playerSize);
        }
    }
  },
  setAutoCompleteDisabled: (autoCompleteDisabled) => {
    editor.setOptions({
      enableBasicAutocompletion: !autoCompleteDisabled,
      enableLiveAutocompletion: !autoCompleteDisabled,
    });
  },
};
