"
A page in the MiDuplicationBrowser 'NoteBook', it display the content of an entity, highlighting its duplicated fragment
"
Class {
	#name : #MiDuplicationBrowserPage,
	#superclass : #SpNotebookPage,
	#instVars : [
		'replica'
	],
	#category : #'MooseIDE-Duplication'
}

{ #category : #'instance creation' }
MiDuplicationBrowserPage class >> forReplica: aReplica [

	^self new
		replica: aReplica ;
		yourself
		
]

{ #category : #private }
MiDuplicationBrowserPage >> formatReplicaText [

	| text highlightInterval |
	text := replica entity sourceText.
	highlightInterval := self linesToCharPos: (replica startLine to: replica endLine) in: text.
	^ text asText
		  addAttribute: (TextBackgroundColor color: self highlightingColor)
		  from: highlightInterval first
		  to: highlightInterval last;
		  yourself
]

{ #category : #accessing }
MiDuplicationBrowserPage >> highlightingColor [

	^ Color veryVeryLightGray
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
MiDuplicationBrowserPage >> intervalAsCharPos: lineInterval [
	"copied from FamixTFileNavigation >> #intervalAsCharPos"
	| start end index |
	index := 0.
	start := 1.
	end := 0.
	self completeText lineIndicesDo: [ :lineStart :lineEnd :y | 
		index := index + 1.
		self startLine = index ifTrue: [ start := lineStart ].
		self endLine = index ifTrue: [ end := lineEnd ] ].
	^ start to: end
]

{ #category : #private }
MiDuplicationBrowserPage >> linesToCharPos: lineInterval in: aString [

	"copied from FamixTFileNavigation >> #intervalAsCharPos"

	| start end index |
	index := 0.
	start := 1.
	end := 0.
	aString lineIndicesDo: [ :lineStart :lineEnd :y | 
		index := index + 1.
		lineInterval first = index ifTrue: [ start := lineStart ].
		lineInterval last = index ifTrue: [ end := lineEnd ] ].
	^ start to: end
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
