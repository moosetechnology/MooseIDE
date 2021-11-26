Class {
	#name : #MiCycleDependencies,
	#superclass : #MiAbstractVisualization,
	#instVars : [
		'entities'
	],
	#category : #'MooseIDE-Telescope-CycleDependencies'
}

{ #category : #accessing }
MiCycleDependencies >> entities [
	^ entities
]

{ #category : #accessing }
MiCycleDependencies >> entities: anObject [
	entities := anObject
]

{ #category : #running }
MiCycleDependencies >> run [
	super run.
	(TLCycleDependencies new
		entities: self entities;
		property: [ :each | 
			(OrderedCollection
				with: (each queryAllIncoming withoutSelfLoops atScope: each class)
				with: (each queryAllOutgoing withoutSelfLoops atScope: each class))
				flattened ];
		widthBlock: [ :each | 
			(each queryAllIncoming withoutSelfLoops atScope: each class) size * 10
				max: 5 ];
		heightBlock: [ :each | 
			(each queryAllOutgoing withoutSelfLoops atScope: each class) size * 10
				max: 5 ];
		yourself) openInCanvas: self canvas
]
