"
Shows the containment tree (direct relations for now) between entities, as a roassal visualization.

- Follow: Receives a MooseGroup.
- Highlight: Entities if present.
- Propagate: The selected entity if there is one.
"
Class {
	#name : #MiTreeVisualisationBrowser,
	#superclass : #MiAbstractDependencyBrowser,
	#instVars : [
		'diagram'
	],
	#category : #'Midas-Dependency-Tree'
}

{ #category : #specs }
MiTreeVisualisationBrowser class >> defaultSpec [
	^ super defaultSpec
		add: #diagram;
		yourself
]

{ #category : #specs }
MiTreeVisualisationBrowser class >> menuCommandOn: aBuilder [
	<worldMenu>
	<miBrowsers>
	(aBuilder item: #TreeVisualisationBrowser)
		parent: self toolbarDependencyName;
		label: self title;
		order: 2.0;
		icon: (self iconNamed: #mooseTree);
		help: self helpMessage;
		action: [ self runMe ]
]

{ #category : #specs }
MiTreeVisualisationBrowser class >> runMe [
	<script>
	^ super runMe
]

{ #category : #'as yet unclassified' }
MiTreeVisualisationBrowser class >> title [
	^ 'Tree Visualisation'
]

{ #category : #testing }
MiTreeVisualisationBrowser >> accept: anObject [
	^ anObject isMooseObject
]

{ #category : #actions }
MiTreeVisualisationBrowser >> followAction [
	((self accept: toSelect) and: [ toSelect ~= diagram selected ])
		ifFalse: [ ^ self ].
	(toSelect isOfType: MooseGroup)
		ifTrue: [ diagram entities: toSelect ]
		ifFalse: [ diagram entities: {toSelect} ].
	diagram
		unHighlight;
		run
]

{ #category : #actions }
MiTreeVisualisationBrowser >> highlightAction [
	(toSelect isOfType: MooseGroup)
		ifFalse: [ toSelect := {toSelect} ].
	diagram highlightEntities: toSelect
]

{ #category : #initialization }
MiTreeVisualisationBrowser >> initializePresenters [
	super initializePresenters.
	diagram := self instantiate: MiTreeVisualisation
]

{ #category : #accessing }
MiTreeVisualisationBrowser >> miSelectedItem [
	^ diagram selected
]
