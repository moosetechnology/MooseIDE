"
Use me to propagate entities through the application
"
Class {
	#name : #MiPropagateCommand,
	#superclass : #CmCommand,
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
MiPropagateCommand class >> defaultName [
	^ 'Propagate'
]

{ #category : #default }
MiPropagateCommand class >> forSpecContext: anObject [
	^ (super forSpecContext: anObject)
		iconNamed: #moosePropagate;
		beHiddenWhenCantBeRun;
		yourself
]

{ #category : #testing }
MiPropagateCommand >> canBeExecuted [
	^ self context miSelectedItem isMooseObject
]

{ #category : #freezing }
MiPropagateCommand >> doNotFreezeBrowser [
	shouldFreezeBrowser := false
]

{ #category : #testing }
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
