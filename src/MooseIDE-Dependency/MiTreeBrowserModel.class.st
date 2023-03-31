Class {
	#name : #MiTreeBrowserModel,
	#superclass : #MiAbstractModel,
	#instVars : [
		'selected',
		'root'
	],
	#category : #'MooseIDE-Dependency-Tree'
}

{ #category : #accessing }
MiTreeBrowserModel >> entities [
	^root
		ifNil: [ #() ]
		ifNotNil: [ { root } ]
]

{ #category : #accessing }
MiTreeBrowserModel >> root [
	^ root
]

{ #category : #accessing }
MiTreeBrowserModel >> root: anObject [
	root := anObject
]

{ #category : #accessing }
MiTreeBrowserModel >> selected [
	^ selected
]

{ #category : #accessing }
MiTreeBrowserModel >> selected: anObject [
	selected := anObject
]
