angular = require 'angular'
controllers = require "./controller"
factories = require "./factory"
router = require "./router"

travap = angular.module 'travap', [
  'ngRoute'
  'ngResource'
]

#add factories
travap.factory name, dependencies for name, dependencies of factories
#add controllers
travap.controller name, dependencies for name, dependencies of controllers
#add routes
travap.config router

module.exports = travap
