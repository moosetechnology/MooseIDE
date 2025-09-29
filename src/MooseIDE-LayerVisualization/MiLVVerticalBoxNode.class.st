Class {
	#name : #MiLVVerticalBoxNode,
	#superclass : #MiLVAbstractBoxNode,
	#category : #'MooseIDE-LayerVisualization-Model'
}

{ #category : #visiting }
MiLVVerticalBoxNode >> acceptVisitor: aVisitor [

	^ aVisitor visitVerticalBox: self
]
