Class {
	#name : #MiAbstractBrowser,
	#superclass : #MiPresenter,
	#instVars : [
		'model',
		'freeze'
	],
	#category : #'Midas-Browser'
}

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
	freeze := aBoolean
]

{ #category : #accessing }
MiAbstractBrowser >> globallySelect: anEntity [
	self application globallySelect: anEntity
]

{ #category : #accessing }
MiAbstractBrowser >> initialize [
	super initialize.
	freeze := false
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
	^ freeze
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
