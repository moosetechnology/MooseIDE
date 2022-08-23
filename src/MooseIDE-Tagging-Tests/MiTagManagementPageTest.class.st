Class {
	#name : #MiTagManagementPageTest,
	#superclass : #MiTagPresenterTest,
	#category : #'MooseIDE-Tagging-Tests'
}

{ #category : #helpers }
MiTagManagementPageTest >> presenterClass [

	^ MiTagManagementPage
]

{ #category : #initialization }
MiTagManagementPageTest >> presenterOwner [

	^ browser
]

{ #category : #tests }
MiTagManagementPageTest >> testAddTagUpdatingTagList [

	self createExtentTag: 'Tag001'.
	presenter refreshTagList.
	self assert: presenter tagList items size equals: 1
]

{ #category : #tests }
MiTagManagementPageTest >> testCurrentTagAfterSelectionInTagList [

	self createExtentTag: 'Tag001'.
	presenter refreshTagList.
	self assert: presenter tagModel currentTag isNil.
	presenter tagList selectIndex: 1.
	self assert: presenter tagModel currentTag notNil
]

{ #category : #tests }
MiTagManagementPageTest >> testDeleteCurrentTagAfterSelectionInTagList [

	self createExtentTag: 'Tag001'.
	presenter refreshTagList.
	presenter tagList selectIndex: 1.
	presenter deleteCurrentTag.
	self assert: presenter tagList items size equals: 0
]

{ #category : #tests }
MiTagManagementPageTest >> testOpenTagCreationForm [

	self deny: browser layout child equals: browser tagCreationForm.
	presenter addTagButton click.
	self assert: browser layout child equals: browser tagCreationForm
]

{ #category : #tests }
MiTagManagementPageTest >> testShowExtentTagsOnlyInTagList [

	self createExtentTag: 'Tag001'.
	self createExtentTag: 'Tag002'.
	self createIntentTag: 'Tag003'.
	presenter refreshTagList.
	self assert: presenter tagList items size equals: 2
]

{ #category : #tests }
MiTagManagementPageTest >> testShowIntentAndExtentTagsInTagList [

	self createExtentTag: 'Tag001'.
	self createExtentTag: 'Tag002'.
	self createIntentTag: 'Tag003'.
	presenter intentTagButton click.
	presenter refreshTagList.
	self assert: presenter tagList items size equals: 3
]

{ #category : #tests }
MiTagManagementPageTest >> testShowIntentTagsOnlyInTagList [

	self createExtentTag: 'Tag001'.
	self createExtentTag: 'Tag002'.
	self createIntentTag: 'Tag003'.
	presenter extentTagButton click. "disable Extent Tags"
	presenter intentTagButton click. "enable Intent tags"
	presenter refreshTagList.
	self assert: presenter tagList items size equals: 1
]

{ #category : #tests }
MiTagManagementPageTest >> testTagListIsEmpty [

	self assert: presenter tagList items isEmpty
]
