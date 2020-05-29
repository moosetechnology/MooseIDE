"
A browser to show the content of the MiLogger
"
Class {
	#name : #MiLogBrowser,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'entryList'
	],
	#category : #'Midas-Core-Browser'
}

{ #category : #'world menu' }
MiLogBrowser class >> defaultSpec [
	^ super defaultSpec
		add: #entryList;
		yourself
]

{ #category : #'world menu' }
MiLogBrowser class >> menuCommandOn: aBuilder [
	<worldMenu>
	(aBuilder item: #Logger)
		parent: self toolbarName;
		label: 'Log browser';
		order: 1.0;
		action: [ self runMe ]
]

{ #category : #'world menu' }
MiLogBrowser class >> runMe [
	<script>
	^ self new
		openWithSpec;
		yourself

]

{ #category : #testing }
MiLogBrowser >> accept: anObject [
	^ true
]

{ #category : #actions }
MiLogBrowser >> followAction [
	entryList updateList
]

{ #category : #initialization }
MiLogBrowser >> initializePresenters [
	super initializePresenters.
	entryList := self newList.
	self model: self application logger.
	entryList items: self model logs.
	entryList whenSelectionChangedDo: [ :selection | self globallySelect: self miSelectedItem ]
]

{ #category : #accessing }
MiLogBrowser >> logger [
	^ self application logger
]

{ #category : #initialization }
MiLogBrowser >> miSelectedItem [
	^ entryList selectedItems ifEmpty: [ super miSelectedItem ] ifNotEmpty: [ :list | "We can select only one entity" list anyOne entity ]
]

{ #category : #initialization }
MiLogBrowser >> title [
	^ 'Logger Browser'
]
