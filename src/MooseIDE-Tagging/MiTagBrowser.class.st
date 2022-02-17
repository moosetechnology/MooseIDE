"
A tool to manage tags

Allows to create new tag, give them name, put them in a hierarchy of tags, give them a color, and of course add or remove entities carrying a tag

"
Class {
	#name : #MiTagBrowser,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'tagModel',
		'tagManagementPage',
		'tagIntentPage',
		'tagExtentPage',
		'tagIsIntent',
		'tagCreationForm',
		'tagEditionForm'
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

{ #category : #initialization }
MiTagBrowser >> browserClosed [

	super browserClosed.
	application unregisterProducer: self.
	application unregisterConsumer: self
]

{ #category : #testing }
MiTagBrowser >> canFollowEntity: anObject [

	^ anObject isMooseObject
]

{ #category : #initialization }
MiTagBrowser >> closeTagCreationForm [

	self layout replace: tagCreationForm with: tagManagementPage
]

{ #category : #initialization }
MiTagBrowser >> closeTagEditionForm [

	self layout replace: tagEditionForm with: tagManagementPage
]

{ #category : #testing }
MiTagBrowser >> consume: aTagAssociation [

	tagModel currentTag = aTagAssociation tag ifTrue: [ 
		tagManagementPage refreshTaggedEntitiesList ]
]

{ #category : #testing }
MiTagBrowser >> createTag: name description: aText color: aColor category: aCategory [

	| newTag |
	newTag := tagModel addTag: name.
	(aText notNil and: [ aText isNotEmpty ]) ifTrue: [ 
		newTag description: aText ].
	aColor ifNotNil: [ newTag color: aColor ].
	tagManagementPage refreshTagList.
	aCategory ifNotNil: [ 
		aCategory addTag: newTag.
		newTag addCategory: aCategory ].
	application consumeItem: newTag
]

{ #category : #'as yet unclassified' }
MiTagBrowser >> descriptionPage [

	^ tagManagementPage descriptionPage
]

{ #category : #actions }
MiTagBrowser >> editCurrentTag: name description: description color: color category: category [

	| tag |
	tag := tagModel currentTag.
	tag ifNil: [ ^ false ].

	(name isNil or: [ name isEmpty ]) ifTrue: [ ^ false ].

	tag name: name.
	tag description: description.
	tag color: color.
	tag categories ifNotEmpty: [ 
		tag removeCategory: tag categories first ].
	category ifNotNil: [ tag addCategory: category ].
	tagManagementPage refresh.
	^ true
]

{ #category : #actions }
MiTagBrowser >> followEntity: anEntity [

	tagModel entities: (anEntity isCollection
			 ifTrue: [ anEntity ]
			 ifFalse: [ anEntity asMooseGroup ]).
	tagManagementPage refresh
]

{ #category : #initialization }
MiTagBrowser >> initialize [

	super initialize.
	application registerProducer: self for: FamixTag.
	application registerConsumer: self for: FamixTagAssociation
]

{ #category : #initialization }
MiTagBrowser >> initializeLayout [

	self layout: (SpBoxLayout newLeftToRight
			 add: tagManagementPage;
			 yourself)
]

{ #category : #initialization }
MiTagBrowser >> initializePresenters [

	tagCreationForm := self instantiate: MiTagCreationForm on: tagModel.
	tagManagementPage := self instantiate: MiTagManagementPage on: tagModel.
	tagEditionForm := self instantiate: MiTagEditionForm on: tagModel. 
	self initializeLayout
]

{ #category : #brokerage }
MiTagBrowser >> itemsFor: aClass [

	^ tagModel allTags
]

{ #category : #accessing }
MiTagBrowser >> miSelectedItem [

	^ tagModel currentTag
		  ifNil: [ ^ nil ]
		  ifNotNil: [ :tag | tag taggedEntities asMooseGroup ]
]

{ #category : #testing }
MiTagBrowser >> newTagSelected [

	self updateToolbar
]

{ #category : #initialization }
MiTagBrowser >> openTagCreationForm [

	tagCreationForm
		reset;
		updateCategories.
	self layout replace: tagManagementPage with: tagCreationForm.
	tagCreationForm update
]

{ #category : #initialization }
MiTagBrowser >> openTagEditionForm [

	tagEditionForm
		reset;
		updateCategories.
	self layout replace: tagManagementPage with: tagEditionForm.
	tagEditionForm fillWithCurrentTag.
	tagEditionForm update
]

{ #category : #testing }
MiTagBrowser >> remove: aTagAssociation [

	tagManagementPage refreshTaggedEntitiesList 
]

{ #category : #'accessing - model' }
MiTagBrowser >> setModelBeforeInitialization: aTagModel [

	tagModel := aTagModel.
	tagModel tagBrowser: self
]

{ #category : #initialization }
MiTagBrowser >> setTagTo: aTag [

	self tagModel currentTag: aTag.
]

{ #category : #testing }
MiTagBrowser >> tagModel [

	^ tagModel
]
