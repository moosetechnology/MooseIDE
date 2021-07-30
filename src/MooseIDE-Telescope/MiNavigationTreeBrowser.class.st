"
Shows dependencies of entities.
Received entities are shown in red.

- Follow: Accepts a MooseObject
- Highlight: <TODO>
- Propagate: <TODO>
"
Class {
	#name : #MiNavigationTreeBrowser,
	#superclass : #MiAbstractTelescopeBrowser,
	#category : #'MooseIDE-Telescope-NavigationTree'
}

{ #category : #'instance creation' }
MiNavigationTreeBrowser class >> menuCommandOn: aBuilder [
	<worldMenu>
	<miBrowsers>
	(aBuilder item: #distributionMapBrowser)
		parent: (self telescopeMenuItemName);
		label: (self title);
		icon: (self iconNamed: #mooseTreeMap);
		help: (self helpMessage);
		action: [ self open ]
]

{ #category : #'instance creation' }
MiNavigationTreeBrowser class >> open [
	<script>
	super open
]

{ #category : #'instance creation' }
MiNavigationTreeBrowser class >> title [
	^ 'Navigation tree'
]

{ #category : #testing }
MiNavigationTreeBrowser >> accept: anObject [
	^ anObject isMooseObject
]

{ #category : #initialization }
MiNavigationTreeBrowser >> diagramClass [
	^ MiNavigationTree
]

{ #category : #actions }
MiNavigationTreeBrowser >> followAction [
	(self accept: toSelect)
		ifFalse: [ ^ self ].
	diagram
		entities:
			((toSelect isCollection
				ifTrue: [ toSelect ]
				ifFalse: [ MooseGroup with: toSelect ])
				allUsing: TEntityMetaLevelDependency);
		setAssociation;
		run
]
