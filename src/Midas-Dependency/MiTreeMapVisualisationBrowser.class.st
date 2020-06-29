"
Shows the containment (direct relations for now) between entities.
Dynamic presentation: clicking on an entity shows the entities it contains.

- Follow:
Receives MooseObjects.

- Highlight:
Entities if present.

- Propagate:
<TODO>
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
	(aBuilder item: #TreeMapVisualisationBrowser)
		parent: self toolbarDependencyName;
		label: self title;
		icon: (self iconNamed: #mooseTreeMap);
		help: self helpMessage;
		order: 3.0;
		action: [ self runMe ]
]

{ #category : #initialization }
MiTreeMapVisualisationBrowser class >> newModel [
	^ MiTreeMap new
		theme: self theme;
		childrenBlock: [ :el | 
			(el usesFamixTrait: TEntityMetaLevelDependency)
				ifTrue: [ el children ]
				ifFalse: [ {} ] ]
]

{ #category : #specs }
MiTreeMapVisualisationBrowser class >> runMe [
	<script>
	^ super runMe
]

{ #category : #accessing }
MiTreeMapVisualisationBrowser class >> title [
	^ 'Tree Map Visualisation'
]

{ #category : #testing }
MiTreeMapVisualisationBrowser >> accept: anObject [
	^ anObject isNotNil
		and:
			[ anObject isMooseObject and: [ anObject rootsForTreeMap isNotEmpty ] ]
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
	self model unHighlight.
	self model rootEntities: toSelect rootsForTreeMap.
	self refresh
]

{ #category : #actions }
MiTreeMapVisualisationBrowser >> highlightAction [
	model highlightEntities: toSelect rootsForTreeMap
]

{ #category : #initialization }
MiTreeMapVisualisationBrowser >> initializePresenters [
	super initializePresenters.
	diagram := self instantiate: SpRoassalPresenter.
	diagram
		script: [ :canvas | 
			canvas color: self theme backgroundColor.
			self model canvas: canvas ]
]

{ #category : #updating }
MiTreeMapVisualisationBrowser >> refresh [
	self diagram refresh.
	self model run.
]
