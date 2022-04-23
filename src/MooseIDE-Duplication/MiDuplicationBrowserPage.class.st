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
MiDuplicationBrowserPage >> findLinePos: lineNumber in: aString [

	| pos currentLine |
	pos := 1.
	currentLine := 0.
	aString lines do: [ :aLine | 
		currentLine := currentLine + 1.
		currentLine < lineNumber
			ifTrue: [ pos := pos + aLine size + 1 ]
			ifFalse: [ ^ pos ] ].
	^ pos
]

{ #category : #private }
MiDuplicationBrowserPage >> formatReplicaText [

	| text highlightStart highlightEnd |
	text := replica entity sourceText.
	highlightStart := self highlightingStart: text.
	highlightEnd := self highlightingEnd: text.
	^ text asText
		  addAttribute: (TextBackgroundColor color: self highlightingColor)
		  from: highlightStart
		  to: highlightEnd;
		  yourself
]

{ #category : #accessing }
MiDuplicationBrowserPage >> highlightingColor [

	^ Color veryVeryLightGray
]

{ #category : #private }
MiDuplicationBrowserPage >> highlightingEnd: aText [
	"search for pos of next line and remove one character (end-of-line)"
	^ (self findLinePos: replica endLine + 1 in: aText) - 1
]

{ #category : #private }
MiDuplicationBrowserPage >> highlightingStart: aText [
	^self findLinePos: replica startLine in: aText
]

{ #category : #initialization }
MiDuplicationBrowserPage >> initialize [

	super initialize.

	self beCloseable.
	self presenterProvider: [ SpTextPresenter new
			text: self textContent ;
			yourself ]
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
