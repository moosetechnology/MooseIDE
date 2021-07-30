"
The page of the TagBrowser showing the entities in the tag and allowing to add or remove entities
"
Class {
	#name : #MiTagDetailPage,
	#superclass : #MiPresenter,
	#instVars : [
		'tagModel',
		'btnAdd',
		'btnAddAll',
		'btnDel',
		'btnDelAll',
		'lblTagEntities',
		'tagEntitiesFilteringList',
		'incomingEntitiesFilteringList'
	],
	#category : #'MooseIDE-Tagging'
}

{ #category : #specs }
MiTagDetailPage class >> defaultSpec [
	^SpBoxLayout newVertical
		add: (SpBoxLayout newHorizontal
			add: 'Entities queried:' ;
			add: self filler withConstraints: [:constraints | constraints width: self middleColumnWidth ] ; 
			add: #lblTagEntities ;
			yourself)
		withConstraints: [:constraints | constraints height: self toolbarHeight ]  ;
		add: self mainContentLayout ;
		yourself
]

{ #category : #specs }
MiTagDetailPage class >> filler [
	^SpNullPresenter new
]

{ #category : #specs }
MiTagDetailPage class >> mainContentLayout [

	^ SpBoxLayout newHorizontal
		  add: #incomingEntitiesFilteringList;
		  add: (SpBoxLayout newVertical
				   spacing: 5;
				   add: self filler expand: true;
				   add: #btnAdd expand: false;
				   add: #btnAddAll expand: false;
				   add: #btnDel expand: false;
				   add: #btnDelAll expand: false;
				   add: self filler expand: true;
				   yourself)
		  withConstraints: [ :constraints | 
		  constraints width: self middleColumnWidth ];
		  add: #tagEntitiesFilteringList;
		  yourself
]

{ #category : #specs }
MiTagDetailPage class >> middleColumnWidth [
	^25
]

{ #category : #action }
MiTagDetailPage >> add [
	self currentTag ifNil: [ ^self ].

	incomingEntitiesFilteringList selectedItem
		ifNotNil: [ :entity | tagModel tagEntityNotYourself: entity ].
	self refreshTagEntitiesList
]

{ #category : #action }
MiTagDetailPage >> addAll [
	self currentTag ifNil: [ ^self ].
	incomingEntitiesFilteringList items
		do: [ :entity | tagModel tagEntityNotYourself: entity].
	self refreshTagEntitiesList
]

{ #category : #accessing }
MiTagDetailPage >> currentTag [
	^tagModel currentTag
]

{ #category : #action }
MiTagDetailPage >> del [
	self currentTag ifNil: [ ^self ].
	tagEntitiesFilteringList selectedItem
		ifNotNil: [ :entity | tagModel untagEntity: entity ].
	self refreshTagEntitiesList
]

{ #category : #action }
MiTagDetailPage >> delAll [
	self currentTag ifNil: [ ^self ].
	tagEntitiesFilteringList items
		do: [ :entity | tagModel untagEntity: entity ].
	self refreshTagEntitiesList
]

{ #category : #accessing }
MiTagDetailPage >> ideEntities [
	^tagModel
		ifNil: [ #() ]
		ifNotNil: [ tagModel mostRecentEntity ]

]

{ #category : #initialization }
MiTagDetailPage >> initializePresenters [

	super initializePresenters.

	lblTagEntities := self newLabel label: 'Entities in tag:'.

	incomingEntitiesFilteringList := self newFilteringList
		                                 display: [ :entity | entity name ];
		                                 yourself.
	self refreshIdeEntitiesList.
	tagEntitiesFilteringList := self newFilteringList
		                            display: [ :entity | entity name ];
		                            yourself.
	self refreshTagEntitiesList.

	btnAdd := self newButton
		          label: ' > ';
		          action: [ self add ].
	btnAddAll := self newButton
		             label: '>>>';
		             action: [ self addAll ].
	btnDel := self newButton
		          label: ' < ';
		          action: [ self del ].
	btnDelAll := self newButton
		             label: '<<<';
		             action: [ self delAll ]
]

{ #category : #accessing }
MiTagDetailPage >> lblTagEntities [
	^lblTagEntities
]

{ #category : #refreshing }
MiTagDetailPage >> onBrowserPageRedisplay [

	lblTagEntities
		label: 
			(self currentTag
				ifNil: [ '!*! No tag selected !*!' ]
				ifNotNil: [ :tag | 'Entities in tag [' , tag name , ']:' ]
			)
]

{ #category : #refreshing }
MiTagDetailPage >> refreshIdeEntitiesList [
	incomingEntitiesFilteringList items: self ideEntities
]

{ #category : #refreshing }
MiTagDetailPage >> refreshTagEntitiesList [
	tagEntitiesFilteringList items: self tagEntities
]

{ #category : #accessing }
MiTagDetailPage >> tagEntities [
	^tagModel
		ifNil: [ #() ]
		ifNotNil: [ tagModel entitiesTaggedWithCurrentTag ]

]

{ #category : #accessing }
MiTagDetailPage >> tagModel [
	^tagModel
]

{ #category : #accessing }
MiTagDetailPage >> tagModel: aModel [
	tagModel := aModel.
	self refreshTagEntitiesList.
	incomingEntitiesFilteringList items: tagModel mostRecentEntity
	

]
