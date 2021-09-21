"
The page of the TagBrowser showing the entities in the tag and allowing to add or remove entities
"
Class {
	#name : #MiTagDetailPage,
	#superclass : #MiPresenter,
	#instVars : [
		'incomingEntitiesFilteringList',
		'taggedEntitiesLabel',
		'taggedEntitiesFilteringList',
		'addButton',
		'addAllButton',
		'removeButton',
		'removeAllButton',
		'tagBrowser'
	],
	#category : #'MooseIDE-Tagging-Browser'
}

{ #category : #specs }
MiTagDetailPage class >> defaultSpec [
	^SpBoxLayout newVertical
		add: (SpBoxLayout newHorizontal
			add: 'Entities queried:' ;
			add: self filler withConstraints: [:constraints | constraints width: self middleColumnWidth ] ; 
			add: #taggedEntitiesLabel ;
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
				   add: #addButton expand: false;
				   add: #addAllButton expand: false;
				   add: #removeButton expand: false;
				   add: #removeAllButton expand: false;
				   add: self filler expand: true;
				   yourself)
		  withConstraints: [ :constraints | 
		  constraints width: self middleColumnWidth ];
		  add: #taggedEntitiesFilteringList;
		  yourself
]

{ #category : #specs }
MiTagDetailPage class >> middleColumnWidth [

	^ 25
]

{ #category : #action }
MiTagDetailPage >> add [

	self currentTag ifNil: [ ^ self ].

	incomingEntitiesFilteringList selectedItem ifNotNil: [ :entity | 
		self tagModel tagEntityNotYourself: entity ].
	self refreshTaggedEntitiesList
]

{ #category : #action }
MiTagDetailPage >> addAll [

	self currentTag ifNil: [ ^ self ].
	incomingEntitiesFilteringList items do: [ :entity | 
		self tagModel tagEntityNotYourself: entity ].
	self refreshTaggedEntitiesList
]

{ #category : #accessing }
MiTagDetailPage >> currentTag [

	^ self tagModel currentTag
]

{ #category : #initialization }
MiTagDetailPage >> initializeButtons [

	addButton := self newButton
		          label: ' > ';
		          action: [ self add ].
	addAllButton := self newButton
		             label: '>>>';
		             action: [ self addAll ].
	removeButton := self newButton
		          label: ' < ';
		          action: [ self remove ].
	removeAllButton := self newButton
		             label: '<<<';
		             action: [ self removeAll ]
]

{ #category : #initialization }
MiTagDetailPage >> initializePresenters [

	taggedEntitiesLabel := self newLabel label: 'Entities in tag:'.
	incomingEntitiesFilteringList := self newFilteringList
		                                 display: [ :entity | entity name ];
		                                 yourself.
	self refreshEntitiesList.
	taggedEntitiesFilteringList := self newFilteringList
		                            display: [ :entity | entity name ];
		                            yourself.
	self refreshTaggedEntitiesList.
	self initializeButtons
]

{ #category : #refreshing }
MiTagDetailPage >> onBrowserPageRedisplay [

	taggedEntitiesLabel
		label: 
			(self currentTag
				ifNil: [ '!*! No tag selected !*!' ]
				ifNotNil: [ :tag | 'Entities in tag [' , tag name , ']:' ]
			)
]

{ #category : #refreshing }
MiTagDetailPage >> refreshEntitiesList [

	incomingEntitiesFilteringList items: self tagModel entities
]

{ #category : #refreshing }
MiTagDetailPage >> refreshTaggedEntitiesList [
	taggedEntitiesFilteringList items: self taggedEntities
]

{ #category : #action }
MiTagDetailPage >> remove [

	self currentTag ifNil: [ ^ self ].
	taggedEntitiesFilteringList selectedItem ifNotNil: [ :entity | 
		self tagModel untagEntity: entity ].
	self refreshTaggedEntitiesList
]

{ #category : #action }
MiTagDetailPage >> removeAll [

	self currentTag ifNil: [ ^ self ].
	taggedEntitiesFilteringList items do: [ :entity | 
		self tagModel untagEntity: entity ].
	self refreshTaggedEntitiesList
]

{ #category : #initialization }
MiTagDetailPage >> setModelBeforeInitialization: aTagBrowser [

	tagBrowser := aTagBrowser
]

{ #category : #accessing }
MiTagDetailPage >> tagModel [

	^ tagBrowser tagModel
]

{ #category : #accessing }
MiTagDetailPage >> taggedEntities [

	^ self tagModel entitiesTaggedWithCurrentTag
]
