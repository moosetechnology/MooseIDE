"
A tool to manage tags

Allows to create new tag, give them name, put them in a hierarchy of tags, give them a color, and of course add or remove entities carrying a tag

"
Class {
	#name : #MiTagBrowser,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'mainPresenter',
		'tagDetailsPage',
		'tagModel',
		'tagManagementPage'
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

	^ (anObject isCollection and: [ 
		   anObject anySatisfy: [ :a | a usesFamixTrait: FamixTNamedEntity ] ]) 
		  or: [ anObject isMooseModel ]
]

{ #category : #testing }
MiTagBrowser >> canReceiveEntity: anObject [
	^ anObject isCollection
		and: [ anObject
				anySatisfy: [ :a | a usesFamixTrait: FamixTNamedEntity ] ]
]

{ #category : #actions }
MiTagBrowser >> followEntity: anEntity [

	tagModel entities: anEntity.
	tagDetailsPage resetContent
]

{ #category : #initialization }
MiTagBrowser >> initializePresenters [

	self initializeTagManagementPage.
	self initializeTagDetailsPage.
	mainPresenter := self newNotebook
		                 addPage: tagManagementPage;
		                 addPage: tagDetailsPage;
		                 yourself
]

{ #category : #initialization }
MiTagBrowser >> initializeTagDetailsPage [

	tagDetailsPage := self
		                  newTagPage: MiTagDetailPage
		                  title: 'Tag details'
]

{ #category : #initialization }
MiTagBrowser >> initializeTagManagementPage [

	tagManagementPage := self
		                     newTagPage: MiTagManagementPage
		                     title: 'Manage tags'
]

{ #category : #accessing }
MiTagBrowser >> miSelectedItem [

	^ tagModel entities
]

{ #category : #initialization }
MiTagBrowser >> newTagPage: aMiPresenterClass title: aString [

	^ self newNotebookPage
		  title: aString;
		  presenterProvider: [ 
			  (self instantiate: aMiPresenterClass on: self)
				  onBrowserPageRedisplay;
				  yourself ];
		  yourself
]

{ #category : #actions }
MiTagBrowser >> newTagSelected [
	tagDetailsPage resetContent
]

{ #category : #'accessing - model' }
MiTagBrowser >> setModelBeforeInitialization: aTagModel [

	tagModel := aTagModel.
	tagModel tagBrowser: self
]

{ #category : #accessing }
MiTagBrowser >> tagModel [ 
	^tagModel
]
