Class {
	#name : 'MiLVVerticalBoxNode',
	#superclass : 'MiLVAbstractBoxNode',
	#category : 'MooseIDE-LayerVisualization-Model',
	#package : 'MooseIDE-LayerVisualization',
	#tag : 'Model'
}

{ #category : 'visiting' }
MiLVVerticalBoxNode >> acceptVisitor: aVisitor [

	^ aVisitor visitVerticalBox: self
]
