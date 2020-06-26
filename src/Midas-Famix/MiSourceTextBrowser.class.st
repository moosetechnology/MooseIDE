"
Displays the source text of entities if they have one.

Follow: 
recives a MooseEntity and displays its source text.

Highlight:
does nothing.

Possible improvement: tabs for several entities (receiving a MooseGroup)
"
Class {
	#name : #MiSourceTextBrowser,
	#superclass : #MiAbstractFamixBrowser,
	#instVars : [
		'sourceText',
		'noteBook',
		'sourceCodePage'
	],
	#category : #'Midas-Famix-SourceText'
}

{ #category : #specs }
MiSourceTextBrowser class >> defaultSpec [
	^ super defaultSpec
		add: #noteBook;
		yourself
]

{ #category : #specs }
MiSourceTextBrowser class >> menuCommandOn: aBuilder [
	<worldMenu>
	(aBuilder item: #SourceTextBrowser)
		parent: self toolbarFamixName;
		label: self title;
		icon: (self iconNamed: #mooseSourceText);
		order: 1.0;
		action: [ self runMe ]
]

{ #category : #specs }
MiSourceTextBrowser class >> runMe [
	<script>
	^ super runMe
]

{ #category : #'as yet unclassified' }
MiSourceTextBrowser class >> title [
	^ 'Source code'
]

{ #category : #'as yet unclassified' }
MiSourceTextBrowser >> accept: anObject [
	^ anObject usesFamixTrait: FamixTSourceEntity
]

{ #category : #'as yet unclassified' }
MiSourceTextBrowser >> entityName: aString [
	sourceCodePage title: aString , ' source code'
]

{ #category : #'as yet unclassified' }
MiSourceTextBrowser >> followAction [
	(self accept: toSelect)
		ifFalse: [ ^ self ].
	model selected: toSelect.
	self updateCode
]

{ #category : #'as yet unclassified' }
MiSourceTextBrowser >> initializePresenters [
	super initializePresenters.
	model := MiSourceTextBrowserModel new.
	sourceText := self newText.
	noteBook := self newNotebook.
	self sourceCodePage.
	noteBook addPage: sourceCodePage
]

{ #category : #'as yet unclassified' }
MiSourceTextBrowser >> sourceCodePage [
	sourceCodePage := SpNotebookPage
		title: 'Source code'
		icon: (self iconNamed: #nautilusIcon)
		provider: [ sourceText ]
]

{ #category : #'as yet unclassified' }
MiSourceTextBrowser >> text: aText [
  sourceText text: aText
]

{ #category : #'as yet unclassified' }
MiSourceTextBrowser >> updateCode [
	self text: model sourceText.
	self entityName: model selected name
]
