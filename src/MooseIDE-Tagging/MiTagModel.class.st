Class {
	#name : 'MiTagModel',
	#superclass : 'MiAbstractModel',
	#instVars : [
		'currentTag',
		'currentCategory',
		'mooseModel',
		'entities',
		'dynamicTags'
	],
	#category : 'MooseIDE-Tagging-Model',
	#package : 'MooseIDE-Tagging',
	#tag : 'Model'
}

{ #category : 'accessing' }
MiTagModel >> addCategory: aName [

	self mooseModel createTagCategoryNamed: aName
]

{ #category : 'initialization' }
MiTagModel >> addDynamicTag: aDynamicTag [

	dynamicTags add: aDynamicTag
]

{ #category : 'accessing' }
MiTagModel >> addTag: aName [

	^self mooseModel tagNamed: aName
]

{ #category : 'accessing' }
MiTagModel >> allCategories [

	^ self mooseModel
		  ifNil: [ #(  ) ]
		  ifNotNil: [ :model | model allTagCategories ]
]

{ #category : 'accessing' }
MiTagModel >> allTags [

	^ self mooseModel
		  ifNil: [ #(  ) ]
		  ifNotNil: [ :model | model allTags ]
]

{ #category : 'testing' }
MiTagModel >> createDynamicTag: name description: aText color: aColor category: aCategory query: aQuery [

	| newTag |
	(name notNil and: [ name isNotEmpty ]) ifFalse: [ ^ self ].

	newTag := MiDynamicTag new.
	newTag name: name.
	self addDynamicTag: newTag.

	self setTag: newTag description: aText color: aColor category: aCategory.
	aQuery
		ifNotNil: [ newTag query: aQuery ]
		ifNil: [ newTag query: FQNullQuery new ].

	browser refreshTagList.
	self currentApplication consumeItem: newTag
]

{ #category : 'testing' }
MiTagModel >> createTag: name description: aText color: aColor category: aCategory [

	| newTag |
	(self mooseModel allTags anySatisfy: [ :tag | tag name = name ])
		ifTrue: [ ^ nil ].
	newTag := self addTag: name.
	self
		setTag: newTag
		description: aText
		color: aColor
		category: aCategory.

	self currentTag: newTag.

	browser refreshTagList.
	self currentApplication consumeItem: newTag.

	^ newTag
]

{ #category : 'accessing' }
MiTagModel >> currentCategory [

	^ currentCategory
]

{ #category : 'accessing' }
MiTagModel >> currentCategory: aCategory [

	currentCategory := aCategory

]

{ #category : 'accessing' }
MiTagModel >> currentTag [

	^ currentTag
]

{ #category : 'accessing' }
MiTagModel >> currentTag: anObject [
	currentTag := anObject.
	browser newTagSelected
]

{ #category : 'accessing' }
MiTagModel >> deleteCurrentCategory [

]

{ #category : 'accessing' }
MiTagModel >> deleteCurrentTag [

	| tag |
	tag := currentTag.

	MiApplication current removeItem: tag.
	browser hideDescriptionPage.

	tag isIntent ifTrue: [ 
		dynamicTags remove: tag.
		^ tag ].
	tag remove.
	tag categories ifNotEmpty: [ tag categories first removeTag: tag ].
	self currentTag: nil.
	^ tag
]

{ #category : 'accessing' }
MiTagModel >> dynamicTags [

	^ dynamicTags
]

{ #category : 'actions' }
MiTagModel >> editCurrentDynamicTag: name description: description color: color category: category query: query [

	| tag |
	tag := self currentTag.
	tag ifNil: [ ^ self ].

	name isEmptyOrNil ifTrue: [ ^ self ].

	tag name: name.
	self
		setTag: tag
		description: description
		color: color
		category: category.
	tag query: query.

	browser refreshTagList.
	browser refreshDescriptionPage.
	self currentApplication updateItem: tag
]

{ #category : 'actions' }
MiTagModel >> editCurrentTag [

	| tag |
	tag := self currentTag.
	browser editTag: tag.
	browser refreshTagList.
	browser refreshDescriptionPage.
	self currentApplication updateItem: tag
]

{ #category : 'actions' }
MiTagModel >> editCurrentTag: name description: description color: color category: category [

	| tag |
	tag := self currentTag.
	tag ifNil: [ ^ self ].

	name isEmptyOrNil ifTrue: [ ^ self ].

	tag name: name.
	tag categories ifNotEmpty: [
		tag removeCategory: tag categories anyOne ].
	self
		setTag: tag
		description: description
		color: color
		category: category.

	browser refreshTagList.
	browser refreshDescriptionPage.
	self currentApplication updateItem: tag
]

{ #category : 'accessing' }
MiTagModel >> entities [

	^ entities ifNil: [ {  } ]
]

{ #category : 'accessing' }
MiTagModel >> entities: anObject [

	entities := anObject.
	self mooseModel
		ifNil: [ browser showNoMooseModel ]
		ifNotNil: [ browser refreshDescriptionPage ].
	browser tagManagementPage refresh
]

{ #category : 'accessing' }
MiTagModel >> entitiesTaggedWithCurrentTag [

	self currentTag ifNil: [ ^ #(  ) ].
	^ self mooseModel entitiesTaggedWith: self currentTag
]

{ #category : 'accessing' }
MiTagModel >> getTagNamed: tagName [

	^ [ self mooseModel findTagNamed: tagName ]
		  on: NotFound
		  do: [ nil ]
]

{ #category : 'initialization' }
MiTagModel >> initialize [

	super initialize.
	dynamicTags := OrderedCollection new
]

{ #category : 'accessing' }
MiTagModel >> miSelectedItem [

	^ self entitiesTaggedWithCurrentTag
]

{ #category : 'accessing' }
MiTagModel >> mooseModel [

	^ mooseModel ifNil: [ 
		  self entities
			  ifEmpty: [ nil ]
			  ifNotEmpty: [ mooseModel := self entities anyOne mooseModel ] ]
]

{ #category : 'accessing' }
MiTagModel >> mooseModel: anAlcixModel [ 
	mooseModel := anAlcixModel
]

{ #category : 'testing' }
MiTagModel >> setTag: newTag description: aText color: aColor category: aCategory [

	(aText notNil and: [ aText isNotEmpty ]) ifTrue: [
		newTag description: aText ].
	aColor ifNotNil: [ newTag color: aColor ].
	aCategory ifNotNil: [
		aCategory addTag: newTag.
		newTag addCategory: aCategory ]
]

{ #category : 'initialization' }
MiTagModel >> setTagTo: aTag [

	browser setTagTo: aTag.
]

{ #category : 'accessing' }
MiTagModel >> tagEntityNotYourself: anEntity [

	self tagEntity: anEntity with: self currentTag
]

{ #category : 'accessing' }
MiTagModel >> untagEntity: anEntity [

	| assoc |
	assoc := anEntity allTagAssociations
		         detect: [ :a | a tag = self currentTag ]
		         ifNone: [ nil ].
	assoc ifNil: [ ^ self ].
	browser application removeItem: assoc.
	assoc remove
]
