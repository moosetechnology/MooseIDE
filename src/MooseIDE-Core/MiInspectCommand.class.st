"
Use me to inspect the selected entities
"
Class {
	#name : #MiInspectCommand,
	#superclass : #MiCommand,
	#category : #'MooseIDE-Core-Command'
}

{ #category : #default }
MiInspectCommand class >> defaultDescription [
	^ 'Inspect selected entity'
]

{ #category : #default }
MiInspectCommand class >> defaultIconName [

	^ #smallInspectIt
]

{ #category : #default }
MiInspectCommand class >> defaultName [

	^ 'Inspect'
]

{ #category : #testing }
MiInspectCommand >> canBeExecuted [

	^ self context miSelectedItem isMooseObject
]

{ #category : #executing }
MiInspectCommand >> execute [

	| selectedItem |
	selectedItem := [ self context miSelectedItem ]
		                on: MiNoSelectedElementToPropagateException
		                do: [ :exception | 
			                exception signal.
			                ^ self ].
	MiInspectorBrowser inspect: selectedItem forBuses: self context buses
]
