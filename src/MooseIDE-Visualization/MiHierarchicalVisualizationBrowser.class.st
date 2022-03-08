Class {
	#name : #MiHierarchicalVisualizationBrowser,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'diagram'
	],
	#category : #'MooseIDE-Visualization'
}

{ #category : #specs }
MiHierarchicalVisualizationBrowser class >> defaultLayout [

	^ super defaultLayout
		  add: #diagram;
		  yourself
]

{ #category : #'instance creation' }
MiHierarchicalVisualizationBrowser class >> open [

	<script>
	super open
]

{ #category : #specs }
MiHierarchicalVisualizationBrowser class >> title [

	^ 'Hierarchical Visualization'
]

{ #category : #testing }
MiHierarchicalVisualizationBrowser >> canFollowEntity: anObject [

	^ anObject isMooseObject
]

{ #category : #actions }
MiHierarchicalVisualizationBrowser >> followEntity: anEntity [

	diagram entities: anEntity asCollection.
	diagram run
]

{ #category : #initialization }
MiHierarchicalVisualizationBrowser >> initializePresenters [

	diagram := self instantiate: MiHierarchicalVisualization.
	diagram childrenBlock: [ :el | 
		(el usesFamixTrait: TEntityMetaLevelDependency)
			ifTrue: [ el children ]
			ifFalse: [ {  } ] ]
]

{ #category : #accessing }
MiHierarchicalVisualizationBrowser >> miSelectedItem [
	^nil
]
