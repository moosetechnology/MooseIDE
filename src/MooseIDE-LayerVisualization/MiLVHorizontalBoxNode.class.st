Class {
	#name : 'MiLVHorizontalBoxNode',
	#superclass : 'MiLVAbstractBoxNode',
	#category : 'MooseIDE-LayerVisualization-Model',
	#package : 'MooseIDE-LayerVisualization',
	#tag : 'Model'
}

{ #category : 'visiting' }
MiLVHorizontalBoxNode >> acceptVisitor: aVisitor [

	^ aVisitor visitHorizontalBox: self
]
