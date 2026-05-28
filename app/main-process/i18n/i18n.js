const electron = require("electron");
const fs = require("fs");
const path = require("path");

class i18n {
  constructor() {
    this.currentLocale = null;
    this.msgs = {};

    electron.app.on("ready", () => {
      this.switch(electron.app.getLocale());
    });

    electron.ipcMain.on("i18n._", (event, msgid) => {
      event.returnValue = this._(msgid);
    });
  }

  _(msgid) {
    // Strip leading & (Windows accelerator prefix) for lookup
    var cleanId = msgid.replace(/^&/, "");
    if (!(cleanId in this.msgs) || !this.msgs[cleanId].length) {
      this.msgs[cleanId] = cleanId;
    }
    return this.msgs[cleanId];
  }

  switch(lang) {
    this.currentLocale = lang;
    const file = path.join(__dirname, `${lang}.json`);
    if (fs.existsSync(file)) {
      this.msgs = require(file);
    } else {
      // Try short locale code (e.g. "zh" from "zh-Hans-CN")
      const shortLang = lang.split("-")[0];
      const shortFile = path.join(__dirname, `${shortLang}.json`);
      if (fs.existsSync(shortFile)) {
        this.msgs = require(shortFile);
      } else {
        const defaultLocale = electron.app.getLocale();
        if (lang != defaultLocale) {
          this.switch(defaultLocale);
        }
      }
    }
  }
}

module.exports = new i18n();
