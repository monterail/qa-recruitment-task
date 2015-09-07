angular.module('BornApp').factory 'Notification', ($timeout) ->
  _notifications = []
  Notification =
    all: -> _notifications
    create: (notification) ->
      _notifications.push notification
      $timeout (->
        notification.active = true
        if notification.timeout
          $timeout (->
            Notification.destroy notification
            return
          ), notification.timeout
        return
      ), 100
      notification
    destroy: (notification) ->
      if notification.active
        notification.active = false
        $timeout (->
          _notifications.splice _notifications.indexOf(notification), 1
          return
        ), 100
      return
  Notification
