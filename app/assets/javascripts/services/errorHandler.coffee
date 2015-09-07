angular.module('BornApp').factory 'errorHandler', (Notification) ->
  occur: (errormessage) ->
    Notification.create({ message: errormessage, type: 'error', image: '/assets/avatarerror.png' })
