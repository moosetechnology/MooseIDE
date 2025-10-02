Class {
	#name : 'MiLVPackageElement',
	#superclass : 'MiLVAbstractElement',
	#instVars : [
		'children'
	],
	#category : 'MooseIDE-LayerVisualization-Model',
	#package : 'MooseIDE-LayerVisualization',
	#tag : 'Model'
}

{ #category : 'visiting' }
MiLVPackageElement >> acceptVisitor: aVisitor [

	^ aVisitor visitPackageElement: self
]

{ #category : 'accessing' }
MiLVPackageElement >> children [

	^ children
]

{ #category : 'accessing' }
MiLVPackageElement >> children: anObject [

	children := anObject
]
