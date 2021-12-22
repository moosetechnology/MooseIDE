"
A tool to manage tags

Allows to create new tag, give them name, put them in a hierarchy of tags, give them a color, and of course add or remove entities carrying a tag

"
Class {
	#name : #MiTagBrowser,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'mainPresenter',
		'tagModel',
		'tagManagementPage',
		'tagIntentPage',
		'tagExtentPage',
		'tagIsIntent'
	],
	#category : #'MooseIDE-Tagging-Browser'
}

{ #category : #specs }
MiTagBrowser class >> defaultSpec [
	^super defaultSpec
		add: #mainPresenter;
		yourself
]

{ #category : #'world menu' }
MiTagBrowser class >> menuCommandOn: aBuilder [
	<worldMenu>
	<miBrowsers>
	^(aBuilder item: #FilesBrowser)
		parent: self midasBrowserMenuLabel;
		label: self title;
		help: self helpMessage;
		order: 5;
		action: [ self open ] ;
		yourself
]

{ #category : #'instance creation' }
MiTagBrowser class >> mostRecentModel [
	^ self currentApplication defaultBus logger mostRecentEntity
		ifNotNil: [ :entity | entity mooseModel ]
		ifNil: [ MooseModel new ]
]

{ #category : #'instance creation' }
MiTagBrowser class >> newModel [

	^ MiTagBrowserModel new
]

{ #category : #'instance creation' }
MiTagBrowser class >> open [
	<script>
	^ super open
]

{ #category : #specs }
MiTagBrowser class >> title [
	^ 'Tag browser'
]

{ #category : #specs }
MiTagBrowser class >> windowSize [

	^ 700 @ 475
]

{ #category : #testing }
MiTagBrowser >> accept: anObject [

	^ (anObject isCollection and: [ 
		   anObject anySatisfy: [ :a | a usesFamixTrait: FamixTNamedEntity ] ]) 
		  or: [ anObject isMooseModel ]
]

{ #category : #testing }
MiTagBrowser >> canFollowEntity: anObject [
	^ anObject isCollection
		and: [ anObject
				anySatisfy: [ :a | a usesFamixTrait: FamixTNamedEntity ] ]
]

{ #category : #initialization }
MiTagBrowser >> descriptionPage [

	^ self tagIsIntent
		  ifTrue: [ self instantiate: MiTagIntentPage on: self ]
		  ifFalse: [ self instantiate: MiTagExtentPage on: self ]
]

{ #category : #actions }
MiTagBrowser >> followEntity: anEntity [

	tagModel entities: anEntity.
]

{ #category : #initialization }
MiTagBrowser >> initialize [
	super initialize.
	tagIsIntent := true
]

{ #category : #initialization }
MiTagBrowser >> initializePresenters [

	| tagDescriptionPage |
	self initializeTagManagementPage.
	tagIntentPage := self instantiate: MiTagIntentPage on: self.
	tagExtentPage := self instantiate: MiTagExtentPage on: self.
	tagDescriptionPage := self newNotebookPage
		title: 'Tag description' ;
		presenterProvider: [
			self descriptionPage
				onBrowserPageRedisplay ;
				yourself
		] ;
		yourself.
	mainPresenter := self newNotebook
		whenSelectedPageChangedDo: [ :newPage :oldPage  |
			newPage = tagDescriptionPage
			ifTrue: [ tagDescriptionPage resetContent ] ] ;
		addPage: tagManagementPage;
		addPage: tagDescriptionPage;
		yourself
]

{ #category : #initialization }
MiTagBrowser >> initializeTagManagementPage [

	tagManagementPage := self newNotebookPage
		title: MiTagManagementPage defaultTitle ;
		presenterProvider: [
			self instantiate: MiTagManagementPage on: self ];
		yourself
]

{ #category : #accessing }
MiTagBrowser >> miSelectedItem [

	^ tagModel entities
]

{ #category : #'accessing - model' }
MiTagBrowser >> setModelBeforeInitialization: aTagModel [

	tagModel := aTagModel.
	tagModel tagBrowser: self
]

{ #category : #actions }
MiTagBrowser >> tagDefinedBytIntent: aBoolean [
	tagIsIntent := aBoolean
]

{ #category : #initialization }
MiTagBrowser >> tagIsIntent [
	^tagIsIntent
	"self tagModel isIntentTag"
]

{ #category : #accessing }
MiTagBrowser >> tagModel [ 
	^tagModel
]
