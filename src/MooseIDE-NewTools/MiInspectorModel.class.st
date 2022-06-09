Class {
	#name : #MiInspectorModel,
	#superclass : #MiAbstractModel,
	#instVars : [
		'entity'
	],
	#category : #'MooseIDE-NewTools-Inspector'
}

{ #category : #accessing }
MiInspectorModel >> entity [

	^ entity
]

{ #category : #accessing }
MiInspectorModel >> entity: anObject [

	entity := anObject
]
