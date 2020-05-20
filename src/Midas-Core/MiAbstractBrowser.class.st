Class {
	#name : #MiAbstractBrowser,
	#superclass : #MiPresenter,
	#instVars : [
		'model',
		'buttonFreeze',
		'freeze',
		'toSelect',
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

{ #category : #accessing }
MiAbstractBrowser >> accept: anObject [
	^ false
]

{ #category : #'as yet unclassified' }
MiAbstractBrowser >> followAction [
	^ self subclassResponsibility
]

{ #category : #accessing }
MiAbstractBrowser >> freeze: aBoolean [
	(aBoolean ifTrue: [ buttonFreeze ] ifFalse: [ buttonFollow ]) state: true
]

{ #category : #'as yet unclassified' }
MiAbstractBrowser >> freezeAction [
	^ self
]

{ #category : #helper }
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

{ #category : #'as yet unclassified' }
MiAbstractBrowser >> highlightAction [
	^ self
]

{ #category : #accessing }
MiAbstractBrowser >> initializePresenters [
	super initializePresenters.
	self flag: 'The state of freeze should be store in a model'.
	buttonFreeze := self newRadioButton
		label: 'Freeze';
		yourself.
	buttonFollow := self newRadioButton
		label: 'Follow';
		yourself.
	buttonHighligh := self newRadioButton
		label: 'Highlight';
		yourself.
	buttonFollow associatedRadioButtons: {buttonFreeze . buttonFollow . buttonHighligh}.
	buttonPropagate := self newButton
		label: 'Propagate';
		action: [ (MiPropagateCommand forContext: self) execute ];
		yourself.
	self freeze: false
]

{ #category : #accessing }
MiAbstractBrowser >> initializeWindow: aWindowPresenter [
	super initializeWindow: aWindowPresenter.
	aWindowPresenter
		whenClosedDo: [ self application windowClosed: aWindowPresenter ].
	aWindowPresenter
		title: self title;
		initialExtent: 900 @ 700
]

{ #category : #'as yet unclassified' }
MiAbstractBrowser >> isFollow [
	^ buttonFollow state
]

{ #category : #accessing }
MiAbstractBrowser >> isFreeze [
	^ buttonFreeze state
]

{ #category : #accessing }
MiAbstractBrowser >> isHighlight [
	^ buttonHighligh state
]

{ #category : #accessing }
MiAbstractBrowser >> isMiBrowser [
	^ true
]

{ #category : #accessing }
MiAbstractBrowser >> isNotFreeze [
	^ self isFreeze not
]

{ #category : #'as yet unclassified' }
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

{ #category : #accessing }
MiAbstractBrowser >> selectEntity: anEntity [
	toSelect := anEntity.
	AbstractBrowserMode actionFor: self
]
