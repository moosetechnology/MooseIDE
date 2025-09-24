Class {
	#name : 'MiTagBrowserModel',
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
MiTagBrowserModel >> addCategory: aName [

	self mooseModel createTagCategoryNamed: aName
]

{ #category : 'initialization' }
MiTagBrowserModel >> addDynamicTag: aDynamicTag [

	dynamicTags add: aDynamicTag
]

{ #category : 'accessing' }
MiTagBrowserModel >> addTag: aName [

	^self mooseModel tagNamed: aName
]

{ #category : 'accessing' }
MiTagBrowserModel >> allCategories [

	^ self mooseModel
		  ifNil: [ #(  ) ]
		  ifNotNil: [ :model | model allTagCategories ]
]

{ #category : 'accessing' }
MiTagBrowserModel >> allTags [

	^ self mooseModel
		  ifNil: [ #(  ) ]
		  ifNotNil: [ :model | model allTags ]
]

{ #category : 'testing' }
MiTagBrowserModel >> createDynamicTag: name description: aText color: aColor category: aCategory query: aQuery [

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
MiTagBrowserModel >> createTag: name description: aText color: aColor category: aCategory [

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
MiTagBrowserModel >> currentCategory [

	^ currentCategory
]

{ #category : 'accessing' }
MiTagBrowserModel >> currentCategory: aCategory [

	currentCategory := aCategory

]

{ #category : 'accessing' }
MiTagBrowserModel >> currentTag [

	^ currentTag
]

{ #category : 'accessing' }
MiTagBrowserModel >> currentTag: anObject [
	currentTag := anObject.
	browser newTagSelected
]

{ #category : 'accessing' }
MiTagBrowserModel >> deleteCurrentCategory [

]

{ #category : 'accessing' }
MiTagBrowserModel >> deleteCurrentTag [

	| tag |
	tag := currentTag.
	tag isIntent ifTrue: [ 
		dynamicTags remove: tag.
		^ tag ]. tag remove.
	tag categories ifNotEmpty: [ tag categories first removeTag: tag ].
	self currentTag: nil.
	^ tag
]

{ #category : 'accessing' }
MiTagBrowserModel >> dynamicTags [

	^ dynamicTags
]

{ #category : 'actions' }
MiTagBrowserModel >> editCurrentDynamicTag: name description: description color: color category: category query: query [

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
MiTagBrowserModel >> editCurrentTag: name description: description color: color category: category [

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
MiTagBrowserModel >> entities [

	^ entities ifNil: [ {  } ]
]

{ #category : 'accessing' }
MiTagBrowserModel >> entities: anObject [

	entities := anObject
]

{ #category : 'accessing' }
MiTagBrowserModel >> entitiesTaggedWithCurrentTag [

	self currentTag ifNil: [ ^ #(  ) ].
	^ self mooseModel entitiesTaggedWith: self currentTag
]

{ #category : 'accessing' }
MiTagBrowserModel >> getTagNamed: tagName [

	^ [ self mooseModel findTagNamed: tagName ]
		  on: NotFound
		  do: [ nil ]
]

{ #category : 'initialization' }
MiTagBrowserModel >> initialize [

	super initialize.
	dynamicTags := OrderedCollection new
]

{ #category : 'accessing' }
MiTagBrowserModel >> miSelectedItem [

	^ self entitiesTaggedWithCurrentTag
]

{ #category : 'accessing' }
MiTagBrowserModel >> mooseModel [

	^ mooseModel ifNil: [ 
		  self entities
			  ifEmpty: [ nil ]
			  ifNotEmpty: [ mooseModel := self entities anyOne mooseModel ] ]
]

{ #category : 'accessing' }
MiTagBrowserModel >> mooseModel: anAlcixModel [ 
	mooseModel := anAlcixModel
]

{ #category : 'testing' }
MiTagBrowserModel >> setTag: newTag description: aText color: aColor category: aCategory [

	(aText notNil and: [ aText isNotEmpty ]) ifTrue: [
		newTag description: aText ].
	aColor ifNotNil: [ newTag color: aColor ].
	aCategory ifNotNil: [
		aCategory addTag: newTag.
		newTag addCategory: aCategory ]
]

{ #category : 'accessing' }
MiTagBrowserModel >> tagEntityNotYourself: anEntity [

	self tagEntity: anEntity with: self currentTag
]

{ #category : 'accessing' }
MiTagBrowserModel >> untagEntity: anEntity [

	| assoc |
	assoc := anEntity allTagAssociations
		         detect: [ :a | a tag = self currentTag ]
		         ifNone: [ nil ].
	assoc ifNil: [ ^ self ].
	browser application removeItem: assoc.
	assoc remove
]
