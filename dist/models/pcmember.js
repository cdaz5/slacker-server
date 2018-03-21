'use strict';

Object.defineProperty(exports, "__esModule", {
  value: true
});

exports.default = (sequelize, DataTypes) => {
  const PCMember = sequelize.define('pcmember', {});

  return PCMember;
};