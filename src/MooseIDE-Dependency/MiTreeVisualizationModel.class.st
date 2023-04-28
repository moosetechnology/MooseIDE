Class {
	#name : #MiTreeVisualizationModel,
	#superclass : #MiAbstractModel,
	#instVars : [
		'selected',
		'root'
	],
	#category : #'MooseIDE-Dependency-Tree'
}

{ #category : #accessing }
MiTreeVisualizationModel >> entities [

	^ self root
		ifNil: [ #() ]
		ifNotNil: [ :theRoot | { theRoot } , theRoot children asMooseGroup]
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
