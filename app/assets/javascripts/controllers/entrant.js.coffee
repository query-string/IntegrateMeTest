angular.module('integrate', []).controller('EntrantController', ($scope, $http) ->
  self = @

  @init = (data) ->
    self.competition = data.competition
    self.entry = {competition_id: data.competition.id}

  @refresh = ->
    $http.get('/entries/' + self.entry.id).then (response) ->
      self.entry.state = response.data.entry.state
      self.entry.log   = response.data.entry.log.title

  @submit = ->
    $http.post("/entries", self.entry).
      success((data, status, headers, config) ->

        if data.success
          self.entry.completed = true
          self.entry.id        = data.entry.id
          self.entry.state     = data.entry.state
        else
          self.errors = data.errors

      ).
      error((data, status, headers, config) ->
        alert("ERROR!")
      )

  self
)
