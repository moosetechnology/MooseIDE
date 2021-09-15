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
	#category : #'MooseIDE-Famix-UML'
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
		action: [ self open ]
]

{ #category : #specs }
MiUMLBrowser class >> open [
	<script>
	^ super open
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

{ #category : #testing }
MiUMLBrowser >> canHighlight [

	^ true
]

{ #category : #actions }
MiUMLBrowser >> followEntity: anEntity [

	diagram
		rootEntities: anEntity asMooseGroup specialize;
		run
]

{ #category : #actions }
MiUMLBrowser >> highlightEntity: anEntity [

	diagram highlightEntities: anEntity asCollection
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
