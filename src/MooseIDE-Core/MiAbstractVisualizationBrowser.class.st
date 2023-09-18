Class {
	#name : #MiAbstractVisualizationBrowser,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'visualization'
	],
	#category : #'MooseIDE-Core-Browser'
}

{ #category : #actions }
MiAbstractVisualizationBrowser >> canHighlight [

	^ true
]

{ #category : #highlighting }
MiAbstractVisualizationBrowser >> highlightEntity: entities [

	
	visualization highlightEntities: entities
]

{ #category : #accessing }
MiAbstractVisualizationBrowser >> miSelectedItem [

	^visualization canvas selectedShapes
		ifEmpty: [ specModel entities mooseInterestingEntity ]
		ifNotEmpty: [ :selectedShapes |
			(selectedShapes collect: [:shape | shape model rawModel])
				asMooseGroup ]
]
