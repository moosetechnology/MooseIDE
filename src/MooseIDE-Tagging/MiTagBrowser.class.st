"
A tool to manage tags

Allows to create new tag, give them name, put them in a hierarchy of tags, give them a color, and of course add or remove entities carrying a tag.

Accepted entities: a MooseObject.

"
Class {
	#name : 'MiTagBrowser',
	#superclass : 'MiAbstractBrowser',
	#instVars : [
		'tagManagementPage',
		'staticTagDescriptionPage',
		'dynamicTagDescriptionPage',
		'descriptionPage',
		'separator'
	],
	#category : 'MooseIDE-Tagging-Browser',
	#package : 'MooseIDE-Tagging',
	#tag : 'Browser'
}

{ #category : 'keymaps' }
MiTagBrowser class >> browserKey [

	^ $t
]

{ #category : 'world menu' }
MiTagBrowser class >> menuCommandOn: aBuilder [

	<worldMenu>
	<miBrowsersMenu>
	^ self buildMenuItemIn: aBuilder
]

{ #category : 'world menu' }
MiTagBrowser class >> menuItem [

	^ #FilesBrowser
]

{ #category : 'world menu' }
MiTagBrowser class >> menuPriority [

	^ self menuMainToolsPriority + 4
]

{ #category : 'instance creation' }
MiTagBrowser class >> mostRecentModel [

	^ self currentApplication defaultBus logger mostRecentEntity
		  ifNotNil: [ :entity | entity mooseModel ]
		  ifNil: [ MooseModel new ]
]

{ #category : 'instance creation' }
MiTagBrowser class >> newModel [

	^ MiTagBrowserModel new
]

{ #category : 'instance creation' }
MiTagBrowser class >> open [

	<script>
	^ super open
]

{ #category : 'specs' }
MiTagBrowser class >> preferredExtent [

	^ 700 @ 475
]

{ #category : 'specs' }
MiTagBrowser class >> title [

	^ 'Tag browser'
]

{ #category : 'initialization' }
MiTagBrowser >> browserClosed [

	super browserClosed.

	application unregisterProducer: self.
	application unregisterConsumer: self
]

{ #category : 'testing' }
MiTagBrowser >> canFollowEntity: anObject [

	^ anObject isMooseObject
]

{ #category : 'testing' }
MiTagBrowser >> canTagEntities [
	"tagging done in the browser main window, not through the toolbar"

	^false
]

{ #category : 'testing' }
MiTagBrowser >> consume: anObject [
	anObject class = FamixTag ifTrue: [ 
		tagManagementPage refreshTagList
	].
	
	anObject class = FamixTagAssociation ifTrue: [ 
		specModel currentTag = anObject tag 
			ifTrue: [ tagManagementPage refreshTaggedEntitiesList ] ]
]

{ #category : 'initialization' }
MiTagBrowser >> createTag [
	"returning the MiTagCreationForm allows to test it"

	^MiTagCreationForm new 
		tagBrowser: self ;
		open ;
		yourself
]

{ #category : 'accessing' }
MiTagBrowser >> descriptionPage [

	^descriptionPage
]

{ #category : 'initialization' }
MiTagBrowser >> editCurrentTag [
	"returning the MiTagCreationForm allows to test it"

	^MiTagEditionForm new 
		tagBrowser: self ;
		open ;
		yourself
]

{ #category : 'initialization' }
MiTagBrowser >> editTag: aTag [
	"returning the MiTagCreationForm allows to test it"

	^MiTagEditionForm new 
		tagBrowser: self ;
		fillFormWithTag: aTag ;
		open ;
		yourself
]

{ #category : 'actions' }
MiTagBrowser >> followEntity: anEntity [

	super followEntity: anEntity.
	specModel entities: anEntity asMooseGroup.
	specModel mooseModel
		ifNil: [ self showNoMooseModel ].
	tagManagementPage refresh
]

{ #category : 'refreshing' }
MiTagBrowser >> hideDescriptionPage [

	descriptionPage hide
]

{ #category : 'initialization' }
MiTagBrowser >> initialize [

	super initialize.
	application registerProducer: self for: MiDynamicTag.
	application registerProducer: self for: FamixTag.
	application registerConsumer: self for: FamixTag.
	application registerConsumer: self for: FamixTagAssociation.
]

{ #category : 'initialization' }
MiTagBrowser >> initializeLayout [

	| sep |
	sep := self separator.

	self layout: (SpBoxLayout newLeftToRight
			 spacing: 4;
			 add: tagManagementPage width: 200;
			 add: sep width: 2;
			 add: descriptionPage;
			 yourself).

	self showNoMooseModel
	
]

{ #category : 'initialization' }
MiTagBrowser >> initializePresenters [

	separator := SpRoassalPresenter new.
	separator canvas
		color: (Color
			r: 40
			g: 40
			b: 40
			range: 255) translucent.

	tagManagementPage := MiTagManagementPage newApplication: self application owner: self model: specModel.

	staticTagDescriptionPage := self instantiate: MiTagExtentPage.
	dynamicTagDescriptionPage := self instantiate: MiTagIntentPage.
	descriptionPage := staticTagDescriptionPage.

	self initializeLayout
]

{ #category : 'brokerage' }
MiTagBrowser >> itemsFor: aClass [

	aClass = MiDynamicTag ifTrue: [ ^ specModel dynamicTags ].
	aClass = FamixTag ifTrue: [ ^ specModel allTags ].
	^ #(  )
]

{ #category : 'accessing' }
MiTagBrowser >> miSelectedItem [

	^ specModel miSelectedItem
]

{ #category : 'testing' }
MiTagBrowser >> newTagSelected [

	self updateToolbar
]

{ #category : 'initialization' }
MiTagBrowser >> preparePageFor: aTag [

	aTag isIntent ifTrue: [
			self layout replace: descriptionPage with: dynamicTagDescriptionPage.
			descriptionPage := dynamicTagDescriptionPage.
			^ self ].

	self layout replace: descriptionPage with: staticTagDescriptionPage.

	descriptionPage := staticTagDescriptionPage
]

{ #category : 'accessing' }
MiTagBrowser >> refreshDescriptionPage [

	self setRightPart: descriptionPage.
	descriptionPage refresh
]

{ #category : 'refreshing' }
MiTagBrowser >> refreshTagList [

	tagManagementPage refreshTagList
]

{ #category : 'testing' }
MiTagBrowser >> remove: aTagAssociation [

]

{ #category : 'accessing' }
MiTagBrowser >> selectedItems [

	^ staticTagDescriptionPage selectedItems
]

{ #category : 'accessing' }
MiTagBrowser >> separator [

	^separator 
]

{ #category : 'initialization' }
MiTagBrowser >> setRightPart: aSpPresenter [
	"We need to replace the right part of the window (descriptionPage) with the new presenter
	 This part is the 3rd presenter in the layout
	 So if this right part is not the same as aSpPresenter, we remove it and then add the correct one"

	(layout presenters third = aSpPresenter) ifTrue: [ ^self ].

	layout remove: layout presenters third.
	layout add: aSpPresenter 

]

{ #category : 'initialization' }
MiTagBrowser >> setTagTo: aTag [

	self specModel currentTag: aTag.

	self preparePageFor: aTag.
	descriptionPage setTag: aTag.
	descriptionPage show.

	self refreshDescriptionPage.
	self updateToolbar
]

{ #category : 'initialization' }
MiTagBrowser >> showNoMooseModel [

	self setRightPart: (SpPresenter new
		layout: (SpBoxLayout newTopToBottom
			vAlignCenter;
			hAlignCenter;
			add: 'No available moose model in selected buses.';
			add: 'Propagate entities or moose model on selected buses.';
			yourself);
		yourself)
]

{ #category : 'accessing' }
MiTagBrowser >> tagManagementPage [
	"see `MiTagManagementPage` : left part of the browser allowing to create, select, or remove tags"

	^ tagManagementPage
]
