Class {
	#name : #MiLVAbstractNode,
	#superclass : #Object,
	#instVars : [
		'expanded',
		'parent'
	],
	#category : #'MooseIDE-LayerVisualization-Model'
}

{ #category : #visiting }
MiLVAbstractNode >> acceptVisitor: aVisitor [

	self subclassResponsibility
]

{ #category : #initialization }
MiLVAbstractNode >> collapse [

	expanded := false
]

{ #category : #accessing }
MiLVAbstractNode >> depth [

	parent ifNil: [ ^ 0 ].
	^ 1 + parent depth
]

{ #category : #initialization }
MiLVAbstractNode >> expand [

	expanded := true
]

{ #category : #initialization }
MiLVAbstractNode >> expanded [

	^ expanded
]

{ #category : #initialization }
MiLVAbstractNode >> initialize [

	super initialize.
	expanded := true.
]

{ #category : #accessing }
MiLVAbstractNode >> parent [

	^ parent
]

{ #category : #accessing }
MiLVAbstractNode >> parent: anObject [

	parent := anObject
]
