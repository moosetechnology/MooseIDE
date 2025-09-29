"
A page in the MiDuplicationBrowser 'NoteBook', it display the content of an entity, highlighting its duplicated fragment
"
Class {
	#name : #MiDuplicationBrowserPage,
	#superclass : #SpNotebookPage,
	#instVars : [
		'replica',
		'text'
	],
	#category : #'MooseIDE-Duplication'
}

{ #category : #'instance creation' }
MiDuplicationBrowserPage class >> forReplica: aReplica [

	^self new
		replica: aReplica ;
		yourself
		
]

{ #category : #formatting }
MiDuplicationBrowserPage >> backgroundColor: aColor at: anInterval [

	text
		addAttribute: (TextBackgroundColor color: aColor)
		from: anInterval first
		to: anInterval last.
 
]

{ #category : #formatting }
MiDuplicationBrowserPage >> formatReplicaText [

	text := Text streamContents: [ :stream |
		stream
			<< replica entity mooseName ;
			cr ;
			<< replica entity sourceText
	].

	self formatTitle.

	replica entity replicas do: [:cloneToShow |
		(cloneToShow = replica)
		ifFalse: [ self highlightClone: cloneToShow color: self otherCloneColor ]
	].

	self highlightClone: replica color: self mainCloneColor.

	^text
]

{ #category : #formatting }
MiDuplicationBrowserPage >> formatTitle [

	| titleInterval |
	titleInterval := 1 to: replica entity mooseName size.

	text
		addAttribute: (TextEmphasis underlined)
		from: titleInterval first
		to: titleInterval last.
 
	self backgroundColor: self titleColor at: titleInterval
]

{ #category : #formatting }
MiDuplicationBrowserPage >> highlightClone: clone color: aColor [
	"computes first and last character position of the clone"

	self
		backgroundColor: aColor
		at: (self linesToCharPos: (clone startLine to: clone endLine))
]

{ #category : #initialization }
MiDuplicationBrowserPage >> initialize [

	super initialize.

	self beCloseable.
	self presenterProvider: [
		SpMorphPresenter new 
        morph: (RubScrolledTextMorph new 
            setText: self textContent;
            in: [ :this | this textArea readOnly: true ];
            yourself);
        yourself ]
]

{ #category : #private }
MiDuplicationBrowserPage >> linesToCharPos: lineInterval [

	"copied from FamixTFileNavigation >> #intervalAsCharPos
	must ignore the first line which is a kind of title (see #formatReplicaText)"

	| start lineNumber |
	lineNumber := -1. "so that first line is ignored in first 'loop iteration' "
	start := 1.
	text asString lineIndicesDo: [ :lineStart :lineEnd :ignore | 
		lineNumber := lineNumber + 1.
		lineInterval first = lineNumber ifTrue: [ start := lineStart ].
		lineInterval last = lineNumber ifTrue: [ ^start to: lineEnd ] ].
	^ start to: text size
]

{ #category : #accessing }
MiDuplicationBrowserPage >> mainCloneColor [

	^ Color lightYellow lighter
]

{ #category : #accessing }
MiDuplicationBrowserPage >> otherCloneColor [

	^ Color veryVeryLightGray
]

{ #category : #accessing }
MiDuplicationBrowserPage >> replica: aReplica [
	replica := aReplica.
	self title: aReplica entity name.

]

{ #category : #private }
MiDuplicationBrowserPage >> textContent [

	^ replica ifNil: [ '** no source code found**' ] ifNotNil: [ self formatReplicaText ]
]

{ #category : #accessing }
MiDuplicationBrowserPage >> titleColor [
	"same blue as used in pharo for text selection"

	^Color fromHexString: 'afd5fa'
]
