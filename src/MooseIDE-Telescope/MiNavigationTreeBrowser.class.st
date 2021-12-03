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

{ #category : #'world menu' }
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

{ #category : #specs }
MiNavigationTreeBrowser class >> title [
	^ 'Navigation tree'
]

{ #category : #testing }
MiNavigationTreeBrowser >> canFollowEntity: anObject [
	^ anObject isMooseObject
]

{ #category : #initialization }
MiNavigationTreeBrowser >> diagramClass [
	^ MiNavigationTree
]

{ #category : #actions }
MiNavigationTreeBrowser >> followEntity: anEntity [

	diagram
		entities:
			(anEntity asCollection allUsing: TEntityMetaLevelDependency);
		setAssociation;
		run
]
