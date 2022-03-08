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
	#category : #'MooseIDE-Dependency-Dependency'
}

{ #category : #layout }
MiDependencyBrowser class >> defaultLayout [
	^ super defaultLayout
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
		action: [ self open ]
]

{ #category : #'world menu' }
MiDependencyBrowser class >> open [
	<script>
	^ super open
]

{ #category : #specs }
MiDependencyBrowser class >> title [
	^ 'Dependency'
]

{ #category : #testing }
MiDependencyBrowser >> canFollowEntity: anObject [

	^ anObject isCollection and: [ 
		  anObject anySatisfy: [ :a | 
			  a usesFamixTrait: TEntityMetaLevelDependency ] ]
]

{ #category : #testing }
MiDependencyBrowser >> canHighlight [

	^ true
]

{ #category : #actions }
MiDependencyBrowser >> followEntity: anEntity [

	diagram
		entities: (anEntity asMooseGroup select: [ :a | 
					 a usesFamixTrait: TEntityMetaLevelDependency ]);
		run
]

{ #category : #actions }
MiDependencyBrowser >> highlightEntity: anEntity [

	diagram highlightEntities: anEntity asCollection
]

{ #category : #initialization }
MiDependencyBrowser >> initializePresenters [

	diagram := self instantiate: MiDependencyVisualization
]

{ #category : #accessing }
MiDependencyBrowser >> miSelectedItem [

	^ diagram selected ifNil: [ diagram entities ]
]
