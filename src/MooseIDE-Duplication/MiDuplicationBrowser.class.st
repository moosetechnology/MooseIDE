"
A MooseIDE browser to present code clones.

Accepted entities: A collection of entities with a source anchor.

Use:
1. Propagate entities to this tool
2. Press 'Run' button
3. the tool will show a list of duplicated code chunks
4. select a duplicated code chunk to see the ducplicated sources (the duplication is greyed in the source code)
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
	<miBrowsersMenu>
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
MiDuplicationBrowser class >> preferredExtent [

	^ 1000 @ 500
]

{ #category : #specs }
MiDuplicationBrowser class >> title [
	^ 'Duplication browser'
]

{ #category : #'accessing - private tests' }
MiDuplicationBrowser >> btnRun [

	^ btnRun
]

{ #category : #testing }
MiDuplicationBrowser >> canFollowEntity: anObject [

	^ anObject isMooseObject and: [
		  anObject isCollection and: [
			  anObject anySatisfy: [ :each |
				  [ each hasSourceAnchor ]
					  on: Error
					  do: [ false ] ] ] ]
]

{ #category : #testing }
MiDuplicationBrowser >> canHighlight [
	^true
]

{ #category : #actions }
MiDuplicationBrowser >> followEntity: anEntity [

	super followEntity: anEntity.
	specModel allEntities: anEntity
]

{ #category : #initialization }
MiDuplicationBrowser >> handleFragmentSelection: selectedFragments [

	"| commonEntities |"

	self resetDisplayedReplicas.
	
	specModel fragmentsSelection: selectedFragments.
	"
	selectedFragments ifEmpty: [ ^self ].

	commonEntities := Set withAll: (selectedFragments first replicas collect: #entity).

	selectedFragments allButFirst do: [ :otherFragment |
		commonEntities := commonEntities intersection: (otherFragment replicas collect: #entity)
	].

	specModel highlightEntities: commonEntities"
]

{ #category : #actions }
MiDuplicationBrowser >> hasSettings [
	^ true
]

{ #category : #highlighting }
MiDuplicationBrowser >> highlightEntities: entities [

	specModel highlightEntities: entities

	
]

{ #category : #initialization }
MiDuplicationBrowser >> initializeLayout [

	self layout: (SpBoxLayout newTopToBottom
			 add: (SpPanedLayout newLeftToRight
					  add: lstEntities;
					  positionOfSlider: 0.15;
					  add: (SpPanedLayout newLeftToRight
							   add: (SpBoxLayout newTopToBottom
									    add: btnRun expand: false;
									    add: lstReplicatedFragments;
									    yourself);
							   positionOfSlider: 0.2;
							   add: panCodes);
					  yourself)
			 expand: true;
			 add: statusBar expand: false;
			 yourself)
]

{ #category : #initialization }
MiDuplicationBrowser >> initializeListEntities [

	lstEntities := self newList.
	lstEntities beMultipleSelection.
	lstEntities display: [ :entity | entity name , ' - ' , entity mooseName].

	lstEntities whenSelectionChangedDo: [ :selection | 
		specModel highlightEntities: selection selectedItems ]
]

{ #category : #initialization }
MiDuplicationBrowser >> initializeListReplicatedFragments [

	lstReplicatedFragments := self newTree.
	lstReplicatedFragments beMultipleSelection.

	lstReplicatedFragments display: [ :replicatedFragment | 
		replicatedFragment formatForDuplicationBrowser ].

	lstReplicatedFragments children: [ :replicatedFragment | specModel childrenFragments: replicatedFragment ].
	
	lstReplicatedFragments whenSelectionChangedDo: [ :selection | self handleFragmentSelection: selection selectedItems ]
]

{ #category : #initialization }
MiDuplicationBrowser >> initializePresenters [

	super initializePresenters.

	self initializeListEntities.
	self initializeListReplicatedFragments.

	btnRun := self newButton
		          label: 'Run';
		          action: [ 
			          self resetDisplayedReplicas.
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

	^ lstEntities
]

{ #category : #'accessing - private tests' }
MiDuplicationBrowser >> lstReplicatedFragments [

	^ lstReplicatedFragments 
]

{ #category : #accessing }
MiDuplicationBrowser >> miSelectedItem [

	^ specModel miSelectedItem
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
MiDuplicationBrowser >> resetDisplayedReplicas [

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

{ #category : #api }
MiDuplicationBrowser >> showEntities: entities [
	"displays list of entities in the left list"

	self resetDisplayedReplicas.
	lstEntities items: entities.
	self updateStatusBar.
]

{ #category : #api }
MiDuplicationBrowser >> showReplicas: replicas [
	 "a replica is an entity containing a clone
	show the code of the replicas in right pane"

	replicas do: [ :replica | 
		panCodes addPage: (self newCodePage: replica) ].
	replicas ifNotEmpty: [panCodes selectPageIndex: 1].
	
	self updateStatusBar.
]

{ #category : #api }
MiDuplicationBrowser >> showReplicatedFragments: replicatedFragments [
	"update middle list (of replicated fragments)"

	lstReplicatedFragments items:
		(replicatedFragments sort: [ :a :b |
			a replicas anyOne length > b replicas anyOne length ]).
	
	self updateStatusBar.
]

{ #category : #api }
MiDuplicationBrowser >> showSelectedClones: replicas [
	"show on the left list the entities belonging to selected replica(s)
	 If the list is empty (no selected replicas) show all entities"

	replicas
		ifEmpty: [ lstEntities items: self specModel allEntities ]
		ifNotEmpty: [ lstEntities items: (replicas collect: #entity) ]
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
