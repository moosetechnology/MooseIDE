Class {
	#name : 'MiLVFlowBoxNode',
	#superclass : 'MiLVAbstractBoxNode',
	#category : 'MooseIDE-LayerVisualization-Model',
	#package : 'MooseIDE-LayerVisualization',
	#tag : 'Model'
}

{ #category : 'visiting' }
MiLVFlowBoxNode >> acceptVisitor: aVisitor [

	^ aVisitor visitFlowBox: self
]
