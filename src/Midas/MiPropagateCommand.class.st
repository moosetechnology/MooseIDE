Class {
	#name : #MiPropagateCommand,
	#superclass : #CmCommand,
	#category : #'Midas-Command'
}

{ #category : #default }
MiPropagateCommand class >> defaultName [
	^ 'Propagate'
]

{ #category : #testing }
MiPropagateCommand >> canBeExecuted [
	^ self context miSelectedItem isMooseEntity
]

{ #category : #testing }
MiPropagateCommand >> execute [
	^ MiApplication current globallySelect: self context miSelectedItem
]
