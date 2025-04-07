Class {
	#name : #MiRSDSM,
	#superclass : #RSDSM,
	#instVars : [
		'owner',
		'menuInteraction'
	],
	#category : #'MooseIDE-Dependency-DSM'
}

{ #category : #hooks }
MiRSDSM >> cellMenu [
	^menuInteraction ifNil: [
		menuInteraction := RSMenuActivable new
			menuDo: [ :menu :cell |
				menu
					add: 'Dependencies'
					target: [ self listTupleDependencies: cell model ]
					selector: #value
			]
	]
]

{ #category : #'hooks - labels' }
MiRSDSM >> createLabelShapeX: aRSBox [

	^(super createLabelShapeX: aRSBox)
		popupText: [ :graphNode | graphNode model mooseName ] ;
		yourself
]

{ #category : #'hooks - labels' }
MiRSDSM >> createLabelShapeY: aRSBox [

	^(super createLabelShapeY: aRSBox)
		popupText: [ :graphNode | graphNode model mooseName ] ;
		yourself
]

{ #category : #hooks }
MiRSDSM >> createShape: tuple [

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
	shape @ self cellMenu.

	^shape
]

{ #category : #accessing }
MiRSDSM >> getTupleDependencyWeight: tuple [
	^ owner getTupleDependencyWeight: tuple
]

{ #category : #highlighting }
MiRSDSM >> highlight: evt [
	"Probable bug in RSDSM: `super highlight: evt` draws the row and column with bold border
	 But the borders are shapes that should not receive announcement (like mouseEnter/Leave for highlight/unhighlight"

	super highlight: evt.
	(self canvas canvas propertyAt: #columnRect) announcer: nil.
	(self canvas canvas propertyAt: #rowRect) announcer: nil.

	(owner sccShapesIncluding: evt shape) do: [ :aShape |
		aShape color: (owner cellShowSCCColor: aShape model)
	]
]

{ #category : #accessing }
MiRSDSM >> owner [
	^ owner
]

{ #category : #accessing }
MiRSDSM >> owner: anObject [

	owner := anObject
]

{ #category : #accessing }
MiRSDSM >> specModel [
	^self owner specModel.
]

{ #category : #highlighting }
MiRSDSM >> unhighlight: evt [

	super unhighlight: evt.

	(owner sccShapesIncluding: evt shape) do: [ :aShape |
		aShape color: (owner cellColor: aShape model)
	]
]

{ #category : #'as yet unclassified' }
MiRSDSM >> userActionOn: aTuple [
	
	self specModel userActionOn: aTuple
]
