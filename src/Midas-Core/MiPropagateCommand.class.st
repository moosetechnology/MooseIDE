"
Use me to propagate entities through the application
"
Class {
	#name : #MiPropagateCommand,
	#superclass : #CmCommand,
	#instVars : [
		'shouldFreezeBrowser'
	],
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
	^ self context miSelectedItem isMooseObject
]

{ #category : #testing }
MiPropagateCommand >> execute [
	shouldFreezeBrowser
		ifTrue: [ self context freezeDuring: [ self propagate ] ]
		ifFalse: [ self propagate ]
]

{ #category : #'as yet unclassified' }
MiPropagateCommand >> freezeBrowser [
	shouldFreezeBrowser := true
]

{ #category : #'as yet unclassified' }
MiPropagateCommand >> initialize [
	super initialize.
	shouldFreezeBrowser := false
]

{ #category : #testing }
MiPropagateCommand >> propagate [
	^ MiApplication current globallySelect: self context miSelectedItem
]
