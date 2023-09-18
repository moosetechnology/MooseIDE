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

	^ visualization miSelectedItem ifEmpty: [
		  specModel entities mooseInterestingEntity ]
]
