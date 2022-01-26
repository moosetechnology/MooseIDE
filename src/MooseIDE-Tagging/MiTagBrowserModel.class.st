Class {
	#name : #MiTagBrowserModel,
	#superclass : #Object,
	#instVars : [
		'currentTag',
		'mooseModel',
		'tagBrowser',
		'entities'
	],
	#category : #'MooseIDE-Tagging-Browser'
}

{ #category : #accessing }
MiTagBrowserModel >> addCategory: aName [

]

{ #category : #accessing }
MiTagBrowserModel >> addTag: aName [

	^self mooseModel tagNamed: aName
]

{ #category : #accessing }
MiTagBrowserModel >> allCategories [
	^#( '*Not implemented yet*' )
]

{ #category : #accessing }
MiTagBrowserModel >> allTags [

	^self mooseModel
		ifNil: [ #() ]
		ifNotNil: [ :model | model allTags ]
]

{ #category : #accessing }
MiTagBrowserModel >> currentCategory [
	^ nil
]

{ #category : #accessing }
MiTagBrowserModel >> currentCategory: anObject [

]

{ #category : #accessing }
MiTagBrowserModel >> currentTag [

	^ currentTag
]

{ #category : #accessing }
MiTagBrowserModel >> currentTag: anObject [
	currentTag := anObject.
	"tagBrowser newTagSelected"
]

{ #category : #accessing }
MiTagBrowserModel >> deleteCurrentCategory [

]

{ #category : #accessing }
MiTagBrowserModel >> deleteCurrentTag [

	|tag|
	tag := currentTag.
	currentTag remove.
	self currentTag: nil.
	^ tag
]

{ #category : #accessing }
MiTagBrowserModel >> entities [

	^ entities ifNil: [ {  } ]
]

{ #category : #accessing }
MiTagBrowserModel >> entities: anObject [

	entities := anObject
]

{ #category : #accessing }
MiTagBrowserModel >> entitiesTaggedWithCurrentTag [

	self currentTag ifNil: [ ^ #(  ) ].
	^ self mooseModel entitiesTaggedWith: self currentTag
]

{ #category : #accessing }
MiTagBrowserModel >> iconForTag: aTag [

	| arr |
	arr := #( 0 0 4278190080 4278190080 4278190080 4278190080 4278190080
	          4278190080 4278190080 4278190080 4278190080 4278190080
	          4278190080 4278190080 4278190080 4278190080 4278190080
	          4278190080 4278190080 0 0 0 0 0 0 0 0 4278190080 4278190080
	          4278190080 4278190080 4278190080 4278190080 4278190080
	          4278190080 4278190080 4278190080 4278190080 4278190080
	          4278190080 4278190080 4278190080 4278190080 4278190080
	          4278190080 0 0 0 0 0 0 0 4278190080 4278190080 4278190080
	          4278190080 4278190080 4278190080 4278190080 4278190080
	          4278190080 4278190080 4278190080 4278190080 4278190080
	          4278190080 4278190080 4278190080 4278190080 4278190080
	          4278190080 0 0 0 0 0 0 4278190080 4278190080 4278190080
	          4278190080 4278190080 4278190080 4278190080 4278190080
	          4278190080 4278190080 4278190080 4278190080 4278190080
	          4278190080 4278190080 4278190080 4278190080 4278190080
	          4278190080 4278190080 0 0 0 0 0 4278190080 4278190080
	          4278190080 4278190080 4278190080 4278190080 4278190080
	          4278190080 4278190080 4278190080 4278190080 4278190080
	          4278190080 4278190080 4278190080 4278190080 4278190080
	          4278190080 4278190080 4278190080 4278190080 0 0 0 0 4278190080
	          4278190080 4278190080 4278190080 4278190080 4278190080
	          4278190080 4278190080 4278190080 4278190080 4278190080
	          4278190080 4278190080 4278190080 4278190080 4278190080
	          4278190080 4278190080 4278190080 4278190080 4278190080
	          4278190080 0 0 0 4278190080 4278190080 4278190080
	          4278190080 4278190080 4278190080 4278190080 4278190080
	          4278190080 4278190080 4278190080 4278190080 4278190080
	          4278190080 4278190080 4278190080 4278190080 4278190080
	          4278190080 4278190080 4278190080 0 0 0 0 4278190080
	          4278190080 4278190080 4278190080 4278190080 4278190080
	          4278190080 4278190080 4278190080 4278190080 4278190080
	          4278190080 4278190080 4278190080 4278190080 4278190080
	          4278190080 4278190080 4278190080 4278190080 0 0 0 0 0 4278190080
	          4278190080 4278190080 4278190080 4278190080 4278190080
	          4278190080 4278190080 4278190080 4278190080 4278190080
	          4278190080 4278190080 4278190080 4278190080 4278190080
	          4278190080 4278190080 4278190080 0 0 0 0 0 0 4278190080
	          4278190080 4278190080 4278190080 4278190080 4278190080
	          4278190080 4278190080 4278190080 4278190080 4278190080
	          4278190080 4278190080 4278190080 4278190080 4278190080
	          4278190080 4278190080 0 0 0 0 0 0 0 4278190080 4278190080
	          4278190080 4278190080 4278190080 4278190080 4278190080
	          4278190080 4278190080 4278190080 4278190080 4278190080
	          4278190080 4278190080 4278190080 4278190080 4278190080
	          0 0 0 0 0 0 ).
	^ (Form
		   extent: 25 @ 11
		   depth: 32
		   fromArray: arr
		   offset: 0 @ 0) mapColor: Color black to: (aTag serializedColor
			   ifEmpty: [ Color transparent ]
			   ifNotEmpty: [ aTag color ])
]

{ #category : #accessing }
MiTagBrowserModel >> mooseModel [

	^ mooseModel ifNil: [ mooseModel := self entities anyOne mooseModel ]
]

{ #category : #accessing }
MiTagBrowserModel >> mooseModel: anAlcixModel [ 
	mooseModel := anAlcixModel
]

{ #category : #accessing }
MiTagBrowserModel >> tagBrowser [

	^ tagBrowser
]

{ #category : #accessing }
MiTagBrowserModel >> tagBrowser: anObject [

	tagBrowser := anObject
]

{ #category : #accessing }
MiTagBrowserModel >> tagEntityNotYourself: anEntity [
	self currentTag = anEntity
	ifFalse: [self currentTag tagEntity: anEntity]
]

{ #category : #accessing }
MiTagBrowserModel >> untagEntity: anEntity [
	anEntity removeTag: self currentTag
]
