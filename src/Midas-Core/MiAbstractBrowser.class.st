"
An abstract browser with the 3 receiving modes (frozen, highlight, follow) and the sending mode (propagate)

Modes:
- propagate -- selected entities in the browser are propagated to the whole application 

- follow -- selected entities in the application are display in the browser
- highlight -- entities in the browser remain the same, but those that were selected in the application are highlighted
- frozen -- ignore entities selected in application 

Instance variable:
- model
"
Class {
	#name : #MiAbstractBrowser,
	#superclass : #MiPresenter,
	#instVars : [
		'model',
		'toSelect',
		'buttonFreeze',
		'buttonFollow',
		'buttonHighligh',
		'buttonPropagate',
		'menu'
	],
	#category : #'Midas-Core-Browser'
}

{ #category : #'world menu' }
MiAbstractBrowser class >> defaultSpec [
	^ SpBoxLayout newVertical
		add:
			(SpBoxLayout newHorizontal
				add: #buttonFollow width: 65;
				add: #buttonFreeze width: 60;
				add: #buttonHighligh width: 80;
				add: SpBoxLayout newHorizontal expand: true;
				add: #buttonPropagate expand: false;
				yourself)
			withConstraints: [ :constraints | constraints height: self toolbarHeight ];
		yourself
]

{ #category : #'world menu' }
MiAbstractBrowser class >> isAbstract [ 
	^ self == MiAbstractBrowser
]

{ #category : #'world menu' }
MiAbstractBrowser class >> menuCommandMetaOn: aBuilder [
	<worldMenu>
	(aBuilder item: self toolbarMetaName)
		order: 6.0;
		parent: self toolbarName;
		withSeparatorAfter;
		icon: MooseIcons mooseIcon
]

{ #category : #'world menu' }
MiAbstractBrowser class >> menuCommandOn: aBuilder [
	<worldMenu>
	(aBuilder item: self toolbarName)
		order: 2.0;
		parent: #Moose;
		withSeparatorAfter;
		icon: MooseIcons mooseIcon
]

{ #category : #'world menu' }
MiAbstractBrowser class >> openOn: anEntity [
	self new
		selectEntity: anEntity;
		openWithSpec
]

{ #category : #'world menu' }
MiAbstractBrowser class >> runMe [
	<script>
	^ self new
		openWithSpec;
		"open with the last select entity"
		selectEntity: MiApplication current logger lastEntity
]

{ #category : #'world menu' }
MiAbstractBrowser class >> toolbarMetaName [
	^ #Meta
]

{ #category : #'world menu' }
MiAbstractBrowser class >> toolbarName [
	^ #'Midas Browsers'
]

{ #category : #testing }
MiAbstractBrowser >> accept: anObject [
	"whether the browser accepts to deal with anObject"
	^ false
]

{ #category : #actions }
MiAbstractBrowser >> canFollow [
	^true
]

{ #category : #actions }
MiAbstractBrowser >> canHighlight [
	^true
]

{ #category : #actions }
MiAbstractBrowser >> canPropagate [
	^true
]

{ #category : #actions }
MiAbstractBrowser >> followAction [
	^ self subclassResponsibility
]

{ #category : #actions }
MiAbstractBrowser >> freeze: aBoolean [
	(aBoolean ifTrue: [ buttonFreeze ] ifFalse: [ buttonFollow ]) state: true
]

{ #category : #actions }
MiAbstractBrowser >> freezeAction [
	"when frozen, does not do anything"
	^ self
]

{ #category : #actions }
MiAbstractBrowser >> freezeDuring: aBlock [
	| tmpState |
	tmpState := self isFreeze.
	self freeze: true.
	aBlock
		ensure: [ self freeze: tmpState ]
]

{ #category : #accessing }
MiAbstractBrowser >> globallySelect: anEntity [
	self application globallySelect: anEntity
]

{ #category : #actions }
MiAbstractBrowser >> highlightAction [
	^ self
]

{ #category : #initialization }
MiAbstractBrowser >> initializePresenters [
	super initializePresenters.
	self flag: 'The state of freeze should be store in a model'.
	buttonFreeze := self newRadioButton
		label: 'Freeze';
		enabled: true ;
		yourself.
	buttonFollow := self newRadioButton
		label: 'Follow';
		enabled: self canFollow ;
		yourself.
	buttonHighligh := self newRadioButton
		label: 'Highlight';
		enabled: self canHighlight ;
		yourself.
	buttonFollow associatedRadioButtons: {buttonFreeze . buttonFollow . buttonHighligh}.
	self freeze: self canFollow not.
	
	buttonPropagate := self newButton
		label: 'Propagate';
		enabled: self canPropagate ;
		action: [ (MiPropagateCommand forContext: self) execute ];
		yourself.
]

{ #category : #initialization }
MiAbstractBrowser >> initializeWindow: aWindowPresenter [
	super initializeWindow: aWindowPresenter.
	aWindowPresenter
		whenClosedDo: [ self application windowClosed: aWindowPresenter ].
	aWindowPresenter
		title: self title;
		initialExtent: 900 @ 700
]

{ #category : #actions }
MiAbstractBrowser >> isFollow [
	^ buttonFollow state
]

{ #category : #actions }
MiAbstractBrowser >> isFreeze [
	^ buttonFreeze state
]

{ #category : #actions }
MiAbstractBrowser >> isHighlight [
	^ buttonHighligh state
]

{ #category : #testing }
MiAbstractBrowser >> isMiBrowser [
	^ true
]

{ #category : #actions }
MiAbstractBrowser >> isNotFreeze [
	^ self isFreeze not
]

{ #category : #accessing }
MiAbstractBrowser >> miSelectedItem [
	^ MiNoSelectedElementToPropagateException new signal
]

{ #category : #accessing }
MiAbstractBrowser >> model [
	^ model
]

{ #category : #accessing }
MiAbstractBrowser >> model: anObject [
	model := anObject
]

{ #category : #accessing }
MiAbstractBrowser >> needUpdate: anEntity [
	^ anEntity ~= model selected
]

{ #category : #'private - accessing' }
MiAbstractBrowser >> selectEntity: anEntity [
	"I am used by the Mi Application. You should use #globallySelect: anEntity that will transmit the message to me and the other browsers"
	toSelect := anEntity.
	AbstractBrowserMode actionFor: self
]
