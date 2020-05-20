Class {
	#name : #MiPropagateCommand,
	#superclass : #CmCommand,
	#category : #'Midas-Core-Command'
}

{ #category : #default }
MiPropagateCommand class >> defaultName [
	^ 'Propagate'
]

{ #category : #default }
MiPropagateCommand class >> forSpecContext: anObject [
	^ (self forSpecWithIconNamed: #moosePropagate) beHiddenWhenCantBeRun
]

{ #category : #testing }
MiPropagateCommand >> canBeExecuted [
	^ self context miSelectedItem isMooseEntity
]

{ #category : #testing }
MiPropagateCommand >> execute [
	^ MiApplication current globallySelect: self context miSelectedItem
]
