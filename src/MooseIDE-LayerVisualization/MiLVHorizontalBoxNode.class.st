Class {
	#name : #MiLVHorizontalBoxNode,
	#superclass : #MiLVAbstractBoxNode,
	#category : #'MooseIDE-LayerVisualization-Model'
}

{ #category : #visiting }
MiLVHorizontalBoxNode >> acceptVisitor: aVisitor [

	^ aVisitor visitHorizontalBox: self
]
