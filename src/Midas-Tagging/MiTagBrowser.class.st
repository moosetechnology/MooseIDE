"
A tool to manage tags

Allows to create new tag, give them name, put them in a hierarchy of tags, give them a color, and of course add or remove entities carrying a tag

"
Class {
	#name : #MiTagBrowser,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'mainPresenter',
		'manageTagsPage',
		'tagDetailsPage',
		'tagModel'
	],
	#category : #'Midas-Tagging'
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
		action: [ self runMe ] ;
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
	^MiTagBrowserModel new
		logger: (self currentApplication defaultBus logger) ;
		yourself
]

{ #category : #'instance creation' }
MiTagBrowser class >> runMe [
	<script>
	^ super runMe
]

{ #category : #'world menu' }
MiTagBrowser class >> title [
	^ 'Tag browser'
]

{ #category : #specs }
MiTagBrowser class >> windowSize [

	^ 700 @ 475
]

{ #category : #testing }
MiTagBrowser >> accept: anObject [
	^ anObject isCollection
		and: [ anObject
				anySatisfy: [ :a | a usesFamixTrait: FamixTNamedEntity ] ]
]

{ #category : #actions }
MiTagBrowser >> followAction [
	(self accept: toSelect)
		ifFalse: [ ^ self ].
	tagDetailsPage resetContent

]

{ #category : #initialization }
MiTagBrowser >> initializePresenters [

	super initializePresenters.
	mainPresenter := self newNotebook
		addPage: self manageTagsPage ;
		addPage: self tagDetailsPage ;
		yourself
]

{ #category : #initialization }
MiTagBrowser >> manageTagsPage [
	^manageTagsPage ifNil: [ 
		manageTagsPage := self newTagPage: MiTagManagementPage title:'Manage tags'
	]
]

{ #category : #initialization }
MiTagBrowser >> newTagPage: aMiPresenterClass title: aString [
	^self newNotebookPage
		title: aString ;
		presenterProvider: [
			(self instantiate: aMiPresenterClass)
				tagModel: self tagModel ;
				onBrowserPageRedisplay ;
				yourself
		] ;
		yourself
]

{ #category : #initialization }
MiTagBrowser >> newTagSelected [
	tagDetailsPage resetContent
]

{ #category : #'accessing model' }
MiTagBrowser >> setModelBeforeInitialization: aTagModel [
	tagModel := aTagModel.
	tagModel owner: self
]

{ #category : #initialization }
MiTagBrowser >> tagDetailsPage [
	^tagDetailsPage ifNil: [ 
		tagDetailsPage := self newTagPage: MiTagDetailPage title:'Tag details'
	]
]

{ #category : #accessing }
MiTagBrowser >> tagModel [ 
	^tagModel
]
