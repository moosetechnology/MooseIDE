"
Shows the source text of an entity if it has one.

- Follow: Receives a MooseEntity that uses FamixTSourceEntity.
- Highlight: Nothing to do.
- Propagate: <TODO>

<TODO> Improvement: tabs for several entities (receiving a MooseGroup)
"
Class {
	#name : #MiSourceTextBrowser,
	#superclass : #MiAbstractFamixBrowser,
	#instVars : [
		'sourceText'
	],
	#category : #'MooseIDE-Famix-SourceText'
}

{ #category : #specs }
MiSourceTextBrowser class >> defaultSpec [

	^ super defaultSpec
		  add: #sourceText;
		  yourself
]

{ #category : #'world menu' }
MiSourceTextBrowser class >> menuCommandOn: aBuilder [
	<worldMenu>
	<miBrowsers>
	(aBuilder item: #SourceTextBrowser)
		parent: (self toolbarFamixName) ;
		label: (self title) ;
		icon: (self iconNamed: #mooseSourceText);
		order: 1 ;
		help: (self helpMessage);
		action: [ self open ]
]

{ #category : #'instance creation' }
MiSourceTextBrowser class >> newModel [

	^ MiSourceTextBrowserModel new
]

{ #category : #'instance creation' }
MiSourceTextBrowser class >> open [
	<script>
	^ super open
]

{ #category : #specs }
MiSourceTextBrowser class >> title [
	^ 'Source code'
]

{ #category : #testing }
MiSourceTextBrowser >> canReceiveEntity: anObject [

	^ anObject usesFamixTrait: FamixTSourceEntity
]

{ #category : #actions }
MiSourceTextBrowser >> followEntity: anEntity [

	model selected: anEntity.
	self text: model sourceText.
	self updateWindowTitleWith: anEntity name
]

{ #category : #initialization }
MiSourceTextBrowser >> initializePresenters [

	sourceText := self newText
]

{ #category : #accessing }
MiSourceTextBrowser >> miSelectedItem [

	^ model selected
]

{ #category : #actions }
MiSourceTextBrowser >> text: aText [

	sourceText text: aText
]

{ #category : #actions }
MiSourceTextBrowser >> updateWindowTitleWith: aName [

	self withWindowDo: [ :window | 
		window title: self class title , ' of ' , aName ]
]
