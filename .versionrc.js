version_rb = {
  "filename": "lib/chkdfront/version.rb",
  "updater": {
    readVersion: function(contents) {
      match = contents.match(/^\s*VERSION = ["'](.+)["']$/m)
      return match[1]
    },
    writeVersion: function(contents, version) {
      currentVersion = this.readVersion(contents)
      // this isn't the most reliable, but meh
      return contents.replace(currentVersion, version)
    },
  },
}

module.exports = {
  "bumpFiles": [version_rb],
  "packageFiles": [version_rb],
  "preset": "angular",
}
