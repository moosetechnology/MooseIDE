"
Shows dependencies between entities (using #queryIncomingDependencies and #queryOutgoingDependencies).

- Follow: 
Accepts a MooseGroup.

- Highlight:
Entites if present.

- Propagate:
<TODO>
"
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
		label: self title;
		order: 0;
		icon: (self iconNamed: #mooseTree);
		help: self helpMessage;
		action: [ self runMe ]
]

{ #category : #TOREMOVE }
MiDependencyBrowser class >> newModel [
	^ MiDependencyVisualization new theme: self theme
]

{ #category : #'world menu' }
MiDependencyBrowser class >> runMe [
	<script>
	^ super runMe
]

{ #category : #TOREMOVE }
MiDependencyBrowser class >> title [
	^ 'Dependency'
]

{ #category : #acccessing }
MiDependencyBrowser >> accept: anObject [
	^ anObject isCollection
		and: [ anObject
				anySatisfy: [ :a | a usesFamixTrait: TEntityMetaLevelDependency ] ]
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
