"
A browser to show the content of the MiLogger
"
Class {
	#name : #MiLoggerBrowser,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'entryList'
	],
	#category : #'Midas-Core-Logger'
}

{ #category : #'world menu' }
MiLoggerBrowser class >> defaultSpec [
	^ super defaultSpec
		add: #entryList;
		yourself
]

{ #category : #'world menu' }
MiLoggerBrowser class >> menuCommandOn: aBuilder [
	<worldMenu>
	(aBuilder item: #Logger)
		parent: self toolbarName;
		label: 'Log browser';
		order: 1.0;
		action: [ self runMe ]
]

{ #category : #'world menu' }
MiLoggerBrowser class >> runMe [
	<script>
	^ self new
		openWithSpec;
		yourself

]

{ #category : #testing }
MiLoggerBrowser >> accept: anObject [
	^ true
]

{ #category : #actions }
MiLoggerBrowser >> followAction [
	entryList updateList
]

{ #category : #initialization }
MiLoggerBrowser >> initializePresenters [
	super initializePresenters.
	entryList := self newList .
	self model: self application logger.
	entryList items: self model logs.

]
