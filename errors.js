var fasterror = require('fasterror');

module.exports = {
    ParseError: fasterror('ParseError'),
    NotFoundError: fasterror('NotFoundError')
};
