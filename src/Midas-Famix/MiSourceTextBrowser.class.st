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
	^ SpBoxLayout newHorizontal
		add: #noteBook;
		yourself
]

{ #category : #specs }
MiSourceTextBrowser class >> menuCommandOn: aBuilder [
	<worldMenu>
	(aBuilder item: #SourceTextBrowser)
		parent: self toolbarFamixName;
		label: 'SourceText browser';
		action: [ self runMe ]
]

{ #category : #specs }
MiSourceTextBrowser class >> runMe [
	<script>
	self new openWithSpec
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
MiSourceTextBrowser >> initializePresenters [
	model := MiSourceTextBrowserModel new.
	sourceText := self newText.
	noteBook := self newNotebook.
	self sourceCodePage.
	noteBook addPage: sourceCodePage
]

{ #category : #'as yet unclassified' }
MiSourceTextBrowser >> selectEntity: anEntity [
	(self accept: anEntity)
		ifFalse: [ ^ self ].
	model selected: anEntity.
	self updateCode
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
MiSourceTextBrowser >> title [
	^ 'Source code Browser'
]

{ #category : #'as yet unclassified' }
MiSourceTextBrowser >> updateCode [
	self text: model sourceText.
	self entityName: model selected name
]
