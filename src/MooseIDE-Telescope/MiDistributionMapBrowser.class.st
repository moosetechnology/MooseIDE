"
Shows children of entities.

- Follow: Accepts a MooseObject.
- Highlight: <TODO>
- Propagate: <TODO>
"
Class {
	#name : #MiDistributionMapBrowser,
	#superclass : #MiAbstractTelescopeBrowser,
	#category : #'MooseIDE-Telescope-DistributionMap'
}

{ #category : #'world menu' }
MiDistributionMapBrowser class >> menuCommandOn: aBuilder [
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
MiDistributionMapBrowser class >> open [
	<script>
	^ super open
]

{ #category : #specs }
MiDistributionMapBrowser class >> title [
	^ 'Distribution Map'
]

{ #category : #testing }
MiDistributionMapBrowser >> canFollowEntity: anObject [
	^ anObject isMooseObject
]

{ #category : #initialization }
MiDistributionMapBrowser >> diagramClass [
	^ MiDistributionMap
]

{ #category : #actions }
MiDistributionMapBrowser >> followEntity: anEntity [

	diagram
		entities: (anEntity asCollection select: [ :a | 
					 a usesFamixTrait: TEntityMetaLevelDependency ]);
		run
]

{ #category : #initialization }
MiDistributionMapBrowser >> initializePresenters [
	super initializePresenters.
	diagram
		childrenBlock: [ :entity | entity children ];
		propertyBlock: [ :entity | entity children size ]
]
