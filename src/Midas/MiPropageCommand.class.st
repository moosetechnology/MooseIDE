Class {
	#name : #MiPropageCommand,
	#superclass : #CmCommand,
	#category : #'Midas-Command'
}

{ #category : #default }
MiPropageCommand class >> defaultName [
	^ 'Propagate'
]

{ #category : #testing }
MiPropageCommand >> canBeExecuted [
	^ self context isMooseEntity
]

{ #category : #testing }
MiPropageCommand >> execute [
	^ MiApplication current globallySelect: self context
]
