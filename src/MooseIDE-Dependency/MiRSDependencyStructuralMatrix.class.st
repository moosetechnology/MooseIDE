Class {
	#name : #MiRSDependencyStructuralMatrix,
	#superclass : #RSDSM,
	#instVars : [
		'owner'
	],
	#category : #'MooseIDE-Dependency-DSM'
}

{ #category : #highlighting }
MiRSDependencyStructuralMatrix >> highlight: evt [
	super highlight: evt.
	shape := nil.
	(owner sccShapesIncluding: evt shape) do: [ :aShape |
		aShape color: (owner cellShowSCCColor: aShape model)
	]
]

{ #category : #accessing }
MiRSDependencyStructuralMatrix >> owner: anObject [

	owner := anObject
]

{ #category : #highlighting }
MiRSDependencyStructuralMatrix >> unhighlight: evt [
	super unhighlight: evt.

	(owner sccShapesIncluding: evt shape) do: [ :aShape |
		aShape color: (owner cellColor: aShape model)
	]
]
