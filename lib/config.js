var cache;

module.exports = function(config) {
    config = config || cache;
    if (typeof config !== 'object') throw new TypeError('application not configured');
    if (checkString(config.PostgresURL)) throw new TypeError('PostgresURL must be a non-empty string');
    cache = config;
    return cache;
};

function checkString(str) {
    return typeof str !== 'string' || !str.length;
}