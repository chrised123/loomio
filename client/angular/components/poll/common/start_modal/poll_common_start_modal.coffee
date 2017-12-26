{ iconFor, applyPollStartSequence } = require 'angular/helpers/poll.coffee'

angular.module('loomioApp').factory 'PollCommonStartModal', ->
  templateUrl: 'generated/components/poll/common/start_modal/poll_common_start_modal.html'
  controller: ($scope, poll) ->
    $scope.poll = poll.clone()

    $scope.icon = ->
      iconFor($scope.poll)

    applyPollStartSequence $scope
