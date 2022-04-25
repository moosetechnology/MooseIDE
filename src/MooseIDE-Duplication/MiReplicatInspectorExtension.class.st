"
An extension to the Moose Inspector to visualize code clones
"
Class {
	#name : #MiReplicatInspectorExtension,
	#superclass : #SpPresenter,
	#instVars : [
		'sourceText',
		'properties',
		'replica'
	],
	#category : #'MooseIDE-Duplication'
}

{ #category : #private }
MiReplicatInspectorExtension >> highlightedReplicaText [
	| text start end |

	text := replica entity sourceText asText.
	start := self lineStart: (replica startLine) in: text.
	end := self lineStart: (replica endLine + 1) in: text.
	text
		addAttribute: (TextBackgroundColor color: Color yellow lighter lighter)
		from: start
		to: end.
	^text
]

{ #category : #initialization }
MiReplicatInspectorExtension >> initializeLayout [
	self layout: (SpBoxLayout newTopToBottom
		add: #properties height: (self propertyTableHeight);
		add: #sourceText ;
		yourself)

]

{ #category : #initialization }
MiReplicatInspectorExtension >> initializePresenters [
	properties := self newTable.
	properties
		items: {
		'Fragment' -> [ :rep | rep replicatedFragment fragmentName ] .
		'Entity' -> #entity .
		'Start line' -> #startLine .
		'End line'   -> #endLine }.
	properties
		addColumn: ( (SpStringTableColumn title: 'Prop.' evaluated: #key) width: 50 );
		addColumn: (SpStringTableColumn title: 'Value' evaluated: [:prop | prop value value: replica]).

	sourceText := self newCode
		withoutSyntaxHighlight ;
		withLineNumbers ;
		text: (self highlightedReplicaText).
	self flag: 'Can t get the presenter to show highlighted code :-('.
	self initializeLayout .
]

{ #category : #private }
MiReplicatInspectorExtension >> lineStart: line in: text [
	| i pos |
	i := 1.
	pos := 1.
	text string lines do: [ :string | 
		(i < line) ifTrue: [ pos := pos + string size + 1 ].
		i := i + 1.
	].
	^pos > text size ifTrue: [ text size ] ifFalse: [ pos ]
]

{ #category : #accessing }
MiReplicatInspectorExtension >> propertyTableHeight [
	^self class toolbarHeight *4
]

{ #category : #initialization }
MiReplicatInspectorExtension >> setModelBeforeInitialization: aDomainObject [
	replica := aDomainObject 
]
