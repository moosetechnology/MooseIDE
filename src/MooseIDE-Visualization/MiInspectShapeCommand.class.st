Class {
	#name : #MiInspectShapeCommand,
	#superclass : #MiShapeCommand,
	#category : #'MooseIDE-Visualization-Commands'
}

{ #category : #default }
MiInspectShapeCommand class >> defaultDescription [

	^ 'Inspect the entity in Moose'
]

{ #category : #default }
MiInspectShapeCommand class >> defaultName [

	^ 'Inspect'
]

{ #category : #executing }
MiInspectShapeCommand >> execute [

	self context miInspect
]
