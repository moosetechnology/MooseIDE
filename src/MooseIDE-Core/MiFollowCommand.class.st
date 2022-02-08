Class {
	#name : #MiFollowCommand,
	#superclass : #MiReceivingModeCommand,
	#category : #'MooseIDE-Core-Command'
}

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
