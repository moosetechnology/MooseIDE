"
Shows the containment (direct relations for now) between entities.
Dynamic presentation: clicking on an entity shows the entities it contains.

- Follow: Receives MooseObjects.
- Highlight: Entities if present.
- Propagate: <TODO>
"
Class {
	#name : #MiTreeMapVisualisationBrowser,
	#superclass : #MiAbstractDependencyBrowser,
	#instVars : [
		'diagram'
	],
	#category : #'Midas-Dependency-TreeMap'
}

{ #category : #specs }
MiTreeMapVisualisationBrowser class >> defaultSpec [
	^ super defaultSpec
		add: #diagram;
		yourself
]

{ #category : #specs }
MiTreeMapVisualisationBrowser class >> menuCommandOn: aBuilder [
	<worldMenu>
	<miBrowsers>
	(aBuilder item: #TreeMapVisualisationBrowser)
		parent: self toolbarDependencyName;
		label: self title;
		icon: (self iconNamed: #mooseTreeMap);
		help: self helpMessage;
		order: 3.0;
		action: [ self runMe ]
]

{ #category : #specs }
MiTreeMapVisualisationBrowser class >> runMe [
	<script>
	^ super runMe
]

{ #category : #accessing }
MiTreeMapVisualisationBrowser class >> title [
	^ 'Tree Map Visualization'
]

{ #category : #testing }
MiTreeMapVisualisationBrowser >> accept: anObject [
	^ anObject isMooseObject and: [ anObject rootsForTreeMap isNotEmpty ]
]

{ #category : #accessing }
MiTreeMapVisualisationBrowser >> diagram [
	^ diagram
]

{ #category : #accessing }
MiTreeMapVisualisationBrowser >> diagram: anObject [
	diagram := anObject
]

{ #category : #actions }
MiTreeMapVisualisationBrowser >> followAction [
	(self accept: toSelect)
		ifFalse: [ ^ self ].
	diagram
		unHighlight;
		rootEntities: toSelect rootsForTreeMap;
		run
]

{ #category : #actions }
MiTreeMapVisualisationBrowser >> highlightAction [
	diagram highlightEntities: toSelect rootsForTreeMap
]

{ #category : #initialization }
MiTreeMapVisualisationBrowser >> initializePresenters [
	super initializePresenters.
	diagram := self instantiate: MiTreeMap.
	diagram
		childrenBlock: [ :el | 
			(el usesFamixTrait: TEntityMetaLevelDependency)
				ifTrue: [ el children ]
				ifFalse: [ {} ] ]
]
