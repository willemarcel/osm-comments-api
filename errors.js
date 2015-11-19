var fasterror = require('fasterror');

module.exports = {
    'ParseError': fasterror('ParseError', {'code': 400}),
    'NotFoundError': fasterror('NotFoundError', {'code': 404})
};