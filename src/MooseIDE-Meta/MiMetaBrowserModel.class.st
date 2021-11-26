Class {
	#name : #MiMetaBrowserModel,
	#superclass : #Object,
	#instVars : [
		'selected'
	],
	#category : #'MooseIDE-Meta-MetaBrowser'
}

{ #category : #accessing }
MiMetaBrowserModel >> selected [

	^ selected
]

{ #category : #accessing }
MiMetaBrowserModel >> selected: anObject [

	selected := anObject
]
