"
Shows dependencies of an entity. The entity is in red.
Incoming dependencies, to the left, are in green.
Outgoing dependencies, to the right, are in blue

- Follow: Accepts a MooseEntity that uses TEntityMetaLevelDependency.
- Highlight: <TODO>
- Propagate: The central entity (in red)
"
Class {
	#name : #MiDependencyButterflyBrowser,
	#superclass : #MiAbstractTelescopeBrowser,
	#category : #'MooseIDE-Telescope-Butterfly'
}

{ #category : #'world menu' }
MiDependencyButterflyBrowser class >> menuCommandOn: aBuilder [
	<worldMenu>
	<miBrowsers>
	(aBuilder item: #butterflyBrowser)
		parent: (self telescopeMenuItemName);
		label: (self title);
		icon: (self iconNamed: #mooseTree);
		help: (self helpMessage);
		action: [ self open ]
]

{ #category : #'instance creation' }
MiDependencyButterflyBrowser class >> open [
	<script>
	^ super open
]

{ #category : #specs }
MiDependencyButterflyBrowser class >> title [
	^ 'Dependency Butterfly'
]

{ #category : #testing }
MiDependencyButterflyBrowser >> canFollowEntity: anObject [
	^ anObject isMooseEntity
		and: [ anObject usesFamixTrait: TEntityMetaLevelDependency ]
]

{ #category : #initialization }
MiDependencyButterflyBrowser >> diagramClass [
	^ MiDependencyButterfly
]

{ #category : #actions }
MiDependencyButterflyBrowser >> followEntity: anEntity [

	diagram
		entity: anEntity;
		run
]

{ #category : #accessing }
MiDependencyButterflyBrowser >> miSelectedItem [
	^ diagram entity
]
