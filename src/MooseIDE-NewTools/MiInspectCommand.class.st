"
Use me to inspect the selected entities
"
Class {
	#name : 'MiInspectCommand',
	#superclass : 'MiCommand',
	#category : 'MooseIDE-NewTools-Inspector',
	#package : 'MooseIDE-NewTools',
	#tag : 'Inspector'
}

{ #category : 'default' }
MiInspectCommand class >> defaultDescription [
	^ 'Inspect selected entity'
]

{ #category : 'default' }
MiInspectCommand class >> defaultIconName [

	^ #smallInspectIt
]

{ #category : 'default' }
MiInspectCommand class >> defaultName [

	^ 'Inspect'
]

{ #category : 'default' }
MiInspectCommand class >> defaultShortcut [

	^ $m meta shift , $i meta shift
]

{ #category : 'testing' }
MiInspectCommand >> canBeExecuted [

	^ self context canPropagate
]

{ #category : 'executing' }
MiInspectCommand >> execute [

	[ self context miInspect ]
		on: MiNoSelectedElementToPropagateException
		do: [ :exception | 
			exception signal.
			^ self ]
]
