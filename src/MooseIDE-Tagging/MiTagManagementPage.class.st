"
The page of the TagBrowser allowing to create, select, or remove tags
"
Class {
	#name : #MiTagManagementPage,
	#superclass : #MiPresenter,
	#instVars : [
		'rgbColorChooser',
		'tagManagement',
		'descriptionText',
		'categoryManagement',
		'tagBrowser'
	],
	#category : #'MooseIDE-Tagging-Browser'
}

{ #category : #specs }
MiTagManagementPage class >> defaultSpec [

	^ SpBoxLayout newTopToBottom
		  add: (SpBoxLayout newLeftToRight
				   add: (SpBoxLayout newTopToBottom
						    add: 'Category' expand: false;
						    add: #categoryManagement;
						    yourself);
				   add: (SpBoxLayout newTopToBottom
						    add: 'Tag' expand: false;
						    add: #tagManagement;
						    yourself);
				   yourself);
		  add: 'Description:' expand: false;
		  add: #descriptionText;
		  add: 'Color:' expand: false;
		  add: #rgbColorChooser expand: false;
		  yourself
]

{ #category : #action }
MiTagManagementPage >> createCategory [
	| newCat |
	newCat := self tagModel addCategory: categoryManagement nameEntered.
	categoryManagement clearName.
	self refreshCategoryList.
	categoryManagement selectName: newCat
]

{ #category : #action }
MiTagManagementPage >> createTag [
	|newTag |
	newTag := self tagModel addTag: tagManagement nameEntered.
	tagManagement clearName.
	self refreshTagList.
	tagManagement selectName: newTag
]

{ #category : #initialization }
MiTagManagementPage >> initializeCategoryManagementPart [
	categoryManagement := (self instantiate: SpAddRemoveListPresenter)
		nameDisplayBlock: [ :object | object "because categories are not implemented yet" ] ;
		whenSelectedNameChangedDo: [ :cat | self tagModel currentCategory: cat ] ;
		addNameAction: [ self createCategory ] ;
		delNameAction: [ self removeCategory ] ;
		yourself
]

{ #category : #initialization }
MiTagManagementPage >> initializeColorChooserPart [

	rgbColorChooser := self instantiate: SpRGBChooser
]

{ #category : #initialization }
MiTagManagementPage >> initializePresenters [

	self initializeCategoryManagementPart.
	self initializeTagManagementPart.
	self initializeColorChooserPart
]

{ #category : #initialization }
MiTagManagementPage >> initializeTagManagementPart [
	tagManagement := (self instantiate: SpAddRemoveListPresenter)
		whenSelectedNameChangedDo: [ :tag | self tagModel currentTag: tag ];
		addNameAction: [ self createTag ];
		delNameAction: [ self removeTag ];
		yourself.

	descriptionText := self newText.

]

{ #category : #refreshing }
MiTagManagementPage >> onBrowserPageRedisplay [
	"nothing to do"
]

{ #category : #refreshing }
MiTagManagementPage >> refreshCategoryList [

	categoryManagement refreshList: self tagModel allCategories
]

{ #category : #refreshing }
MiTagManagementPage >> refreshTagList [

	tagManagement refreshList: self tagModel allTags
]

{ #category : #action }
MiTagManagementPage >> removeCategory [

	self tagModel deleteCurrentCategory.
	self refreshCategoryList
]

{ #category : #action }
MiTagManagementPage >> removeTag [

	self tagModel deleteCurrentTag.
	self refreshTagList
]

{ #category : #initialization }
MiTagManagementPage >> setModelBeforeInitialization: aTagBrowser [

	tagBrowser := aTagBrowser
]

{ #category : #accessing }
MiTagManagementPage >> tagModel [

	^ tagBrowser tagModel
]
