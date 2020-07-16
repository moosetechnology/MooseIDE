"
Shows UML of the received entities.

- Follow: 
Receives a TypeGroup or entities using TType.

- Highlight: 
<TODO>

- Propagate: 
<TODO>
"
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
	<miBrowsers>
	(aBuilder item: #UMLVisualisationBrowser)
		parent: self toolbarFamixName;
		label: self title;
		icon: (self iconNamed: #mooseUml);
		order: 4.0;
		help: self helpMessage;
		action: [ self runMe ]
]

{ #category : #accessing }
MiUMLBrowser class >> newModel [
	^ MiUML new theme: self theme
]

{ #category : #specs }
MiUMLBrowser class >> runMe [
	<script>
	^ super runMe
]

{ #category : #TOREMOVE }
MiUMLBrowser class >> title [
	^ 'UML'
]

{ #category : #accessing }
MiUMLBrowser >> accept: anObject [
	"can't use isType because it can be a MooseModel (that does not answer isType)"

	anObject isMooseObject
		ifFalse: [ ^ false ].
	^ (anObject isKindOf: FamixTypeGroup)
		or: [ anObject isOfType: FamixTType ]
]

{ #category : #accessing }
MiUMLBrowser >> diagram [
	^ diagram
]

{ #category : #accessing }
MiUMLBrowser >> followAction [
	(self accept: toSelect)
		ifFalse: [ ^ self ].
	(toSelect isKindOf: FamixTypeGroup)
		ifFalse: [ self model rootEntities: {toSelect} ]
		ifTrue: [ self model rootEntities: toSelect ].
	self refresh
]

{ #category : #accessing }
MiUMLBrowser >> initializePresenters [
	super initializePresenters.
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
