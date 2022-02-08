"
Shows dependencies between entities.
Entities that are in a dependency circle are shown in red.

- Follow: Accepts a MooseGroup or MooseModel.
- Highlight: <TODO>
- Propagate: <TODO>
"
Class {
	#name : #MiCycleDependenciesBrowser,
	#superclass : #MiAbstractTelescopeBrowser,
	#category : #'MooseIDE-Telescope-CycleDependencies'
}

{ #category : #'world menu' }
MiCycleDependenciesBrowser class >> menuCommandOn: aBuilder [
	<worldMenu>
	<miBrowsers>
	(aBuilder item: #butterflyBrowser)
		parent: (self telescopeMenuItemName) ;
		label: (self title);
		icon: (self iconNamed: #mooseTree);
		help: (self helpMessage);
		action: [ self open ]
]

{ #category : #'instance creation' }
MiCycleDependenciesBrowser class >> open [
	<script>
	super open
]

{ #category : #specs }
MiCycleDependenciesBrowser class >> title [
	^ 'Cycle Dependencies'
]

{ #category : #testing }
MiCycleDependenciesBrowser >> canFollowEntity: anObject [
	^ anObject isMooseObject and: [ anObject isCollection ]
]

{ #category : #initialization }
MiCycleDependenciesBrowser >> diagramClass [
	^ MiCycleDependencies
]

{ #category : #actions }
MiCycleDependenciesBrowser >> followEntity: anEntity [

	diagram
		entities:
			(anEntity select: [ :a | 
					 a usesFamixTrait: TEntityMetaLevelDependency ]);
		run
]
