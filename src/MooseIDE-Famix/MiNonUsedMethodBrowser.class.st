"
Shows dead methods contained in an entity.

- Follow: Receives a MooseEntity.
- Highlight: <TODO> Methods if present.
- Propagate: <TODO>
"
Class {
	#name : #MiNonUsedMethodBrowser,
	#superclass : #MiAbstractFamixBrowser,
	#instVars : [
		'diagram',
		'view'
	],
	#category : #'MooseIDE-Famix-SourceText'
}

{ #category : #specs }
MiNonUsedMethodBrowser class >> defaultSpec [
	^ super defaultSpec
		add: #diagram;
		yourself
]

{ #category : #specs }
MiNonUsedMethodBrowser class >> launchOn: anObject [
	^ self new
		selected: anObject;
		openWithSpec
]

{ #category : #specs }
MiNonUsedMethodBrowser class >> menuCommandOn: aBuilder [
	<worldMenu>
	<miBrowsers>
	(aBuilder item: #NonUsedMethodBrowser)
		parent: (self toolbarFamixName);
		label: (self title);
		order: 2;
		help: (self helpMessage);
		action: [ self open ]
]

{ #category : #'instance creation' }
MiNonUsedMethodBrowser class >> newModel [

	^ MiNonUsedFunctionBrowserModel new
]

{ #category : #specs }
MiNonUsedMethodBrowser class >> open [
	<script>
	^ super open
]

{ #category : #TOREMOVE }
MiNonUsedMethodBrowser class >> title [
	^ 'Dead methods'
]

{ #category : #testing }
MiNonUsedMethodBrowser >> canReceiveEntity: anEntity [

	^ (anEntity usesFamixTrait: FamixTWithMethods) and: [ 
		  self needUpdate: anEntity ]
]

{ #category : #actions }
MiNonUsedMethodBrowser >> followEntity: anEntity [

	model container: anEntity.
	self updateToolbar.
	self updateWindowTitleWith: anEntity name.
	diagram run.
	self update "This is so the canvas *actually* zoomToFit. Weird that we need it"
]

{ #category : #initialization }
MiNonUsedMethodBrowser >> initializePresenters [

	diagram := self instantiate: MiNonUsedMethodVisualization
]

{ #category : #accessing }
MiNonUsedMethodBrowser >> miSelectedItem [

	^ model deadMethods
]

{ #category : #testing }
MiNonUsedMethodBrowser >> needUpdate: anEntity [

	^ anEntity ~= model container
]

{ #category : #actions }
MiNonUsedMethodBrowser >> updateWindowTitleWith: aName [

	self withWindowDo: [ :window | 
		window title: self class title , ' in ' , aName ]
]
