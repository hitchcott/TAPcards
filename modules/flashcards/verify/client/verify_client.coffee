
thisCard = -> TAP.cols.Cards.findOne({_id: Session.get('verifyCardId')}) 



Template.verify.card = -> thisCard()

myLanguage = ->
  TAP.helpers.getProfile(Meteor.userId())?.language

Template.verify.thisWord = -> thisCard().translation[myLanguage()]?.word

Template.verify.events = 
  'click .skip' : ->
    Router.go '/contribute'

  'click .good': ->
    if thisCard().translation[myLanguage()].verified >= 2
      update = {}
      update["translation.#{myLanguage()}.verified"] = true
      TAP.cols.Cards.update {_id:thisCard()._id},
        $set:update
    else
      update = {}
      update["translation.#{myLanguage()}.verified"] = 1
      TAP.cols.Cards.update {_id:thisCard()._id},
        $inc:update

    Router.go '/contribute'


  'click .bad': ->
    update = {}
    update["translation.#{myLanguage()}.verified"] = -1
    TAP.cols.Cards.update {_id:thisCard()._id},
      $inc:update
    Router.go '/contribute'
