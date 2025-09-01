Class {
	#name : 'MiLVTypeElement',
	#superclass : 'MiLVAbstractElement',
	#category : 'MooseIDE-LayerVisualization-Model',
	#package : 'MooseIDE-LayerVisualization',
	#tag : 'Model'
}

{ #category : 'visiting' }
MiLVTypeElement >> acceptVisitor: aVisitor [

	^ aVisitor visitTypeElement: self
]
