"
The page of the TagBrowser allowing to create, select, or remove tags
"
Class {
	#name : #MiTagManagementPage,
	#superclass : #MiPresenter,
	#instVars : [
		'categoryManagement',
		'tagList',
		'descriptionPage',
		'tagModel',
		'tagDescriptionPage',
		'dynamicTagDescriptionPage',
		'addTagButton',
		'btnIsExtent',
		'btnIsIntent'
	],
	#category : #'MooseIDE-Tagging-Browser'
}

{ #category : #accessing }
MiTagManagementPage >> addTagButton [

	^ addTagButton
]

{ #category : #initialization }
MiTagManagementPage >> connectPresenters [

	btnIsExtent action: [ self refreshTagList ].
	btnIsIntent action: [ self refreshTagList ]
]

{ #category : #action }
MiTagManagementPage >> deleteCurrentTag [

	|tag|
	tag := tagModel deleteCurrentTag.
	self owner application removeItem: tag.
	descriptionPage hide.
	self refreshTagList
]

{ #category : #accessing }
MiTagManagementPage >> descriptionPage [

	^ descriptionPage
]

{ #category : #accessing }
MiTagManagementPage >> dynamicTagDescriptionPage [

	^ dynamicTagDescriptionPage
]

{ #category : #action }
MiTagManagementPage >> editCurrentTag [

	self owner openTagEditionForm
]

{ #category : #accessing }
MiTagManagementPage >> extentTagButton [

	^ btnIsExtent
]

{ #category : #initialization }
MiTagManagementPage >> initializeLayout [

	| sep |
	(sep := SpRoassalPresenter new) canvas color: (Color
			 r: 40
			 g: 40
			 b: 40
			 range: 255) translucent.

	self layout: (SpBoxLayout newLeftToRight
			 spacing: 4;
			 add: (SpBoxLayout newTopToBottom
					  spacing: 5;
					  add: categoryManagement expand: false;
					  add: (SpBoxLayout newLeftToRight
							   add: 'Tag list' asPresenter;
							   hAlignCenter;
							   yourself)
					  expand: false;
					  add: (SpBoxLayout newLeftToRight
							   spacing: 3;
							   add: btnIsExtent;
							   add: btnIsIntent;
							   yourself)
					  expand: false;
					  add: addTagButton height: 25;
					  add: tagList;
					  yourself)
			 width: 200;
			 add: sep width: 2;
			 add: descriptionPage;
			 yourself)
]

{ #category : #initialization }
MiTagManagementPage >> initializePresenters [

	categoryManagement := self
		instantiate: MiTagCategoriesPresenter
		on: tagModel.

	tagDescriptionPage := self instantiate: MiTagExtentPage on: tagModel.
	dynamicTagDescriptionPage := self
		instantiate: MiTagIntentPage
		on: tagModel.
	descriptionPage := tagDescriptionPage.
	descriptionPage hide.

	btnIsExtent := self newToggleButton
		state: true;
		label: 'Extent';
		yourself.
	btnIsIntent := self newToggleButton
		state: false;
		label: 'Intent';
		yourself.

	tagList := self newList.
	tagList display: [ :aTag | aTag name ].
	tagList
		displayIcon: [ :aTag | self tagModel class iconForTag: aTag ];
		whenSelectionChangedDo: [ :selection | 
			selection selectedItem ifNotNil: [ :item | self setTagTo: item ] ].
	addTagButton := self newButton icon: (Smalltalk iconNamed: #smallAdd).
	addTagButton action: [ self owner openTagCreationForm ].


	self initializeLayout
]

{ #category : #accessing }
MiTagManagementPage >> intentTagButton [

	^ btnIsIntent
]

{ #category : #action }
MiTagManagementPage >> preparePageFor: aTag [

	aTag isIntent ifTrue: [ 
		self layout replace: descriptionPage with: dynamicTagDescriptionPage.
		descriptionPage := dynamicTagDescriptionPage.
		^ self ].
	self layout replace: descriptionPage with: tagDescriptionPage.
	descriptionPage := tagDescriptionPage
]

{ #category : #refreshing }
MiTagManagementPage >> refresh [

	self refreshDescriptionPage.
	self refreshTagList.
	self refreshCategoryList.
	descriptionPage refresh.
]

{ #category : #refreshing }
MiTagManagementPage >> refreshCategoryList [

	categoryManagement refreshCategoryList
]

{ #category : #refreshing }
MiTagManagementPage >> refreshDescriptionPage [

	descriptionPage refresh
]

{ #category : #refreshing }
MiTagManagementPage >> refreshTagList [

	| sortingBlock isExtent isIntent extentTags intentTags |
	sortingBlock := [ :t1 :t2 | t1 name <= t2 name ].

	isExtent := btnIsExtent state.
	isIntent := btnIsIntent state.
	extentTags := [ 
	     tagModel currentCategory
		     ifNil: [ self tagModel allTags ]
		     ifNotNil: [ :currentTag | currentTag markedTags asMooseGroup ] ].
	intentTags := [ 
	      tagModel currentCategory
		      ifNil: [ self tagModel dynamicTags ]
		      ifNotNil: [ :currentCat | 
			      self tagModel dynamicTags select: [ :tag | 
				      tag category = currentCat ] ] ].
	
	tagList items:
		( (isExtent ifTrue: [ extentTags value ] ifFalse: [ #() ]) 
		  ,
		  (isIntent ifTrue: [ intentTags value ] ifFalse: [ #() ])
		sort: sortingBlock )

]

{ #category : #initialization }
MiTagManagementPage >> refreshTaggedEntitiesList [

	descriptionPage refreshTaggedEntitiesList
]

{ #category : #action }
MiTagManagementPage >> removeCategory [

	self tagModel deleteCurrentCategory.
	self refreshCategoryList
]

{ #category : #initialization }
MiTagManagementPage >> setModelBeforeInitialization: aTagModel [

	tagModel := aTagModel
]

{ #category : #action }
MiTagManagementPage >> setTagTo: aTag [

	self owner setTagTo: aTag.
	self preparePageFor: aTag.
	descriptionPage setTag: aTag.
	descriptionPage show.
	descriptionPage refresh.
	self update
]

{ #category : #accessing }
MiTagManagementPage >> tagList [

	^ tagList
]

{ #category : #accessing }
MiTagManagementPage >> tagModel [

	^ tagModel
]
