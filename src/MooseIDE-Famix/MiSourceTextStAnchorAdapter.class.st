"
For FamixStEntities the StSourceAnchor contains very little information and the sourceText comes from the entity itself
"
Class {
	#name : #MiSourceTextStAnchorAdapter,
	#superclass : #MiAbstractSourceTextAnchorAdapter,
	#category : #'MooseIDE-Famix-SourceText'
}

{ #category : #'as yet unclassified' }
MiSourceTextStAnchorAdapter class >> acceptedEntities [

	^{ FamixStClass . FamixStMethod }
]

{ #category : #'as yet unclassified' }
MiSourceTextStAnchorAdapter >> initialBoundingPos: anEntity [

	| boundingInterval |

	anEntity ifNil: [ ^nil ].

	boundingInterval := self intervalForString: anEntity displayedNameInMiSourceText after: 1.
	^(boundingInterval = 0)
		ifTrue: [ nil ]
		ifFalse: [ boundingInterval first]
]

{ #category : #'as yet unclassified' }
MiSourceTextStAnchorAdapter >> intervalForEntity: anEntity [
	"First tries to see if anEntity is the displayedEntity (and then we already have its interval)
	 else find the intervak for entity owning anEntity,
	 then search for anEntity in these bounds"

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
