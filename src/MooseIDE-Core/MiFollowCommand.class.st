Class {
	#name : #MiFollowCommand,
	#superclass : #MiReceivingModeCommand,
	#category : #'MooseIDE-Core-Command'
}

{ #category : #'accessing - defaults' }
MiFollowCommand class >> defaultName [

	^ 'Follow'
]

{ #category : #accessing }
MiFollowCommand >> iconName [

	^ self context canFollow
		  ifTrue: [ #radioButtonSelected ]
		  ifFalse: [ #radioButtonUnselected ]
]

{ #category : #accessing }
MiFollowCommand >> receivingMode [

	^ MiFollowMode
]
