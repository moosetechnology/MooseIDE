"
I am superclass for all browsers in Midas.
I provide a toolBar with:
	- Radio buttons to choose a reception mode: Follow, Freeze and Highlight.
	- Buttons to inspect and propagate the current selection.
	- A help button that shows the class comment for each browser. 

Concrete browsers can use my instance variable #model (it can be initialized with #initializeModel).
They should override:
Instance side:
	- #accept: | which entities the browser can receive
	- #followAction | what to do with the received entity in Follow mode
	- #highlightAction | what to do with the received entity in Highlight mode
	- #miSelectedItem | entity (or entities) to propagate
Class side:	
	- #title | The browser window title
	- #menuCommandOn: | To be integrated into Midas Browsers menu
Spec2 methods: 
	#initializePresenters, #defaultSpec, ...

Please comment your browser as follow: 
*************************************************
A few lines describing the browser purpose.

- Follow:
Entities accepted and associated behavior.

- Highlight:
Highlight behavior.

- Propagate:
Propagated entities.
*************************************************
"
Class {
	#name : #MiAbstractBrowser,
	#superclass : #MiPresenter,
	#instVars : [
		'model',
		'toSelect',
		'buttonFreeze',
		'buttonFollow',
		'buttonHighlight',
		'buttonPropagate',
		'menu',
		'buttonInspect',
		'buttonHelp',
		'bus'
	],
	#category : #'Midas-Core-Browser'
}

{ #category : #specs }
MiAbstractBrowser class >> buildCommandsGroupWith: presenterInstance forRoot: rootCommandGroup [
	rootCommandGroup register: (MiPropagateCommand forSpecContext: presenterInstance).
	rootCommandGroup register: (MiInspectCommand forSpecContext: presenterInstance)
]

{ #category : #specs }
MiAbstractBrowser class >> defaultSpec [
	^ SpBoxLayout newVertical
		add:
			(SpBoxLayout newHorizontal
				add: #buttonFollow width: 65;
				add: #buttonFreeze width: 60;
				add: #buttonHighlight width: 80;
				add: SpBoxLayout newHorizontal expand: true;
				add: #buttonInspect expand: false;
				add: #buttonPropagate expand: false;
				add: #buttonHelp width: self iconWidth;
				yourself)
			withConstraints: [ :constraints | constraints height: self toolbarHeight ];
		yourself
]

{ #category : #'world menu' }
MiAbstractBrowser class >> helpMessage [
	^ (self comment lines copyUpTo: '')
		fold: [ :s1 :s2 | s1 , Character cr asString , s2 ]
]

{ #category : #testing }
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

{ #category : #'instance creation' }
MiAbstractBrowser class >> newModel [
	"Override to return a model for your browser"

	^ nil
]

{ #category : #'instance creation' }
MiAbstractBrowser class >> openOn: anEntity [
	self new
		selectEntity: anEntity;
		openWithSpec
]

{ #category : #'instance creation' }
MiAbstractBrowser class >> runMe [
	<script>
	^ (self on: self newModel)
		openWithSpec;
		selectEntity: self currentApplication logger mostRecentEntity
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

{ #category : #accessing }
MiAbstractBrowser >> activeStateButton [
	^ {buttonFollow.
	buttonFreeze.
	buttonHighlight} detect: #state
]

{ #category : #accessing }
MiAbstractBrowser >> bus [
	^ bus
]

{ #category : #actions }
MiAbstractBrowser >> canFollow [
	^ true
]

{ #category : #actions }
MiAbstractBrowser >> canHighlight [
	^ true
]

{ #category : #actions }
MiAbstractBrowser >> canPropagate [
	^ true
]

{ #category : #actions }
MiAbstractBrowser >> followAction [
	^ self subclassResponsibility
]

{ #category : #actions }
MiAbstractBrowser >> followBus: aBus [
	bus := aBus.
	bus registerBrowser: self
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
		enabled: true;
		yourself.
	buttonFollow := self newRadioButton
		label: 'Follow';
		enabled: self canFollow;
		yourself.
	buttonHighlight := self newRadioButton
		label: 'Highlight';
		enabled: self canHighlight;
		yourself.
	buttonFollow
		associatedRadioButtons:
			{buttonFreeze.
			buttonFollow.
			buttonHighlight}.
	self freeze: self canFollow not.
	buttonPropagate := self newButton
		label: 'Propagate';
		enabled: self canPropagate;
		action: [ (MiPropagateCommand forContext: self) execute ];
		yourself.
	buttonInspect := self newButton
		label: 'Inspect';
		action: [ (MiInspectCommand forContext: self) execute ];
		yourself.
	buttonHelp := self newButton
		icon: (self theme iconNamed: #help);
		help: self class comment;
		action: [ self showHelp ];
		yourself
]

{ #category : #initialization }
MiAbstractBrowser >> initializeWindow: aWindowPresenter [
	super initializeWindow: aWindowPresenter.
	aWindowPresenter
		whenClosedDo: [ self application windowClosed: aWindowPresenter ].
	aWindowPresenter
		title: self title;
		initialExtent: 500 @ 400
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
	^ buttonHighlight state
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
	^ (MiNoSelectedElementToPropagateException browser: self) signal
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

{ #category : #'accessing model' }
MiAbstractBrowser >> setModelBeforeInitialization: aModel [
	model := aModel
]

{ #category : #actions }
MiAbstractBrowser >> showHelp [
	| help |
	(help := self newPopover)
		relativeTo: buttonHelp;
		presenter: (MiHelpPopup owner: help on: self);
		popup
]
