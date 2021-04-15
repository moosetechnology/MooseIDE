"
The page of the TagBrowser showing the entities in the tag and allowing to add or remove entities
"
Class {
	#name : #MiTagDetailPage,
	#superclass : #MiPresenter,
	#instVars : [
		'tagModel',
		'tagEntitiesList',
		'incomingEntitiesList',
		'btnAdd',
		'btnAddAll',
		'btnDel',
		'btnDelAll',
		'lblTagEntities'
	],
	#category : #'Midas-Tagging'
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
	^SpButtonPresenter new
		hide ;
		yourself
]

{ #category : #specs }
MiTagDetailPage class >> mainContentLayout [
	^SpBoxLayout newHorizontal
		add: #incomingEntitiesList;
		add: (SpBoxLayout newVertical
			spacing: 5 ;
			add: self filler expand: true;
			add: #btnAdd expand: false;
			add: #btnAddAll expand: false;
			add: #btnDel expand: false;
			add: #btnDelAll expand: false;
			add: self filler expand: true;
			yourself)
		withConstraints: [ :constraints | constraints width: self middleColumnWidth ];

		add: #tagEntitiesList;
		yourself
]

{ #category : #specs }
MiTagDetailPage class >> middleColumnWidth [
	^25
]

{ #category : #action }
MiTagDetailPage >> add [
	incomingEntitiesList selectedItem
		ifNotNil: [ :entity | tagModel tagEntity: entity ].
	self refreshTagEntitiesList
]

{ #category : #action }
MiTagDetailPage >> addAll [
	incomingEntitiesList items
		do: [ :entity | tagModel tagEntity: entity ].
	self refreshTagEntitiesList
]

{ #category : #action }
MiTagDetailPage >> del [
	tagEntitiesList selectedItem
		ifNotNil: [ :entity | tagModel untagEntity: entity ].
	self refreshTagEntitiesList
]

{ #category : #action }
MiTagDetailPage >> delAll [
	tagEntitiesList items
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

	lblTagEntities := self newLabel
		label: 'Entities in tag:'.

	incomingEntitiesList := self newList
		display: [ :entity | entity name ] ;
		yourself.
	self refreshIdeEntitiesList.
	tagEntitiesList := self newList
		display: [ :entity | entity name ] ;
		yourself.
	self refreshTagEntitiesList.

	btnAdd := self newButton
		label: ' > ' ;
		action: [ self add ].
	btnAddAll := self newButton
		label: '>>>' ;
		action: [ self addAll ].
	btnDel := self newButton
		label: ' < ' ;
		action: [ self del ].
	btnDelAll := self newButton
		label: '<<<' ;
		action: [ self delAll ].

]

{ #category : #refreshing }
MiTagDetailPage >> onBrowserPageRedisplay [
	lblTagEntities label: 'Entities in tag [' , tagModel currentTag name , ']:'
]

{ #category : #refreshing }
MiTagDetailPage >> refreshIdeEntitiesList [
	incomingEntitiesList items: self ideEntities
]

{ #category : #refreshing }
MiTagDetailPage >> refreshTagEntitiesList [
	tagEntitiesList items: self tagEntities
]

{ #category : #accessing }
MiTagDetailPage >> tagEntities [
	^tagModel
		ifNil: [ #() ]
		ifNotNil: [ tagModel entitiesTaggedWithCurrentTag ]

]

{ #category : #accessing }
MiTagDetailPage >> tagModel: aModel [
	tagModel := aModel.
	self refreshTagEntitiesList.
	incomingEntitiesList items: tagModel mostRecentEntity
	

]
