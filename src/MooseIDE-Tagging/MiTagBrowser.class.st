"
A tool to manage tags

Allows to create new tag, give them name, put them in a hierarchy of tags, give them a color, and of course add or remove entities carrying a tag.

Accepted entities: a MooseObject.

"
Class {
	#name : 'MiTagBrowser',
	#superclass : 'MiAbstractBrowser',
	#instVars : [
		'tagManagementPage'
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

{ #category : 'initialization' }
MiTagBrowser >> closeTagCreationForm [

	self layout child: tagManagementPage.
	self updateToolbar
]

{ #category : 'initialization' }
MiTagBrowser >> closeTagEditionForm [

	self layout child: tagManagementPage
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

{ #category : 'accessing' }
MiTagBrowser >> descriptionPage [

	^ tagManagementPage descriptionPage
]

{ #category : 'actions' }
MiTagBrowser >> followEntity: anEntity [

	specModel entities: anEntity asMooseGroup.
	specModel mooseModel
		ifNil: [ self showNoMooseModel ]
		ifNotNil: [ self closeTagCreationForm ].
	tagManagementPage refresh
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

	self layout: (SpScrollableLayout with: tagManagementPage).
	"At start browser has no moose model"
	self showNoMooseModel
	
]

{ #category : 'initialization' }
MiTagBrowser >> initializePresenters [

	tagManagementPage := MiTagManagementPage newApplication: self application owner: self model: specModel.
	"tagEditionForm := self instantiate: MiTagEditionForm on: specModel. "
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
MiTagBrowser >> openTagCreationForm [

	MiTagCreationForm new 
		tagBrowser: self ;
		updateCategories ;
		open
]

{ #category : 'initialization' }
MiTagBrowser >> openTagEditionForm [

	tagEditionForm
		reset;
		updateCategories.
	self layout child: tagEditionForm.
	tagEditionForm fillWithCurrentTag.
	tagEditionForm update
]

{ #category : 'accessing' }
MiTagBrowser >> refreshDescriptionPage [

	tagManagementPage refreshDescriptionPage
]

{ #category : 'refreshing' }
MiTagBrowser >> refreshTagList [

	tagManagementPage refreshTagList
]

{ #category : 'testing' }
MiTagBrowser >> remove: aTagAssociation [

	tagManagementPage refreshTaggedEntitiesList 
]

{ #category : 'initialization' }
MiTagBrowser >> setTagTo: aTag [

	self specModel currentTag: aTag.
	self updateToolbar
]

{ #category : 'initialization' }
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

{ #category : 'accessing' }
MiTagBrowser >> tagManagementPage [
	"see `MiTagManagementPage` : left part of the browser allowing to create, select, or remove tags"

	^ tagManagementPage
]

{ #category : 'testing' }
MiTagBrowser >> tagModel [

	^ specModel
]
