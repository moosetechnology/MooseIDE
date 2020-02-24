Class {
	#name : #MiAbstractBrowser,
	#superclass : #MiPresenter,
	#instVars : [
		'model',
		'buttonFreeze',
		'follow',
		'freeze'
	],
	#category : #'Midas-Browser'
}

{ #category : #'world menu' }
MiAbstractBrowser class >> defaultSpec [
	^ SpBoxLayout newVertical
		add:
			(SpBoxLayout newHorizontal
				add: #follow expand: false;
				add: #buttonFreeze expand: false;
				yourself)
			withConstraints: [ :constraints | constraints height: self toolbarHeight ];
		yourself
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
		order: 6.0;
		withSeparatorAfter;
		icon: MooseIcons mooseIcon
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

{ #category : #accessing }
MiAbstractBrowser >> freeze: aBoolean [
	(aBoolean ifTrue: [ buttonFreeze ] ifFalse: [ follow ]) state: true
]

{ #category : #accessing }
MiAbstractBrowser >> globallySelect: anEntity [
	self application globallySelect: anEntity
]

{ #category : #accessing }
MiAbstractBrowser >> initializePresenters [
	super initializePresenters.
	self flag: 'The state of freeze should be store in a model'.
	buttonFreeze := self newRadioButton.
	follow := self newRadioButton.
	follow
		associatedRadioButtons:
			{buttonFreeze.
			follow}.
	buttonFreeze label: 'Freeze'.
	follow label: 'Follow'.
	self freeze: false.
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

{ #category : #accessing }
MiAbstractBrowser >> isFreeze [
	^ buttonFreeze state
]

{ #category : #accessing }
MiAbstractBrowser >> isMiBrowser [
	^ true
]

{ #category : #accessing }
MiAbstractBrowser >> isNotFreeze [
	^ self isFreeze not
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
	self subclassResponsibility
]
