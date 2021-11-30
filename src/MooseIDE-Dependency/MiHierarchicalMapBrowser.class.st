"
I am a browser that display a hieracical map.
"
Class {
	#name : #MiHierarchicalMapBrowser,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'visualization',
		'menu'
	],
	#category : #'MooseIDE-Dependency-HierarchicalMap'
}

{ #category : #'instance creation' }
MiHierarchicalMapBrowser class >> newModel [

	^ MiHierarchicalMapModel new
]

{ #category : #accessing }
MiHierarchicalMapBrowser class >> open [
	<script>
	super open
]

{ #category : #accessing }
MiHierarchicalMapBrowser class >> title [

	^ 'Hierarchical Map'
]

{ #category : #accessing }
MiHierarchicalMapBrowser class >> windowSize [

	^ 850 @ 520
]

{ #category : #testing }
MiHierarchicalMapBrowser >> canReceiveEntity: anEntity [

	^ anEntity isMooseObject
]

{ #category : #actions }
MiHierarchicalMapBrowser >> followEntity: anEntity [

	model entities: anEntity asMooseGroup.
	self updatePresenter.
	self showMenu
]

{ #category : #'as yet unclassified' }
MiHierarchicalMapBrowser >> hideMenu [

	self layout remove: menu
]

{ #category : #initialization }
MiHierarchicalMapBrowser >> initialize [

	super initialize.
	model
		dynamicTags: MiHierarchicalMapModel defaultDynamicTags;
		childrenBlock: [ :e | e children ]
]

{ #category : #initialization }
MiHierarchicalMapBrowser >> initializeLayout [

	self layout: (SpBoxLayout newLeftToRight
			 spacing: 4;
			 add: visualization;
			 yourself)
]

{ #category : #initialization }
MiHierarchicalMapBrowser >> initializePresenters [

	visualization := MiHierarchicalMap
		                 owner: self
		                 on: model.
	menu := MiHierarchicalMapMenu owner: self.
	self initializeLayout
]

{ #category : #accessing }
MiHierarchicalMapBrowser >> miSelectedItem [

	^ model entities mooseInterestingEntity
]

{ #category : #'as yet unclassified' }
MiHierarchicalMapBrowser >> showMenu [

	self layout
		remove: visualization;
		add: menu width: 300;
		add: visualization
]

{ #category : #initialization }
MiHierarchicalMapBrowser >> updatePresenter [ 

	menu updatePresenter
]

{ #category : #initialization }
MiHierarchicalMapBrowser >> visualization [

	^ visualization
]
