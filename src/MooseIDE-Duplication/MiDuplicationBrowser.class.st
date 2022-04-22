"
A MooseIDE browser to present code clones
"
Class {
	#name : #MiDuplicationBrowser,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'lstEntities',
		'btnRun',
		'panCodes',
		'lstReplicatedFragments'
	],
	#category : #'MooseIDE-Duplication'
}

{ #category : #accessing }
MiDuplicationBrowser class >> menuCommandOn: aBuilder [
	<worldMenu>
	<miBrowsers>
	(aBuilder item: #SpecializedBrowser)
		parent: self midasBrowserMenuLabel;
		label: self title;
		icon: (self iconNamed: #smallCopy);
		help: self helpMessage;
		action: [ self open ]
]

{ #category : #'instance creation' }
MiDuplicationBrowser class >> newModel [

	^ MiDuplicationBrowserModel new
]

{ #category : #accessing }
MiDuplicationBrowser class >> open [
	<script>
	^ super open
]

{ #category : #accessing }
MiDuplicationBrowser class >> title [
	^ 'Duplication browser'
]

{ #category : #testing }
MiDuplicationBrowser >> canFollowEntity: anObject [

	^ anObject isMooseObject and: [ 
		  anObject asCollection anySatisfy: [ :each | 
			  [ each hasSourceAnchor ]
				  on: Error
				  do: [ false ] ] ]
]

{ #category : #actions }
MiDuplicationBrowser >> followEntity: entityCollection [

	model entities: entityCollection
]

{ #category : #actions }
MiDuplicationBrowser >> hasSettings [
	^true
]

{ #category : #private }
MiDuplicationBrowser >> highlightReplicatedEntity: replicas [
replicas do: [ :replica |
		lstEntities selectItem: replica entity]
]

{ #category : #initialization }
MiDuplicationBrowser >> initializeLayout [
	self layout: (SpBoxLayout newLeftToRight
		add: lstEntities ;
		add: (SpBoxLayout newTopToBottom 
			add: btnRun expand: false ;
			add: lstReplicatedFragments ;
			yourself) ;
		add: panCodes ;
		yourself)
]

{ #category : #initialization }
MiDuplicationBrowser >> initializeListEntities [
	lstEntities := self newList.
	lstEntities beMultipleSelection.
	lstEntities display: [ :entity | entity name ]
]

{ #category : #initialization }
MiDuplicationBrowser >> initializeListReplicatedFragments [

	lstReplicatedFragments := self newList.
	lstReplicatedFragments display: [ :replicatedFragment | 
		replicatedFragment replicas anyOne codeText withSeparatorsCompacted 
			truncateWithElipsisTo: 20 ].
	lstReplicatedFragments whenSelectionChangedDo: [ :selection | 
		selection selectedItem ifNotNil: [ :selectedItem | model selectedFragment: selectedItem ] ]
]

{ #category : #initialization }
MiDuplicationBrowser >> initializePresenter [

	super initializePresenter.

	self initializeListEntities.
	self initializeListReplicatedFragments.

	btnRun := self newButton
		          label: 'Run';
		          action: [ self resetReplicas ].

	panCodes := self newNotebook.

	self initializeLayout
]

{ #category : #private }
MiDuplicationBrowser >> newCodePage: replica [
	^MiDuplicationBrowserPage forReplica: replica
		
]

{ #category : #api }
MiDuplicationBrowser >> resetReplicas [
	lstEntities unselectAll.
	panCodes removeAll.
	model findReplicas
]

{ #category : #initialization }
MiDuplicationBrowser >> setModelBeforeInitialization: aModel [
	super setModelBeforeInitialization: aModel.
	aModel browser: self
]

{ #category : #actions }
MiDuplicationBrowser >> settings [
	"settings for duplication algorithm"

	self shouldBeImplemented  
]

{ #category : #api }
MiDuplicationBrowser >> showEntities: entities [

	self resetReplicas.
	lstEntities items: entities
]

{ #category : #api }
MiDuplicationBrowser >> showReplicas: replicas [

	self highlightReplicatedEntity: replicas.
	self showReplicatedEntityCode: replicas
]

{ #category : #private }
MiDuplicationBrowser >> showReplicatedEntityCode: replicas [

	replicas do: [ :replica | 
		panCodes addPage: (self newCodePage: replica) ]
]

{ #category : #api }
MiDuplicationBrowser >> showReplicatedFragments: replicatedFragments [

	lstReplicatedFragments items: replicatedFragments
]
