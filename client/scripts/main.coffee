angular = require 'angular'
controllers = require "./controller"
factories = require "./factory"
directives = require "./directive"
router = require "./router"

travap = angular.module 'travap', [
  'ngRoute'
  'ngResource'
  'ngTouch'
  'akoenig.deckgrid'
]

#add factories
travap.factory name, dependencies for name, dependencies of factories
#add directives
travap.directive name, dependencies for name, dependencies of directives
#add controllers
travap.controller name, dependencies for name, dependencies of controllers
#add routes
travap.config router

module.exports = travap
