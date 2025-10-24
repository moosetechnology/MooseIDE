Class {
	#name : 'MiArchitecturalMapStyle',
	#superclass : 'HDefaultStyleWithTags',
	#category : 'MooseIDE-Dependency-ArchitecturalMap',
	#package : 'MooseIDE-Dependency',
	#tag : 'ArchitecturalMap'
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
