Class {
	#name : 'MiArchitecturalMapStyle',
	#superclass : 'HDefaultStyleWithTags',
	#category : 'MooseIDE-ArchitecturalMap',
	#package : 'MooseIDE-ArchitecturalMap'
}

{ #category : 'public - hooks' }
MiArchitecturalMapStyle >> boxChildrenColorFor: anHNode [

	^ anHNode level odd
		  ifTrue: [ Color lightGray ]
		  ifFalse: [ Color veryLightGray ]
]

{ #category : 'private' }
MiArchitecturalMapStyle >> colorFor: node [

	^ node color ifNil: [ (Smalltalk ui theme baseColor) alpha: 0.7 ]
]
