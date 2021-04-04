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
	#category : #'Midas-Telescope-Butterfly'
}

{ #category : #'instance creation' }
MiDependencyButterflyBrowser class >> menuCommandOn: aBuilder [
	<worldMenu>
	<miBrowsers>
	(aBuilder item: #butterflyBrowser)
		parent: (self telescopeMenuItemName);
		label: (self title);
		icon: (self iconNamed: #mooseTree);
		help: (self helpMessage);
		action: [ self runMe ]
]

{ #category : #'instance creation' }
MiDependencyButterflyBrowser class >> runMe [
	<script>
	^ super runMe
]

{ #category : #'instance creation' }
MiDependencyButterflyBrowser class >> title [
	^ 'Dependency Butterfly'
]

{ #category : #testing }
MiDependencyButterflyBrowser >> accept: anObject [
	^ anObject isMooseEntity
		and: [ anObject usesFamixTrait: TEntityMetaLevelDependency ]
]

{ #category : #initialization }
MiDependencyButterflyBrowser >> diagramClass [
	^ MiDependencyButterfly
]

{ #category : #actions }
MiDependencyButterflyBrowser >> followAction [
	(self accept: toSelect)
		ifFalse: [ ^ self ].
	diagram
		entity: toSelect;
		run
]

{ #category : #'as yet unclassified' }
MiDependencyButterflyBrowser >> miSelectedItem [
	^ diagram entity
]
