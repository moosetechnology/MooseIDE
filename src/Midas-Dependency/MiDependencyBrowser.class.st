"
Shows dependencies between entities (using #queryIncomingDependencies and #queryOutgoingDependencies).

- Follow: Accepts a MooseGroup.
- Highlight: Entites if present.
- Propagate: The selected entity if there is one.
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
	<miBrowsers>
	(aBuilder item: #DependencyVisualisationBrowser)
		parent: self toolbarDependencyName;
		label: self title;
		order: 0;
		icon: (self iconNamed: #mooseTree);
		help: self helpMessage;
		action: [ self runMe ]
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

{ #category : #testing }
MiDependencyBrowser >> accept: anObject [
	^ anObject isCollection
		and: [ anObject
				anySatisfy: [ :a | a usesFamixTrait: TEntityMetaLevelDependency ] ]
]

{ #category : #actions }
MiDependencyBrowser >> followAction [
	(self accept: toSelect)
		ifFalse: [ ^ self ].
	(toSelect isOfType: MooseGroup)
		ifFalse: [ toSelect := {toSelect} ].
	diagram
		entities:
			(toSelect
				select: [ :a | a usesFamixTrait: TEntityMetaLevelDependency ]);
		run
]

{ #category : #actions }
MiDependencyBrowser >> highlightAction [
	(toSelect isOfType: MooseGroup)
		ifFalse: [ toSelect := {toSelect} ].
	diagram highlightEntities: toSelect
]

{ #category : #initialization }
MiDependencyBrowser >> initializePresenters [
	super initializePresenters.
	diagram := self instantiate: MiDependencyVisualization
]

{ #category : #accessing }
MiDependencyBrowser >> miSelectedItem [
	^ diagram selected
]
