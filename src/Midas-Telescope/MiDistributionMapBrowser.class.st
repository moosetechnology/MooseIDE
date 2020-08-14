"
Shows children of entities.

- Follow: 
Accepts a MooseObject.

- Highlight:
<TODO>

- Propagate:
<TODO>
"
Class {
	#name : #MiDistributionMapBrowser,
	#superclass : #MiAbstractTelescopeBrowser,
	#category : #'Midas-Telescope-DistributionMap'
}

{ #category : #'instance creation' }
MiDistributionMapBrowser class >> menuCommandOn: aBuilder [
	<worldMenu>
	<miBrowsers>
	(aBuilder item: #distributionMapBrowser)
		parent: self telescopeMenuItemName;
		label: self title;
		icon: (self iconNamed: #mooseTreeMap);
		help: self helpMessage;
		action: [ self runMe ]
]

{ #category : #'instance creation' }
MiDistributionMapBrowser class >> runMe [
	<script>
	^ super runMe
]

{ #category : #specs }
MiDistributionMapBrowser class >> title [
	^ 'Distribution Map'
]

{ #category : #testing }
MiDistributionMapBrowser >> accept: anObject [
	^ anObject isMooseObject
]

{ #category : #initialization }
MiDistributionMapBrowser >> diagramClass [
	^ MiDistributionMap
]

{ #category : #actions }
MiDistributionMapBrowser >> followAction [
	(self accept: toSelect)
		ifFalse: [ ^ self ].
	toSelect isCollection
		ifFalse: [ toSelect := {toSelect} ].
	diagram
		entities:
			(toSelect
				select: [ :a | a usesFamixTrait: TEntityMetaLevelDependency ]);
		run
]

{ #category : #initialization }
MiDistributionMapBrowser >> initializePresenters [
	super initializePresenters.
	diagram
		childrenBlock: [ :entity | entity children ];
		propertyBlock: [ :entity | entity children size ]
]
