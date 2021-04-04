"
Shows UML of the received entities.

- Follow: Receives a TypeGroup or entities using TType.
- Highlight: Entities if present
- Propagate: The selected entity if there is one
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
		parent: (self toolbarFamixName);
		label: (self title);
		icon: (self iconNamed: #mooseUml);
		order: 4;
		help: (self helpMessage);
		action: [ self runMe ]
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

{ #category : #testing }
MiUMLBrowser >> accept: anObject [
	"can't use isType because it can be a MooseModel (that does not answer isType)"

	anObject isMooseObject
		ifFalse: [ ^ false ].
	^ (anObject isKindOf: FamixTypeGroup)
		or: [ anObject isOfType: FamixTType ]
]

{ #category : #actions }
MiUMLBrowser >> followAction [
	(self accept: toSelect)
		ifFalse: [ ^ self ].
	diagram
		rootEntities:
			((toSelect isKindOf: FamixTypeGroup)
				ifFalse: [ {toSelect} ]
				ifTrue: [ toSelect ]);
		run
]

{ #category : #actions }
MiUMLBrowser >> highlightAction [
	(self accept: toSelect)
		ifFalse: [ ^ self ].
	diagram
		highlightEntities:
			((toSelect isKindOf: FamixTypeGroup)
				ifFalse: [ {toSelect} ]
				ifTrue: [ toSelect ])
]

{ #category : #initialization }
MiUMLBrowser >> initializePresenters [
	super initializePresenters.
	diagram := self instantiate: MiUML
]

{ #category : #accessing }
MiUMLBrowser >> miSelectedItem [
	^ diagram selected
]
