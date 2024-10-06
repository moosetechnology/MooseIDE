Class {
	#name : #MiSourceTextTIndexedFileAnchorAdapter,
	#superclass : #MiAbstractSourceTextAnchorAdapter,
	#category : #'MooseIDE-Famix-SourceText'
}

{ #category : #'as yet unclassified' }
MiSourceTextTIndexedFileAnchorAdapter class >> acceptedEntities [

	^{ FamixJavaClass . FamixJavaMethod }
]

{ #category : #api }
MiSourceTextTIndexedFileAnchorAdapter >> initialBoundingPos: anEntity [

	anEntity ifNil: [ ^nil ].
	anEntity sourceAnchor ifNil: [ ^nil ].

	^self reOffset: anEntity sourceAnchor startPos
]

{ #category : #api }
MiSourceTextTIndexedFileAnchorAdapter >> intervalForComment: anEntity [
	"Some comments do not have 'content', but only a sourceAnchor,
	 for them, return this sourceAnchor relocalized in the owner's displayedText
	 Also, classes may have for child a comment appearing before them,
	 Since it is not displayed, we ignore it"

	anEntity sourceAnchor
		ifNotNil: [ :anchor || interval |
			interval := Interval
				from: (self reOffset: anchor startPos)
				to:   (self reOffset: anchor endPos).

			^(interval first > 0) ifTrue: [ interval ] ifFalse: [ nil ]
		]
]

{ #category : #api }
MiSourceTextTIndexedFileAnchorAdapter >> intervalForEntity: anEntity [
	"First find from where to start searching in the displayed code,
	 This will be from the first position of anEntity.
	 then search for first occurence of anEntity's name after this point"

	(anEntity class usesFamixTrait: FamixTComment)
	ifTrue: [ (self intervalForComment: anEntity) 
		ifNotNil: [ :interval | ^interval ]
	].

	^(self initialBoundingPos: anEntity sourceCodeBoundingEntity)
		ifNotNil: [ :initialPos |
			self
				intervalForString: anEntity stringToHighlight
				after: initialPos
		]
]

{ #category : #api }
MiSourceTextTIndexedFileAnchorAdapter >> intervalForString: aString after: afterPos [

	| intervalStart |
	intervalStart := displayedText findString: aString startingAt: afterPos.

	^(intervalStart = 0)
		ifTrue: [ nil ]
		ifFalse: [Interval
			from: intervalStart
			to: (intervalStart + aString size - 1) ]

]

{ #category : #api }
MiSourceTextTIndexedFileAnchorAdapter >> reOffset: aPosition [
	"convert aPosition in source file to a position in displayedTextS"

	^aPosition - (displayedEntityInterval key sourceAnchor startPos) + 1
]
