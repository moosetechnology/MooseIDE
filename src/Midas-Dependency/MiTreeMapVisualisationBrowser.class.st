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
		label: 'Tree Map Visualisation browser';
		icon: (self iconNamed: #mooseTreeMap);
		order: 3.0;
		action: [ self runMe ]
]

{ #category : #specs }
MiTreeMapVisualisationBrowser class >> runMe [
	<script>
	^ super runMe
]

{ #category : #testing }
MiTreeMapVisualisationBrowser >> accept: anObject [
	anObject ifNil: [ ^ false ].
	^ (anObject isKindOf: MooseGroup)
				ifFalse: [ anObject isKindOf: MooseEntity ]
				ifTrue: [ anObject isNotEmpty ]
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
	(toSelect isOfType: MooseGroup)
		ifTrue: [ self model rootEntities: toSelect ]
		ifFalse: [ self model rootEntities: {toSelect} ].
	self refresh
]

{ #category : #actions }
MiTreeMapVisualisationBrowser >> highlightAction [
	(toSelect isOfType: MooseGroup)
		ifFalse: [ toSelect := {toSelect} ].
	model highlightEntities: toSelect
]

{ #category : #initialization }
MiTreeMapVisualisationBrowser >> initializePresenters [
	super initializePresenters.
	self
		model:
			(MiTreeMap new
				theme: self theme;
				childrenBlock: [ :el | (el usesFamixTrait: TEntityMetaLevelDependency) ifTrue: [ el children ] ifFalse: [ {} ] ]).
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

{ #category : #accessing }
MiTreeMapVisualisationBrowser >> title [
	^ 'Tree Map Visualisation Browser'
]
