Class {
	#name : #MiRSDependencyStructuralMatrix,
	#superclass : #RSDSM,
	#instVars : [
		'owner'
	],
	#category : #'MooseIDE-Dependency-DSM'
}

{ #category : #'hooks - labels' }
MiRSDependencyStructuralMatrix >> createLabelShapeX: aRSBox [

	^(super createLabelShapeX: aRSBox)
		popupText: [ :graphNode | graphNode model mooseName ] ;
		yourself
]

{ #category : #'hooks - labels' }
MiRSDependencyStructuralMatrix >> createLabelShapeY: aRSBox [

	^(super createLabelShapeY: aRSBox)
		popupText: [ :graphNode | graphNode model mooseName ] ;
		yourself
]

{ #category : #hooks }
MiRSDependencyStructuralMatrix >> createShape: tuple [
	"1halt."
	| weight |
	weight := self getTupleDependencyWeight: tuple.

	shape := MiRSDSMShape new
		text: (weight = 0 ifTrue: [''] ifFalse: [ weight asString]) ;
		color: (self color cull: tuple) ;
		model: tuple ;
		yourself.

	shape
		when: RSMouseDoubleClick do: [ self userActionOn: tuple] for: shape ;
		when: RSMouseEnter send: #highlight: to: self ;
		when: RSMouseLeave send: #unhighlight: to: self.

	^shape
]

{ #category : #accessing }
MiRSDependencyStructuralMatrix >> getTupleDependencyWeight: tuple [
	^ owner getTupleDependencyWeight: tuple
]

{ #category : #highlighting }
MiRSDependencyStructuralMatrix >> highlight: evt [
	"Probable bug in RSDSM: `super highlight: evt` draws the row and column with bold border
	 But the borders are shape that should not receive announcement (like mouseEnter/Leave for highlight/unhighlight"
	super highlight: evt.
	(self canvas canvas propertyAt: #columnRect) announcer: nil.
	(self canvas canvas propertyAt: #rowRect) announcer: nil.

	(owner sccShapesIncluding: evt shape) do: [ :aShape |
		aShape color: (owner cellShowSCCColor: aShape model)
	]
]

{ #category : #accessing }
MiRSDependencyStructuralMatrix >> owner [
	^ owner
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

{ #category : #'as yet unclassified' }
MiRSDependencyStructuralMatrix >> userActionOn: aTuple [
	
	self viewModel userActionOn: aTuple
]

{ #category : #accessing }
MiRSDependencyStructuralMatrix >> viewModel [
	^self owner viewModel.
]
