Class {
	#name : #MiDragWindowCommand,
	#superclass : #MiCommand,
	#category : #'MooseIDE-Core-Command'
}

{ #category : #'accessing - defaults' }
MiDragWindowCommand class >> defaultDescription [

	^ 'Drag this browser into a workspace'
]

{ #category : #initialization }
MiDragWindowCommand class >> defaultIconName [

	^ #recoverLostChanges
]

{ #category : #'accessing - defaults' }
MiDragWindowCommand class >> defaultName [

	^ 'Drag me'
]

{ #category : #testing }
MiDragWindowCommand >> canBeExecuted [
	"This could be removed once all browsers use the new infrastructure and can all be dragged"

	^ self context canBeDragged
]

{ #category : #executing }
MiDragWindowCommand >> execute [
	self context dragBrowser
]
