"
Please comment me using the following template inspired by Class Responsibility Collaborator (CRC) design:

For the Class part:  State a one line summary. For example, ""I represent a paragraph of text"".

For the Responsibility part: Three sentences about my main responsibilities - what I do, what I know.

For the Collaborators Part: State my main collaborators and one line about how I interact with them. 

Public API and Key Messages

- message one   
- message two 
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.
 
Internal Representation and Key Implementation Points.

    Instance Variables
	noteBook:		<Object>
	sourceCodePage:		<Object>
	sourceText:		<Object>


    Implementation Points
"
Class {
	#name : #MiTreeVisualisationBrowser,
	#superclass : #MiAbstractDependencyBrowser,
	#instVars : [
		'diagram'
	],
	#category : #'Midas-Dependency-Tree'
}

{ #category : #specs }
MiTreeVisualisationBrowser class >> defaultSpec [
	^ SpBoxLayout newHorizontal
		add: #diagram;
		yourself
]

{ #category : #specs }
MiTreeVisualisationBrowser class >> menuCommandOn: aBuilder [
	<worldMenu>
	(aBuilder item: #TreeVisualisationBrowser)
		parent: self toolbarDependencyName;
		label: 'Tree Visualisation browser';
		order: 2.0;
		icon: (self iconNamed: #mooseTree);
		action: [ self runMe ]
]

{ #category : #specs }
MiTreeVisualisationBrowser class >> runMe [
	<script>
	self new openWithSpec
]

{ #category : #'as yet unclassified' }
MiTreeVisualisationBrowser >> accept: anObject [
	^ self isNotFreeze
]

{ #category : #accessing }
MiTreeVisualisationBrowser >> diagram [
	^ diagram
]

{ #category : #accessing }
MiTreeVisualisationBrowser >> diagram: anObject [
	diagram := anObject
]

{ #category : #'as yet unclassified' }
MiTreeVisualisationBrowser >> initializePresenters [
	self model: MiTreeVisualisationBrowserModel new.
	diagram := self instantiate: SpRoassalPresenter.
]

{ #category : #'as yet unclassified' }
MiTreeVisualisationBrowser >> refresh [
	diagram
		script: [ :canvas | 
			| boxes |
			boxes := self model entities
				collect: [ :cls | 
					| box label composite |
					box := RSBox new size: 100.
					label := RSLabel new text: cls name.
					RSLocation new
						above;
						move: box on: label.
					composite := RSComposite new.
					composite
						shapes: {label . box};
						model: cls.
					composite @ RSDraggable.
					composite ]
				as: RSGroup.
			canvas addAll: boxes.
			RSEdgeBuilder line
				canvas: canvas;
				shapes: boxes;
				withVerticalAttachPoint;
				connectToAll: [ :a | (a usesFamixTrait: TEntityMetaLevelDependency) ifTrue: [ a children ] ifFalse: [ {  } ] ].
			RSTreeLayout on: boxes.
			canvas @ RSCanvasController.
			canvas ];
		refresh
]

{ #category : #'as yet unclassified' }
MiTreeVisualisationBrowser >> selectEntity: anEntity [
	(self accept: anEntity) ifFalse: [ ^ self ].
	Transcript crTrace: anEntity printString.
	(anEntity isOfType: MooseGroup) ifTrue: [ self model entities: anEntity ] ifFalse: [ self model entities: {anEntity} ].
	self refresh
]

{ #category : #'as yet unclassified' }
MiTreeVisualisationBrowser >> title [
	^ 'Tree Visualisation Browser'
]
