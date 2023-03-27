"
I am a model for MiInspectorBrowser.
I store the object to inspect.
"
Class {
	#name : #MiInspectorModel,
	#superclass : #MiAbstractModel,
	#instVars : [
		'entity'
	],
	#category : #'MooseIDE-NewTools-Inspector'
}

{ #category : #accessing }
MiInspectorModel >> entities [

	^entity
		ifNil: [ #() ]
		ifNotNil: [ { entity} ]
]

{ #category : #accessing }
MiInspectorModel >> entity [

	^ entity
]

{ #category : #accessing }
MiInspectorModel >> entity: anObject [

	entity := anObject
]
