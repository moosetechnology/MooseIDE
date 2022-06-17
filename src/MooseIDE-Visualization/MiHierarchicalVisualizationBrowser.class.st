Class {
	#name : #MiHierarchicalVisualizationBrowser,
	#superclass : #MiAbstractBrowser2,
	#instVars : [
		'diagram'
	],
	#category : #'MooseIDE-Visualization'
}

{ #category : #menu }
MiHierarchicalVisualizationBrowser class >> addToMiBrowsersMenu: aMenuGroupPresenter [

	"Do not appear in menu"

	
]

{ #category : #layout }
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
