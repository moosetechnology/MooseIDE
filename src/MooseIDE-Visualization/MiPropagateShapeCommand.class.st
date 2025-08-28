Class {
	#name : 'MiPropagateShapeCommand',
	#superclass : 'MiShapeCommand',
	#instVars : [
		'browser'
	],
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

{ #category : 'accessing' }
MiPropagateShapeCommand >> browser: aMiBrowser [

	browser := aMiBrowser
]

{ #category : 'executing' }
MiPropagateShapeCommand >> execute [

	browser freezeDuring: [ self context miPropagateOn: browser buses ]
]
