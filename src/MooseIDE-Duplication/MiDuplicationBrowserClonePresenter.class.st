Class {
	#name : 'MiDuplicationBrowserClonePresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'contentView',
		'treeView',
		'text',
		'model'
	],
	#category : 'MooseIDE-Duplication-Browser',
	#package : 'MooseIDE-Duplication',
	#tag : 'Browser'
}

{ #category : 'formatting' }
MiDuplicationBrowserClonePresenter >> backgroundColor: aColor at: anInterval [

	text
		addAttribute: (TextBackgroundColor color: aColor)
		from: anInterval first
		to: anInterval last.
 
]

{ #category : 'removing' }
MiDuplicationBrowserClonePresenter >> clear [

	self clearHierarchy.
	self clearContent
]

{ #category : 'removing' }
MiDuplicationBrowserClonePresenter >> clearContent [

	contentView text: ''
]

{ #category : 'removing' }
MiDuplicationBrowserClonePresenter >> clearHierarchy [

	treeView roots: #().
]

{ #category : 'initialization' }
MiDuplicationBrowserClonePresenter >> connectPresenters [

	treeView whenSelectionChangedDo: [
		model showContentForEntity: treeView selectedItem
	]
]

{ #category : 'initialization' }
MiDuplicationBrowserClonePresenter >> defaultLayout [

	^SpPanedLayout newTopToBottom
		add: treeView ;
		add: contentView ;
		positionOfSlider: 100 ;
		yourself
]

{ #category : 'api' }
MiDuplicationBrowserClonePresenter >> formatReplicaText: replica [

	text := replica entity sourceText asText.

	replica entity replicas do: [:cloneToShow |
		(cloneToShow = replica)
		ifFalse: [ self highlightClone: cloneToShow color: self otherCloneColor ]
	].

	self highlightClone: replica color: self mainCloneColor.
	contentView text: text.
	self scrollToReplica: replica
	
]

{ #category : 'formatting' }
MiDuplicationBrowserClonePresenter >> highlightClone: clone color: aColor [
	"computes first and last character position of the clone"

	self
		backgroundColor: aColor
		at: (self linesToCharPos: (clone startLine to: clone endLine))
]

{ #category : 'api' }
MiDuplicationBrowserClonePresenter >> initialize [ 

	super initialize.

	model := MiDuplicationClonePresenterModel new.
	model browser: self
]

{ #category : 'initialization' }
MiDuplicationBrowserClonePresenter >> initializePresenters [ 

	super initializePresenters.

	treeView := self newTreeListView
		beSingleSelection ;
		setup: [ :aPresenter | aPresenter newLabel ] ;
		bind: [ :aPresenter :anEntity | aPresenter label: (model displayStringOf: anEntity) ] ;
		children: [ :node | model visibleChildrenOf: node ] ;
		roots: #() ;
		yourself.
	contentView := self newText.
]

{ #category : 'private' }
MiDuplicationBrowserClonePresenter >> linesToCharPos: lineInterval [

	"copied from FamixTFileNavigation >> #intervalAsCharPos
	must ignore the first line which is a kind of title (see #formatReplicaText)"

	| start lineNumber |
	lineNumber := -1. "so that first line is ignored in first 'loop iteration' "
	start := 1.
	text asString lineIndicesDo: [ :lineStart :lineEnd :ignore | 
		lineNumber := lineNumber + 1.
		lineInterval first = lineNumber ifTrue: [ start := lineStart ].
		lineInterval last = lineNumber ifTrue: [ ^start to: lineEnd ] ].
	^ start to: text size
]

{ #category : 'accessing' }
MiDuplicationBrowserClonePresenter >> mainCloneColor [

	^ Color lightYellow lighter
]

{ #category : 'accessing' }
MiDuplicationBrowserClonePresenter >> otherCloneColor [

	^ Color veryVeryLightGray
]

{ #category : 'api' }
MiDuplicationBrowserClonePresenter >> roots: hierarchyNodes [

	treeView roots: hierarchyNodes.
	treeView expandAll.

	contentView text: ''
]

{ #category : 'api' }
MiDuplicationBrowserClonePresenter >> scrollToReplica: replica [
	"scrollValue: takes two reals (in a Point) each from 0 to 1
	 0=left/top; 1=right/bottom"

	contentView scrollValue: (0 @ (replica startLine / text lineCount))
]

{ #category : 'api' }
MiDuplicationBrowserClonePresenter >> showReplicas: replicas [

	model showReplicas: replicas

]
