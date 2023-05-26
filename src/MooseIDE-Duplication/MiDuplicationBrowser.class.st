"
A MooseIDE browser to present code clones.

Accepted entities: A collection of entities with a source anchor.
"
Class {
	#name : #MiDuplicationBrowser,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'lstEntities',
		'btnRun',
		'panCodes',
		'lstReplicatedFragments',
		'statusBar'
	],
	#category : #'MooseIDE-Duplication'
}

{ #category : #'world menu' }
MiDuplicationBrowser class >> menuCommandOn: aBuilder [

	<worldMenu>
	^ (self buildMenuItemIn: aBuilder) withSeparatorAfter
]

{ #category : #'world menu' }
MiDuplicationBrowser class >> menuIconName [

	^ #smallCopy
]

{ #category : #'world menu' }
MiDuplicationBrowser class >> menuItem [

	^ #SpecializedBrowser
]

{ #category : #'world menu' }
MiDuplicationBrowser class >> menuPriority [

	^ self menuCodeToolsPriority + 2
]

{ #category : #'instance creation' }
MiDuplicationBrowser class >> newModel [

	^ MiDuplicationBrowserModel new
]

{ #category : #'instance creation' }
MiDuplicationBrowser class >> open [
	<script>
	^ super open
]

{ #category : #specs }
MiDuplicationBrowser class >> title [
	^ 'Duplication browser'
]

{ #category : #specs }
MiDuplicationBrowser class >> windowSize [

	^ 1000 @ 400
]

{ #category : #'accessing - private tests' }
MiDuplicationBrowser >> btnRun [

	^ btnRun
]

{ #category : #testing }
MiDuplicationBrowser >> canFollowEntity: anObject [

	^ anObject isMooseObject and: [ 
		  anObject asCollection anySatisfy: [ :each | 
			  [ each hasSourceAnchor ]
				  on: Error
				  do: [ false ] ] ]
]

{ #category : #testing }
MiDuplicationBrowser >> canHighlight [
	^true
]

{ #category : #actions }
MiDuplicationBrowser >> followEntity: entityCollection [

	specModel entities: entityCollection
]

{ #category : #utilities }
MiDuplicationBrowser >> formatReplicatedFragment: replicatedFragment [

	"number of replicas and summarization of replicated fragment code"

	^ replicatedFragment replicas size asString , ':'
	  ,
		  (replicatedFragment replicas anyOne codeText
			   withSeparatorsCompacted truncateWithElipsisTo: 25)
]

{ #category : #actions }
MiDuplicationBrowser >> hasSettings [
	^ true
]

{ #category : #api }
MiDuplicationBrowser >> highlightEntity: entities [

	specModel highlightEntity: entities

	
]

{ #category : #initialization }
MiDuplicationBrowser >> initializeLayout [

	self layout: (SpBoxLayout newTopToBottom
		add: (SpBoxLayout newLeftToRight
			add: lstEntities width: 150;
			add: (SpBoxLayout newTopToBottom
				add: btnRun expand: false;
				add: lstReplicatedFragments;
				yourself)
			width: 150;
			add: panCodes expand: true;
			yourself)
		expand: true ;
		add: statusBar expand: false ;
		yourself)
]

{ #category : #initialization }
MiDuplicationBrowser >> initializeListEntities [

	lstEntities := self newList.
	lstEntities beMultipleSelection.
	lstEntities display: [ :entity | entity name ].
	lstEntities displayIcon: [ :entity | 
		self iconNamed: ((specModel isSelected: entity)
				 ifTrue: [ #testGreen ]
				 ifFalse: [ #glamorousGrayCircleEmpty ]) ].

	lstEntities whenSelectionChangedDo: [ :selection | 
		specModel highlightEntity: selection selectedItems ]
]

{ #category : #initialization }
MiDuplicationBrowser >> initializeListReplicatedFragments [

	lstReplicatedFragments := self newTree.
	lstReplicatedFragments beMultipleSelection.

	lstReplicatedFragments display: [ :replicatedFragment | 
		self formatReplicatedFragment: replicatedFragment ].

	lstReplicatedFragments children: [ :replicatedFragment | specModel childrenFragments: replicatedFragment ].

	lstReplicatedFragments whenSelectionChangedDo: [ :selection | 
		self resetReplicas.
		specModel selectedFragments: selection selectedItems ]
]

{ #category : #initialization }
MiDuplicationBrowser >> initializePresenters [

	super initializePresenters.

	self initializeListEntities.
	self initializeListReplicatedFragments.

	btnRun := self newButton
		          label: 'Run';
		          action: [ 
			          self resetReplicas.
			          specModel findReplicas ].

	panCodes := self newNotebook.
	
	statusBar := self newLabel.
	self updateStatusBar.

	self initializeLayout
]

{ #category : #utilities }
MiDuplicationBrowser >> list: collection1 hasSameElements: collection2 [
	(collection1 size = collection2 size)
		ifFalse: [ ^false ].
	^collection1 allSatisfy: [ :elt | collection2 includes: elt ]
]

{ #category : #'accessing - private tests' }
MiDuplicationBrowser >> lstEntities [
	^lstEntities 
]

{ #category : #'accessing - private tests' }
MiDuplicationBrowser >> lstReplicatedFragments [

	^ lstReplicatedFragments 
]

{ #category : #accessing }
MiDuplicationBrowser >> miSelectedItem [

	^ specModel selectedEntities
]

{ #category : #utilities }
MiDuplicationBrowser >> newCodePage: replica [
	^MiDuplicationBrowserPage forReplica: replica
		
]

{ #category : #'accessing - private tests' }
MiDuplicationBrowser >> panCodes [

	^ panCodes
]

{ #category : #api }
MiDuplicationBrowser >> resetReplicas [

	lstEntities unselectAll.
	panCodes removeAll.
]

{ #category : #api }
MiDuplicationBrowser >> selectFragments: selectedFragments [

	(self
		 list: lstReplicatedFragments selectedItems
		 hasSameElements: selectedFragments) ifTrue: [ ^ self ].

	lstReplicatedFragments unselectAll.
	lstReplicatedFragments selectItems: selectedFragments
]

{ #category : #actions }
MiDuplicationBrowser >> settings [

	^specModel openSettings
]

{ #category : #api }
MiDuplicationBrowser >> showEntities: entities [

	self resetReplicas.
	lstEntities items: entities.
	self updateStatusBar.
]

{ #category : #api }
MiDuplicationBrowser >> showReplicas: replicas [

	replicas do: [ :replica | 
		panCodes addPage: (self newCodePage: replica) ].
	replicas ifNotEmpty: [panCodes selectPageIndex: 1].
	
	self updateStatusBar.
]

{ #category : #api }
MiDuplicationBrowser >> showReplicatedFragments: replicatedFragments [

	lstReplicatedFragments items: replicatedFragments.
	
	self updateStatusBar.
]

{ #category : #'accessing - private tests' }
MiDuplicationBrowser >> statusBarText [
	^statusBar label
]

{ #category : #utilities }
MiDuplicationBrowser >> updateStatusBar [
	^String streamContents: [ :stream |
		stream
			<< 'Searched entities: ' ;
			<< specModel numberOfEntities asString ;
			<< ' | Number of clones: ' ;
			<< specModel numberOfFragments asString ;
			<< ' | Entities with clones: ' ;
			<< specModel numberOfEntitiesInReplicas asString ;
			<< ' | Selected entities: ' ;
			<< specModel numberOfSelectedEntities asString ;
			<< ' | Selected clones: ' ;
			<< specModel numberOfSelectedFragments asString.
		statusBar label: stream contents
	]
]
