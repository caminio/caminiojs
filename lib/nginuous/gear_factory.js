/*
 * nginuous
 * (c) 2014 by TASTENWERK
 * license: GPLv3
 *
 */

var GearFactory = {};

GearFactory.process = function processGear( gear ){
  console.log('proces', gear.absolutePath );
}

module.exports = GearFactory;
