"
A MooseIDE browser showing a DSM (Dependency Structural Matrix)
"
Class {
	#name : #MiDSMBrowser,
	#superclass : #MiAbstractDependencyBrowser,
	#instVars : [
		'diagram'
	],
	#category : #'MooseIDE-Dependency-DSM'
}

{ #category : #specs }
MiDSMBrowser class >> defaultLayout [

	^ super defaultLayout
		  add: #diagram;
		  yourself
]

{ #category : #'world menu' }
MiDSMBrowser class >> menuCommandOn: aBuilder [
	<worldMenu>
	<miBrowsers>
	(aBuilder item: #DSMVisualisationBrowser)
		parent: self toolbarDependencyName;
		label: self title;
		order: 0;
		icon: (self iconNamed: #mooseTree);
		help: self helpMessage;
		action: [ self open ]
]

{ #category : #'instance creation' }
MiDSMBrowser class >> newModel [
	^MiDSMBrowserModel new
]

{ #category : #'instance creation' }
MiDSMBrowser class >> open [

	<script>
	^ super open
]

{ #category : #specs }
MiDSMBrowser class >> title [

	^ 'DSM'
]

{ #category : #api }
MiDSMBrowser >> buildDSM [
	diagram run
]

{ #category : #testing }
MiDSMBrowser >> canFollowEntity: anObject [

	^model canFollowEntity: anObject
]

{ #category : #testing }
MiDSMBrowser >> canHighlight [

	^ true
]

{ #category : #accessing }
MiDSMBrowser >> diagram [

	^ diagram
]

{ #category : #actions }
MiDSMBrowser >> followEntity: anEntity [
	model followEntity: anEntity
]

{ #category : #actions }
MiDSMBrowser >> highlightEntity: anEntity [

	model highlightEntity: anEntity
]

{ #category : #initialization }
MiDSMBrowser >> initializePresenters [

	diagram := self instantiate: MiDSMVisualization.
	diagram model: model
]

{ #category : #accessing }
MiDSMBrowser >> miSelectedItem [

	^model selectedEntities
]

{ #category : #'accessing - model' }
MiDSMBrowser >> setModelBeforeInitialization: aModel [
	super setModelBeforeInitialization: aModel.
	aModel browser: self
]
