Class {
	#name : 'MiPropagateShapeCommand',
	#superclass : 'MiShapeInBrowserCommand',
	#category : 'MooseIDE-Visualization-Commands',
	#package : 'MooseIDE-Visualization',
	#tag : 'Commands'
}

{ #category : 'default' }
MiPropagateShapeCommand class >> defaultDescription [

	^ 'Propagate the entity on the browser buses'
]

{ #category : 'default' }
MiPropagateShapeCommand class >> defaultName [

	^ 'Propagate'
]

{ #category : 'executing' }
MiPropagateShapeCommand >> execute [

	browser freezeDuring: [ self context miPropagateOn: browser buses ]
]
