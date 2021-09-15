Class {
	#name : #MiHierarchicalVisualizationBrowser,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'diagram'
	],
	#category : #'MooseIDE-Visualization'
}

{ #category : #specs }
MiHierarchicalVisualizationBrowser class >> defaultSpec [

	^ super defaultSpec
		  add: #diagram;
		  yourself
]

{ #category : #'instance creation' }
MiHierarchicalVisualizationBrowser class >> open [

	<script>
	super open
]

{ #category : #accessing }
MiHierarchicalVisualizationBrowser class >> title [

	^ 'Hierarchical Visualization'
]

{ #category : #testing }
MiHierarchicalVisualizationBrowser >> canReceiveEntity: anObject [

	^ true
]

{ #category : #actions }
MiHierarchicalVisualizationBrowser >> followEntity: anEntity [

	diagram entities: anEntity asCollection.
	diagram run
]

{ #category : #initialization }
MiHierarchicalVisualizationBrowser >> initializePresenters [

	super initializePresenters.
	diagram := self instantiate: MiHierarchicalVisualization
]
