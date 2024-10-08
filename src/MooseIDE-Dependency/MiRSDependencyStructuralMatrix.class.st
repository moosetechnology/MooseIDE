Class {
	#name : #MiRSDependencyStructuralMatrix,
	#superclass : #RSDSM,
	#instVars : [
		'owner'
	],
	#category : #'MooseIDE-Dependency-DSM'
}

{ #category : #hooks }
MiRSDependencyStructuralMatrix >> createShape: tuple [
	"1halt."
	| weight |
	weight := self getTupleDependencyWeight: tuple.

	^ MiRSDSMShape new
		text: (weight = 0 ifTrue: [''] ifFalse: [ weight asString]);
		model: tuple;
		color: (self color cull: tuple);
		yourself
]

{ #category : #accessing }
MiRSDependencyStructuralMatrix >> getTupleDependencyWeight: tuple [
	^ owner getTupleDependencyWeight: tuple
]

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
