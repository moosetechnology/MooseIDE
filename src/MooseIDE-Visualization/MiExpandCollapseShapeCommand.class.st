Class {
	#name : 'MiExpandCollapseShapeCommand',
	#superclass : 'MiShapeCommand',
	#category : 'MooseIDE-Visualization-Commands',
	#package : 'MooseIDE-Visualization',
	#tag : 'Commands'
}

{ #category : 'default' }
MiExpandCollapseShapeCommand class >> defaultDescription [

	^ 'Expand or collapse the shape'
]

{ #category : 'default' }
MiExpandCollapseShapeCommand class >> defaultName [

	^ 'Expand/Collapse'
]

{ #category : 'executing' }
MiExpandCollapseShapeCommand >> execute [

	self context model expandCollapse
]
