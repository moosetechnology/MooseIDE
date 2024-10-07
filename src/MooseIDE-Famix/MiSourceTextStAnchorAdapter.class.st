"
For FamixStEntities the StSourceAnchor contains very little information and the sourceText comes from the entity itself
"
Class {
	#name : #MiSourceTextStAnchorAdapter,
	#superclass : #MiAbstractSourceTextAnchorAdapter,
	#category : #'MooseIDE-Famix-SourceText'
}

{ #category : #'as yet unclassified' }
MiSourceTextStAnchorAdapter class >> acceptEntity: anEntity [

	^anEntity class name beginsWith: 'FamixSt'
]

{ #category : #'as yet unclassified' }
MiSourceTextStAnchorAdapter >> initialBoundingPos: anEntity [

	| boundingInterval |

	anEntity ifNil: [ ^nil ].

	boundingInterval := self intervalForString: anEntity displayedNameInMiSourceText after: 1.
	boundingInterval ifNil: [ ^nil ].
	(boundingInterval = 0) ifTrue: [ ^nil ].
	^boundingInterval first
]

{ #category : #'as yet unclassified' }
MiSourceTextStAnchorAdapter >> intervalForEntity: anEntity [
	"First find from where to start searching in the code,
	 This will be from the first position of the entity owning anEntity.
	 then search for first occurence of anEntity after this point"

	^(self initialBoundingPos: anEntity sourceCodeBoundingEntity)
		ifNotNil: [ :initialPos |
			self
				intervalForString: anEntity stringToHighlight
				after: initialPos
		]
]

{ #category : #formatting }
MiSourceTextStAnchorAdapter >> intervalForString: aString after: afterPos [

	| intervalStart |
	intervalStart := displayedText
		findString: aString
		startingAt: afterPos.

	^(intervalStart = 0)
		ifTrue: [ nil ]
		ifFalse: [Interval
			from: intervalStart
			to: (intervalStart + aString size - 1) ]

]
