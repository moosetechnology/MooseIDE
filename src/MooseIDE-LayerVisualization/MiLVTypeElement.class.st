Class {
	#name : #MiLVTypeElement,
	#superclass : #MiLVAbstractElement,
	#category : #'MooseIDE-LayerVisualization-Model'
}

{ #category : #visiting }
MiLVTypeElement >> acceptVisitor: aVisitor [

	^ aVisitor visitTypeElement: self
]
