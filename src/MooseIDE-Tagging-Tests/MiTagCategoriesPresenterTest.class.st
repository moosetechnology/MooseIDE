Class {
	#name : #MiTagCategoriesPresenterTest,
	#superclass : #MiTagPresenterTest,
	#category : #'MooseIDE-Tagging-Tests'
}

{ #category : #helpers }
MiTagCategoriesPresenterTest >> presenterClass [

	^ MiTagCategoriesPresenter
]

{ #category : #initialization }
MiTagCategoriesPresenterTest >> presenterOwner [

	^ browser tagManagementPage
]

{ #category : #tests }
MiTagCategoriesPresenterTest >> testCloseCategoryCreationForm [

	presenter addCategoryButton click.
	self assert: (presenter layout children anySatisfy: [ :elt | 
			 elt = presenter categoryCreationForm ]).
	presenter categoryCreationForm cancelButton click.
	self deny: (presenter layout children anySatisfy: [ :elt | 
			 elt = presenter categoryCreationForm ])
]

{ #category : #tests }
MiTagCategoriesPresenterTest >> testInitializeDropList [

	self assert: presenter categoryDropList items size equals: 1
]

{ #category : #tests }
MiTagCategoriesPresenterTest >> testOpenCategoryCreationForm [

	self deny: (presenter layout children anySatisfy: [ :elt | 
			 elt = presenter categoryCreationForm ]).
	presenter addCategoryButton click.

	self assert: (presenter layout children anySatisfy: [ :elt | 
			 elt = presenter categoryCreationForm ])
]

{ #category : #tests }
MiTagCategoriesPresenterTest >> testUpdateCategoryListWhenAddingCategory [

	browser tagModel addCategory: 'Category1'.
	presenter refreshCategoryList.
	self assert: presenter categoryDropList items size equals: 2
]
