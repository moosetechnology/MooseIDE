"
A tool to manage tags

Allows to create new tag, give them name, put them in a hierarchy of tags, give them a color, and of course add or remove entities carrying a tag.

Accepted entities: a MooseObject.

"
Class {
	#name : #MiTagBrowser,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'tagManagementPage',
		'tagCreationForm',
		'tagEditionForm'
	],
	#category : #'MooseIDE-Tagging-Browser'
}

{ #category : #layout }
MiTagBrowser class >> defaultLayout [

	^ super defaultLayout
		  add: #mainPresenter;
		  yourself
]

{ #category : #'world menu' }
MiTagBrowser class >> menuCommandOn: aBuilder [

	<worldMenu>
	^ self buildMenuItemIn: aBuilder
]

{ #category : #'world menu' }
MiTagBrowser class >> menuItem [

	^ #FilesBrowser
]

{ #category : #'world menu' }
MiTagBrowser class >> menuPriority [

	^ self menuMainToolsPriority + 4
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
	application unregisterConsumer: self.
	application unregisterConsumer: tagCreationForm
]

{ #category : #testing }
MiTagBrowser >> canFollowEntity: anObject [

	^ anObject isMooseObject
]

{ #category : #testing }
MiTagBrowser >> canTagEntities [
	"tagging done in the browser main window, not through the toolbar"
	^false
]

{ #category : #initialization }
MiTagBrowser >> closeTagCreationForm [

	self layout child: tagManagementPage
]

{ #category : #initialization }
MiTagBrowser >> closeTagEditionForm [

	self layout child: tagManagementPage
]

{ #category : #testing }
MiTagBrowser >> consume: anObject [
	anObject class = FamixTag ifTrue: [ 
		tagManagementPage refreshTagList
	].
	
	anObject class = FamixTagAssociation ifTrue: [ 
		specModel currentTag = anObject tag 
			ifTrue: [ tagManagementPage refreshTaggedEntitiesList ] ]
]

{ #category : #testing }
MiTagBrowser >> createDynamicTag: name description: aText color: aColor category: aCategory query: aQuery [

	| newTag |
	(name notNil and: [ name isNotEmpty ]) ifFalse: [ ^ self ].
	newTag := MiDynamicTag new.
	(aText notNil and: [ aText isNotEmpty ]) ifTrue: [ 
		newTag description: aText ].
	newTag name: name.
	aColor ifNotNil: [ newTag color: aColor ].

	aCategory ifNotNil: [ newTag category: aCategory ].

	aQuery
		ifNotNil: [ newTag query: aQuery ]
		ifNil: [ newTag query: FQNullQuery new ].
	specModel addDynamicTag: newTag.
	application consumeItem: newTag.
	tagManagementPage refreshTagList
]

{ #category : #testing }
MiTagBrowser >> createTag: name description: aText color: aColor category: aCategory [

	| newTag |
	newTag := specModel addTag: name.
	(aText notNil and: [ aText isNotEmpty ]) ifTrue: [ 
		newTag description: aText ].
	aColor ifNotNil: [ newTag color: aColor ].
	tagManagementPage refreshTagList.
	aCategory ifNotNil: [ 
		aCategory addTag: newTag.
		newTag addCategory: aCategory ].
	application consumeItem: newTag
]

{ #category : #accessing }
MiTagBrowser >> descriptionPage [

	^ tagManagementPage descriptionPage
]

{ #category : #actions }
MiTagBrowser >> editCurrentDynamicTag: name description: description color: color category: category query: query [

	| tag |
	tag := specModel currentTag.
	tag ifNil: [ ^ false ].

	(name isNil or: [ name isEmpty ]) ifTrue: [ ^ false ].

	tag name: name.
	tag description: description.
	tag color: color.
	category ifNotNil: [ tag category: category ].
	tag query: query.
	tagManagementPage refresh.
	^ true
]

{ #category : #actions }
MiTagBrowser >> editCurrentTag: name description: description color: color category: category [

	| tag |
	tag := specModel currentTag.
	tag ifNil: [ ^ false ].

	(name isNil or: [ name isEmpty ]) ifTrue: [ ^ false ].

	tag name: name.
	tag description: description.
	tag color: color.
	tag categories ifNotEmpty: [ 
		tag removeCategory: tag categories first ].
	category ifNotNil: [ tag addCategory: category ].
	tagManagementPage refresh.
	self application updateItem: tag.
	^ true
]

{ #category : #actions }
MiTagBrowser >> followEntity: anEntity [

	specModel entities: anEntity asMooseGroup.
	specModel mooseModel
		ifNil: [ self showNoMooseModel ]
		ifNotNil: [ self closeTagCreationForm ].
	tagManagementPage refresh
]

{ #category : #initialization }
MiTagBrowser >> initialize [

	super initialize.
	application registerProducer: self for: MiDynamicTag.
	application registerProducer: self for: FamixTag.
	application registerConsumer: self for: FamixTag.
	application registerConsumer: self for: FamixTagAssociation.
	application registerConsumer: tagCreationForm for: FQAbstractQuery
]

{ #category : #initialization }
MiTagBrowser >> initializeLayout [

	self layout: (SpScrollableLayout with: tagManagementPage).
	"At start browser has no moose model"
	self showNoMooseModel
	
]

{ #category : #initialization }
MiTagBrowser >> initializePresenters [

	tagCreationForm := self instantiate: MiTagCreationForm on: specModel.
	tagManagementPage := MiTagManagementPage newApplication: self application owner: self model: specModel.
	tagEditionForm := self instantiate: MiTagEditionForm on: specModel. 
	self initializeLayout
]

{ #category : #brokerage }
MiTagBrowser >> itemsFor: aClass [

	aClass = MiDynamicTag ifTrue: [ ^ specModel dynamicTags ].
	aClass = FamixTag ifTrue: [ ^ specModel allTags ].
	^ #(  )
]

{ #category : #accessing }
MiTagBrowser >> miSelectedItem [

	^ specModel currentTag
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
	self layout child: tagCreationForm
]

{ #category : #initialization }
MiTagBrowser >> openTagEditionForm [

	tagEditionForm
		reset;
		updateCategories.
	self layout child: tagEditionForm.
	tagEditionForm fillWithCurrentTag.
	tagEditionForm update
]

{ #category : #testing }
MiTagBrowser >> remove: aTagAssociation [

	tagManagementPage refreshTaggedEntitiesList 
]

{ #category : #initialization }
MiTagBrowser >> setTagTo: aTag [

	self model currentTag: aTag.
]

{ #category : #actions }
MiTagBrowser >> settings [
	
]

{ #category : #initialization }
MiTagBrowser >> showNoMooseModel [

	self layout child: (SpPresenter new
			 layout: (SpBoxLayout newTopToBottom
					  vAlignCenter;
					  hAlignCenter;
					  add: 'No available moose model in selected buses.' asPresenter;
					  add:
						  'Propagate entities or moose model on selected buses.'
							  asPresenter;
					  yourself);
			 yourself)
]

{ #category : #accessing }
MiTagBrowser >> tagCreationForm [

	^ tagCreationForm
]

{ #category : #accessing }
MiTagBrowser >> tagManagementPage [

	^ tagManagementPage
]

{ #category : #testing }
MiTagBrowser >> tagModel [

	^ specModel
]
