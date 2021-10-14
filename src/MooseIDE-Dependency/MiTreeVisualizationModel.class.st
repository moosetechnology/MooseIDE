Class {
	#name : #MiTreeVisualizationModel,
	#superclass : #Object,
	#instVars : [
		'selected',
		'root'
	],
	#category : #'MooseIDE-Dependency-Tree'
}

{ #category : #'plugin interface' }
MiTreeVisualizationModel >> entities [

	^ { self root } , self root children asMooseGroup
]

{ #category : #accessing }
MiTreeVisualizationModel >> root [

	^ root
]

{ #category : #accessing }
MiTreeVisualizationModel >> root: anObject [

	root := anObject
]

{ #category : #accessing }
MiTreeVisualizationModel >> selected [

	^ selected
]

{ #category : #accessing }
MiTreeVisualizationModel >> selected: anObject [

	selected := anObject
]
