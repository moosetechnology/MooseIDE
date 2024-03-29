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

{ #category : #default }
MiPropagateCommand class >> defaultShortcut [

	^ $m shift meta , $p meta shift
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
	selectedItem := [ self context miSelectedItemToPropagate ]
		on: MiNoSelectedElementToPropagateException
		do: [ :exception | 
			exception signal.
			^ self ].
	self context buses do: [ :bus | bus globallySelect: selectedItem mooseInterestingEntity ]
]
