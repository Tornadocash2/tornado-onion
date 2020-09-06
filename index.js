console.log('current working directory', process.cwd())
var read = require('fs').readFileSync
console.log(read('./config/tor-apt-sources.list', 'utf8'))
