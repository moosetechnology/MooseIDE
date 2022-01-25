"
The page of the TagBrowser allowing to create, select, or remove tags
"
Class {
	#name : #MiTagManagementPage,
	#superclass : #MiPresenter,
	#instVars : [
		'categoryManagement',
		'tagList',
		'descriptionPage'
	],
	#category : #'MooseIDE-Tagging-Browser'
}

{ #category : #action }
MiTagManagementPage >> deleteCurrentTag [

	self tagModel deleteCurrentTag.
	descriptionPage hide.
	self refreshTagList
]

{ #category : #initialization }
MiTagManagementPage >> initialize [

	super initialize
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
					  spacing: 3;
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

	descriptionPage := MiTagExtentPage owner: self.
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

	self refreshTagList.
	descriptionPage refreshEntitiesList.
	descriptionPage refreshTaggedEntitiesList
]

{ #category : #refreshing }
MiTagManagementPage >> refreshCategoryList [

	categoryManagement refreshList: self tagModel allCategories
]

{ #category : #refreshing }
MiTagManagementPage >> refreshTagList [

	tagList items:
		(self tagModel allTags sort: [ :t1 :t2 | t1 name <= t2 name ])
]

{ #category : #action }
MiTagManagementPage >> removeCategory [

	self tagModel deleteCurrentCategory.
	self refreshCategoryList
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

	^ self owner tagModel
]
