var validate = require('validate.js');
var moment = require('moment');

validate.validators.bbox = function(value, options) {
    if (!options.presence && !value) {
        return null;
    }
    if (options.presence && !value) {
        return 'not supplied';
    }
    var errMsg = 'not a valid bbox string';
    var coords = value.split(',');
    if (coords.length != 4) {
        return errMsg;
    }
    for (var i =0; i < coords.length; i++) {
        if (!validate.isNumber(parseFloat(coords[i]))) {
            return errMsg;
        }
    }
    if (coords[0] < -180 || coords[0] > 180) {
        return errMsg;
    }
    if (coords[2] < -180 || coords[2] > 180) {
        return errMsg;
    }
    if (coords[1] < -90 || coords[1] > 90) {
        return errMsg;
    }
    if (coords[3] < -90 || coords[3] > 90) {
        return errMsg;
    }
    return null;
};

validate.extend(validate.validators.datetime, {
    // The value is guaranteed not to be null or undefined but otherwise it
    // could be anything.
    parse: function(value) {
        return +moment.utc(value);
    },
    // Input is a unix timestamp
    format: function(value, options) {
        var format = options.dateOnly ? 'YYYY-MM-DD' : 'YYYY-MM-DD hh:mm:ss';
        return moment.utc(value).format(format);
    }
});
