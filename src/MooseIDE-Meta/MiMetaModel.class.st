Class {
	#name : 'MiMetaModel',
	#superclass : 'MiAbstractModel',
	#instVars : [
		'selected',
		'entities'
	],
	#category : 'MooseIDE-Meta-MetaBrowser',
	#package : 'MooseIDE-Meta',
	#tag : 'MetaBrowser'
}

{ #category : 'accessing' }
MiMetaModel >> entities [

	^ entities
]

{ #category : 'accessing' }
MiMetaModel >> entities: anObject [

	entities := anObject
]

{ #category : 'accessing' }
MiMetaModel >> selected [

	^ selected
]

{ #category : 'accessing' }
MiMetaModel >> selected: anObject [

	selected := anObject
]
