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
		'tagButton',
		'dynamicTagButton'
	],
	#category : #'MooseIDE-Tagging-Browser'
}

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

{ #category : #action }
MiTagManagementPage >> editCurrentTag [

	self owner openTagEditionForm
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
					  add: categoryManagement expand: false;
					  add: (SpBoxLayout newLeftToRight
							   add: 'Tags' asPresenter;
							   hAlignCenter;
							   yourself)
					  expand: false;
					  add: tagList;
					  yourself)
			 width: 200;
			 add: sep width: 2;
			 add: descriptionPage;
			 yourself)
]

{ #category : #initialization }
MiTagManagementPage >> initializePresenters [

	categoryManagement := self instantiate: MiTagCategoriesPresenter on: tagModel.
	descriptionPage := self instantiate: MiTagExtentPage on: tagModel.
	descriptionPage hide.
	tagList := self instantiate: MiTagListPresenter.
	tagList display: [ :aTag | aTag name ].
	tagList list
		displayIcon: [ :aTag | self tagModel iconForTag: aTag ];
		whenSelectionChangedDo: [ :selection | 
			selection selectedItem ifNotNil: [ :item | self setTagTo: item ] ].
	tagList addButton action: [ self owner openTagCreationForm ].
	self initializeLayout
]

{ #category : #refreshing }
MiTagManagementPage >> refresh [

	self refreshDescriptionPage.
	self refreshTagList.
	self refreshCategoryList.
	descriptionPage refreshEntitiesList.
	descriptionPage refreshTaggedEntitiesList.
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

	| sortingBlock |
	sortingBlock := [ :t1 :t2 | t1 name <= t2 name ].
	tagList items: (tagModel currentCategory
			 ifNil: [ self tagModel allTags sort: sortingBlock ]
			 ifNotNil: [ :currentTag | currentTag markedTags asMooseGroup ])
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
	descriptionPage setTag: aTag.
	descriptionPage show.
	descriptionPage refreshEntitiesList.
	descriptionPage refreshTaggedEntitiesList.
	self update
]

{ #category : #accessing }
MiTagManagementPage >> tagModel [

	^ tagModel
]
