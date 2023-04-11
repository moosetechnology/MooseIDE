"
I represent a command corresponding to a follow button in browsers.
This command allows to accept changes pushed by the bus.
"
Class {
	#name : #MiFollowCommand,
	#superclass : #MiReceivingModeCommand,
	#category : #'MooseIDE-Core-Command'
}

{ #category : #default }
MiFollowCommand class >> defaultDescription [
	^ 'A mode that allows to accept changes pushed on the bus'
]

{ #category : #default }
MiFollowCommand class >> defaultName [

	^ 'Follow'
]

{ #category : #accessing }
MiFollowCommand >> iconName [

	^ self iconNameForState: self context canFollow
]

{ #category : #accessing }
MiFollowCommand >> receivingMode [

	^ MiFollowMode
]
