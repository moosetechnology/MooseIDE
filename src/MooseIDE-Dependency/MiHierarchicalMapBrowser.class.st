"
I am a browser that display a hieracical map.
"
Class {
	#name : #MiHierarchicalMapBrowser,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'visualization'
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

{ #category : #testing }
MiHierarchicalMapBrowser >> canReceiveEntity: anEntity [

	^ anEntity isMooseObject
]

{ #category : #actions }
MiHierarchicalMapBrowser >> followEntity: anEntity [

	model entities: (anEntity asMooseGroup).
	visualization run
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
			 add: visualization;
			 yourself)
]

{ #category : #initialization }
MiHierarchicalMapBrowser >> initializePresenters [

	visualization := MiHierarchicalMap
		                 owner: self
		                 on: model.
	self initializeLayout
]

{ #category : #accessing }
MiHierarchicalMapBrowser >> miSelectedItem [

	^ model entities mooseInterestingEntity
]
