Class {
	#name : 'MiSourceTextTIndexedFileAnchorAdapter',
	#superclass : 'MiAbstractSourceTextAnchorAdapter',
	#category : 'MooseIDE-Famix-SourceText',
	#package : 'MooseIDE-Famix',
	#tag : 'SourceText'
}

{ #category : 'as yet unclassified' }
MiSourceTextTIndexedFileAnchorAdapter class >> acceptEntity: anEntity [

	^anEntity sourceAnchor
		ifNil: [ false ]
		ifNotNil: [ :anchor | anchor class usesTrait: FamixTIndexedFileNavigation ]
]

{ #category : 'api' }
MiSourceTextTIndexedFileAnchorAdapter >> initialBoundingPos: anEntity [

	anEntity ifNil: [ ^nil ].
	anEntity sourceAnchor ifNil: [ ^nil ].

	^self reOffset: anEntity sourceAnchor startPos
]

{ #category : 'api' }
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

{ #category : 'api' }
MiSourceTextTIndexedFileAnchorAdapter >> intervalForEntity: anEntity [
	"First find from where to start searching in the displayed code,
	 This will be from the first position of anEntity.
	 then search for first occurence of anEntity's name after this point"

	(anEntity class usesFamixTrait: FamixTComment)
	ifTrue: [ ^ self intervalForComment: anEntity ].

	^(self initialBoundingPos: anEntity sourceCodeBoundingEntity)
		ifNotNil: [ :initialPos |
			self
				intervalForWord: anEntity stringToHighlight
				after: initialPos
		]
]

{ #category : 'api' }
MiSourceTextTIndexedFileAnchorAdapter >> intervalForWord: aString after: afterPos [
	"searches for aString as a full word ('\W' means wordBoundary)
	 ifFound, `matcher position` gives the end of the match (including the word boundary)
	 Matching position is relative to afterPos, so should add that for position in the displayedText
	 - interval start=matcher position + starting search position - aString length"

	| matcher searchInString offset |

	searchInString := (displayedText asString copyFrom: afterPos to: displayedText size).

	matcher := RxMatcher forString: ('\W' , aString , '\W').
	matcher search: searchInString.

	^(matcher subexpression: 1)
		ifNil: [ nil ]
		ifNotNil: [ :subexp |
			offset := afterPos -1.
			Interval
				from: (matcher position + offset - aString size)
				to: (matcher position + offset - 1) ]

]

{ #category : 'api' }
MiSourceTextTIndexedFileAnchorAdapter >> reOffset: aPosition [
	"convert aPosition in source file to a position in displayedTextS"

	^aPosition - (displayedEntityInterval key sourceAnchor startPos) + 1
]
