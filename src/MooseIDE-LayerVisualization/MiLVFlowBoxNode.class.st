Class {
	#name : #MiLVFlowBoxNode,
	#superclass : #MiLVAbstractBoxNode,
	#category : #'MooseIDE-LayerVisualization-Model'
}

{ #category : #visiting }
MiLVFlowBoxNode >> acceptVisitor: aVisitor [

	^ aVisitor visitFlowBox: self
]
