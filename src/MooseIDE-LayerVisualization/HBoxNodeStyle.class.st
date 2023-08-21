Class {
	#name : #HBoxNodeStyle,
	#superclass : #HBorderAndTitleStyle,
	#category : #'MooseIDE-LayerVisualization-Roassal-builder'
}

{ #category : #building }
HBoxNodeStyle >> layoutOn: aGroupOfShapes parent: anHNode [
	aGroupOfShapes ifEmpty: [ ^ self ].
	
	self relayout: aGroupOfShapes parent: anHNode.
	
	
]
