Class {
	#name : #MiArchitecturalMapVirtualEntity,
	#superclass : #MooseEntity,
	#instVars : [
		'rawEntity'
	],
	#category : #'MooseIDE-Dependency-ArchitecturalMap'
}

{ #category : #accessing }
MiArchitecturalMapVirtualEntity >> name [

	^rawEntity basename
]

{ #category : #accessing }
MiArchitecturalMapVirtualEntity >> rawEntity [

	^ rawEntity
]

{ #category : #accessing }
MiArchitecturalMapVirtualEntity >> rawEntity: anObject [

	rawEntity := anObject
]
