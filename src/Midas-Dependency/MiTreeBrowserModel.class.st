Class {
	#name : #MiTreeBrowserModel,
	#superclass : #Object,
	#instVars : [
		'selected',
		'root'
	],
	#category : #'Midas-Dependency'
}

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
