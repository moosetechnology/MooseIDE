Class {
	#name : #MiMetaBrowserModel,
	#superclass : #MiAbstractModel,
	#instVars : [
		'selected',
		'entities'
	],
	#category : #'MooseIDE-Meta-MetaBrowser'
}

{ #category : #accessing }
MiMetaBrowserModel >> entities [

	^ entities
]

{ #category : #accessing }
MiMetaBrowserModel >> entities: anObject [

	entities := anObject
]

{ #category : #accessing }
MiMetaBrowserModel >> selected [

	^ selected
]

{ #category : #accessing }
MiMetaBrowserModel >> selected: anObject [

	selected := anObject
]
