"
Use me to propagate entities through the application
"
Class {
	#name : #MiPropagateCommand,
	#superclass : #MiCommand,
	#instVars : [
		'shouldFreezeBrowser'
	],
	#category : #'MooseIDE-Core-Command'
}

{ #category : #default }
MiPropagateCommand class >> defaultDescription [
	^ 'Propagate selected entity'
]

{ #category : #default }
MiPropagateCommand class >> defaultIconName [

	^ #mooseOutgoing
]

{ #category : #default }
MiPropagateCommand class >> defaultName [
	^ 'Propagate'
]

{ #category : #testing }
MiPropagateCommand >> canBeExecuted [

	^ self context canPropagate
]

{ #category : #freezing }
MiPropagateCommand >> doNotFreezeBrowser [
	shouldFreezeBrowser := false
]

{ #category : #executing }
MiPropagateCommand >> execute [
	shouldFreezeBrowser
		ifTrue: [ self context freezeDuring: [ self propagate ] ]
		ifFalse: [ self propagate ]
]

{ #category : #initialization }
MiPropagateCommand >> initialize [
	super initialize.
	shouldFreezeBrowser := true
]

{ #category : #testing }
MiPropagateCommand >> propagate [
	| selectedItem |
	selectedItem := [ self context miSelectedItem ]
		on: MiNoSelectedElementToPropagateException
		do: [ :exception | 
			exception signal.
			^ self ].
	selectedItem isMooseObject
		ifFalse: [ ^ self ].
	self context buses do: [ :bus | bus globallySelect: selectedItem ]
]
