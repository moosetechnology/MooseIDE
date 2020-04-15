Class {
	#name : #MiUMLBrowser,
	#superclass : #MiAbstractFamixBrowser,
	#instVars : [
		'diagram'
	],
	#category : #'Midas-Famix-UML'
}

{ #category : #specs }
MiUMLBrowser class >> defaultSpec [
	^ super defaultSpec
		add: #diagram;
		yourself
]

{ #category : #specs }
MiUMLBrowser class >> menuCommandOn: aBuilder [
	<worldMenu>
	(aBuilder item: #UMLVisualisationBrowser)
		parent: self toolbarFamixName;
		label: 'UML Visualisation browser';
		icon: (self iconNamed: #mooseUml);
		order: 4.0;
		action: [ self runMe ]
]

{ #category : #specs }
MiUMLBrowser class >> runMe [
	<script>
	self new openWithSpec
]

{ #category : #accessing }
MiUMLBrowser >> accept: anObject [
	^ (anObject isKindOf: FamixTypeGroup) or: [ anObject isType ]
]

{ #category : #accessing }
MiUMLBrowser >> diagram [
	^ diagram
]

{ #category : #accessing }
MiUMLBrowser >> followAction [
	(self accept: toSelect)
		ifFalse: [ ^ self ].
	(toSelect isKindOf: FAMIXTypeGroup)
		ifFalse: [ self model rootEntities: {toSelect} ]
		ifTrue: [ self model rootEntities: toSelect ].
	self refresh
]

{ #category : #accessing }
MiUMLBrowser >> initializePresenters [
	super initializePresenters.
	self model: (MiUML new theme: self theme).
	diagram := self instantiate: SpRoassalPresenter.
	diagram
		script: [ :canvas | 
			canvas color: self theme backgroundColor.
			self model canvas: canvas ]
]

{ #category : #accessing }
MiUMLBrowser >> refresh [
	self diagram refresh.
	self model run.
]

{ #category : #TOREMOVE }
MiUMLBrowser >> title [
	^ 'UML Browser'
]
