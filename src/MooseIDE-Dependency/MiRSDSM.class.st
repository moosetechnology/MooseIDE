Class {
	#name : #MiRSDSM,
	#superclass : #RSDSM,
	#instVars : [
		'owner'
	],
	#category : #'MooseIDE-Dependency-DSM'
}

{ #category : #highlighting }
MiRSDSM >> highlight: evt [
	super highlight: evt.
	shape := nil.
	(owner sccShapesIncluding: evt shape) do: [ :aShape |
		aShape color: (owner cellShowSCCColor: aShape model)
	]
]

{ #category : #accessing }
MiRSDSM >> owner: anObject [

	owner := anObject
]

{ #category : #highlighting }
MiRSDSM >> unhighlight: evt [
	super unhighlight: evt.

	(owner sccShapesIncluding: evt shape) do: [ :aShape |
		aShape color: (owner cellColor: aShape model)
	]
]
