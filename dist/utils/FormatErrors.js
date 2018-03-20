'use strict';

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.formatError = undefined;

var _pick = require('lodash/pick');

var _pick2 = _interopRequireDefault(_pick);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

/* eslint-disable import/prefer-default-export */
var formatError = exports.formatError = function formatError(error, models) {
  if (error instanceof models.sequelize.ValidationError) {
    return error.errors.map(function (err) {
      return (0, _pick2.default)(err, ['path', 'message']);
    });
  }
  return [{ path: 'name', message: 'something went wrong' }];
};