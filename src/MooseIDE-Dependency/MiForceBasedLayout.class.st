"
A force based layout for Roassal with parameterstunned for ArchitecturalMap where the nodes
"
Class {
	#name : 'MiForceBasedLayout',
	#superclass : 'RSForceBasedLayout',
	#category : 'MooseIDE-Dependency-ArchitecturalMap',
	#package : 'MooseIDE-Dependency',
	#tag : 'ArchitecturalMap'
}

{ #category : 'as yet unclassified' }
MiForceBasedLayout class >> layoutDescription [

	^ 'Arrange shapes boased on attraction/repulsion forces.'
]

{ #category : 'accessing' }
MiForceBasedLayout class >> layoutName [

	^ 'Force based'
]

{ #category : 'initialization' }
MiForceBasedLayout >> reset [
	super reset.

	self
		length: 300;
		charge: -200
]
