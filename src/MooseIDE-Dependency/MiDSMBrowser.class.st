Class {
	#name : #MiDSMBrowser,
	#superclass : #MiAbstractDependencyBrowser,
	#instVars : [
		'diagram'
	],
	#category : #'MooseIDE-Dependency-Dependency'
}

{ #category : #specs }
MiDSMBrowser class >> defaultLayout [

	^ super defaultLayout
		  add: #diagram;
		  yourself
]

{ #category : #'world menu' }
MiDSMBrowser class >> menuCommandOn: aBuilder [
	<worldMenu>
	<miBrowsers>
	(aBuilder item: #DSMVisualisationBrowser)
		parent: self toolbarDependencyName;
		label: self title;
		order: 0;
		icon: (self iconNamed: #mooseTree);
		help: self helpMessage;
		action: [ self open ]
]

{ #category : #'instance creation' }
MiDSMBrowser class >> open [

	<script>
	^ super open
]

{ #category : #specs }
MiDSMBrowser class >> title [

	^ 'DSM'
]

{ #category : #testing }
MiDSMBrowser >> canFollowEntity: anObject [

	^ anObject isCollection and: [ 
		  anObject allSatisfy: [ :a | 
			  a usesFamixTrait: TEntityMetaLevelDependency ] ].
]

{ #category : #testing }
MiDSMBrowser >> canHighlight [

	^ true
]

{ #category : #accessing }
MiDSMBrowser >> diagram [

	^ diagram
]

{ #category : #actions }
MiDSMBrowser >> followEntity: anEntity [

	diagram
		entities: (anEntity asMooseGroup select: [ :a | 
					 a usesFamixTrait: TEntityMetaLevelDependency ]);
		run
]

{ #category : #actions }
MiDSMBrowser >> highlightEntity: anEntity [

	diagram highlightEntities: anEntity asCollection
]

{ #category : #initialization }
MiDSMBrowser >> initializePresenters [

	diagram := self instantiate: MiDSMVisualization
]

{ #category : #accessing }
MiDSMBrowser >> miSelectedItem [

	^ diagram selected ifNil: [ diagram entities ]
]
