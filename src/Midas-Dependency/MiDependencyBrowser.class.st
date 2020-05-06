Class {
	#name : #MiDependencyBrowser,
	#superclass : #MiAbstractDependencyBrowser,
	#instVars : [
		'diagram'
	],
	#category : #'Midas-Dependency-Dependency'
}

{ #category : #'world menu' }
MiDependencyBrowser class >> defaultSpec [
	^ super defaultSpec
		add: #diagram;
		yourself
]

{ #category : #'world menu' }
MiDependencyBrowser class >> menuCommandOn: aBuilder [
	<worldMenu>
	(aBuilder item: #DependencyVisualisationBrowser)
		parent: self toolbarDependencyName;
		label: 'Dependency Visualisation browser';
		order: 0;
		icon: (self iconNamed: #mooseTree);
		action: [ self runMe ]
]

{ #category : #'world menu' }
MiDependencyBrowser class >> runMe [
	<script>
	super runMe
]

{ #category : #acccessing }
MiDependencyBrowser >> accept: anObject [
	^ anObject isCollection and: [ anObject allSatisfy: [ :a | a usesFamixTrait: TDependencyQueries ] ]
]

{ #category : #accessing }
MiDependencyBrowser >> diagram [
	^ diagram
]

{ #category : #accessing }
MiDependencyBrowser >> diagram: aDiagram [
	diagram := aDiagram
]

{ #category : #acccessing }
MiDependencyBrowser >> followAction [
	(self accept: toSelect)
		ifFalse: [ ^ self ].
	(toSelect isOfType: MooseGroup)
		ifTrue: [ self model entities: toSelect ]
		ifFalse: [ self model entities: {toSelect} ].
	self refresh
]

{ #category : #TOREMOVE }
MiDependencyBrowser >> initializePresenters [
	super initializePresenters.
	self model: (MiDependencyVisualization new theme: self theme).
	diagram := self instantiate: SpRoassalPresenter.
	diagram
		script: [ :canvas | 
			canvas color: self theme backgroundColor.
			self model canvas: canvas ]
]

{ #category : #TOREMOVE }
MiDependencyBrowser >> refresh [
	self diagram refresh.
	self model run.
]

{ #category : #TOREMOVE }
MiDependencyBrowser >> title [
	^ 'Dependency Browser'
]
