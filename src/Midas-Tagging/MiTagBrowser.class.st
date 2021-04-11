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
