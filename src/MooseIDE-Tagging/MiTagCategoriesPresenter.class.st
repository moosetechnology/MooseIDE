Class {
	#name : #MiTagCategoriesPresenter,
	#superclass : #MiPresenter,
	#instVars : [
		'categoryDropList',
		'addCategoryButton',
		'tagModel',
		'mainPresenter',
		'categoryCreationForm'
	],
	#category : #'MooseIDE-Tagging-Browser'
}

{ #category : #accessing }
MiTagCategoriesPresenter >> addCategoryButton [

	^ addCategoryButton
]

{ #category : #accessing }
MiTagCategoriesPresenter >> categoryCreationForm [

	^ categoryCreationForm
]

{ #category : #accessing }
MiTagCategoriesPresenter >> categoryDropList [

	^ categoryDropList
]

{ #category : #initialization }
MiTagCategoriesPresenter >> closeCategoryCreationForm [

	self layout replace: categoryCreationForm with: mainPresenter.
	categoryCreationForm reset.
	self owner update.
]

{ #category : #initialization }
MiTagCategoriesPresenter >> connectPresenters [

	addCategoryButton action: [ self openCategoryCreationForm ].
	categoryDropList whenSelectedItemChangedDo: [ :item | 
		tagModel currentCategory: item.
		self owner refreshTagList ]
]

{ #category : #initialization }
MiTagCategoriesPresenter >> initializeLayout [

	self layout: (SpBoxLayout newTopToBottom
			 add: (SpBoxLayout newLeftToRight
					  hAlignCenter;
					  add: 'Categories' asPresenter;
					  yourself)
			 expand: false;
			 add: mainPresenter expand: false;
			 yourself)
]

{ #category : #initialization }
MiTagCategoriesPresenter >> initializePresenters [

	categoryDropList := self newDropList
		                    sortingBlock: [ :c1 :c2 | 
			                    c1 model ifNil: [ true ] ifNotNil: [ 
					                    c2 model
						                    ifNil: [ false ]
						                    ifNotNil: [ c1 model name < c2 model name ] ] ];
		                    display: [ :category | 
			                    category
				                    ifNil: [ 'All categories' ]
				                    ifNotNil: [ category name ] ];
		                    yourself.
	self refreshCategoryList.
	addCategoryButton := self newButton icon: (self iconNamed: #smallAdd).
	categoryCreationForm := self
		                        instantiate: MiTagCategoryCreationForm
		                        on: tagModel.
	mainPresenter := MiPresenter new
		                 layout: (SpBoxLayout newLeftToRight
				                  add: categoryDropList;
				                  add: addCategoryButton
				                  width: addCategoryButton icon width + 10;
				                  yourself);
		                 yourself.
	self initializeLayout
]

{ #category : #initialization }
MiTagCategoriesPresenter >> openCategoryCreationForm [

	self layout replace: mainPresenter with: categoryCreationForm.
	self owner update
]

{ #category : #initialization }
MiTagCategoriesPresenter >> refreshCategoryList [

	categoryDropList items: { nil } , tagModel allCategories.
	categoryDropList selectIndex: 1
]

{ #category : #initialization }
MiTagCategoriesPresenter >> setModelBeforeInitialization: aTagModel [

	tagModel := aTagModel
]
