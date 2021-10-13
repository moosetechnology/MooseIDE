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
	#category : #'MooseIDE-Dependency-Tree'
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
		action: [ self open ]
]

{ #category : #specs }
MiTreeVisualisationBrowser class >> open [
	<script>
	^ super open
]

{ #category : #'as yet unclassified' }
MiTreeVisualisationBrowser class >> title [
	^ 'Tree Visualisation'
]

{ #category : #testing }
MiTreeVisualisationBrowser >> canHighlight [

	^ true
]

{ #category : #testing }
MiTreeVisualisationBrowser >> canReceiveEntity: anEntity [

	^ anEntity isMooseObject and: [ self needUpdate: anEntity ]
]

{ #category : #actions }
MiTreeVisualisationBrowser >> followEntity: anEntity [

	diagram entities: anEntity asMooseGroup.
	diagram
		unHighlight;
		run
]

{ #category : #actions }
MiTreeVisualisationBrowser >> highlightEntity: anEntity [

	diagram highlightEntities: anEntity asCollection
]

{ #category : #initialization }
MiTreeVisualisationBrowser >> initializePresenters [

	diagram := self instantiate: MiTreeVisualisation
]

{ #category : #accessing }
MiTreeVisualisationBrowser >> miSelectedItem [
	^ diagram selected
]

{ #category : #testing }
MiTreeVisualisationBrowser >> needUpdate: anEntity [

	^ anEntity ~= diagram selected
]
