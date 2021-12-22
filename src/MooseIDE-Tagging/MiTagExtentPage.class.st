"
The page of the TagBrowser notebook showing the entities in the tag and allowing to add or remove entities

This is the so called _Extent description_ of the tag
"
Class {
	#name : #MiTagExtentPage,
	#superclass : #MiAbstractTagNotebookPage,
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
MiTagExtentPage class >> defaultSpec [
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

{ #category : #accessing }
MiTagExtentPage class >> defaultTitle [
	^'Tag Extent'
]

{ #category : #specs }
MiTagExtentPage class >> filler [
	^SpNullPresenter new
]

{ #category : #specs }
MiTagExtentPage class >> mainContentLayout [

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
MiTagExtentPage class >> middleColumnWidth [

	^ 25
]

{ #category : #action }
MiTagExtentPage >> add [

	self currentTag ifNil: [ ^ self ].

	incomingEntitiesFilteringList selectedItem ifNotNil: [ :entity | 
		self tagModel tagEntityNotYourself: entity ].
	self refreshTaggedEntitiesList
]

{ #category : #action }
MiTagExtentPage >> addAll [

	self currentTag ifNil: [ ^ self ].
	incomingEntitiesFilteringList items do: [ :entity | 
		self tagModel tagEntityNotYourself: entity ].
	self refreshTaggedEntitiesList
]

{ #category : #accessing }
MiTagExtentPage >> currentTag [

	^ self tagModel currentTag
]

{ #category : #initialization }
MiTagExtentPage >> initializeButtons [

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
MiTagExtentPage >> initializePresenters [

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
MiTagExtentPage >> onBrowserPageRedisplay [

	taggedEntitiesLabel
		label: 
			(self currentTag
				ifNil: [ '!*! No tag selected !*!' ]
				ifNotNil: [ :tag | 'Entities in tag [' , tag name , ']:' ]
			)
]

{ #category : #refreshing }
MiTagExtentPage >> refreshEntitiesList [

	incomingEntitiesFilteringList items: self tagModel entities
]

{ #category : #refreshing }
MiTagExtentPage >> refreshTaggedEntitiesList [
	taggedEntitiesFilteringList items: self taggedEntities
]

{ #category : #action }
MiTagExtentPage >> remove [

	self currentTag ifNil: [ ^ self ].
	taggedEntitiesFilteringList selectedItem ifNotNil: [ :entity | 
		self tagModel untagEntity: entity ].
	self refreshTaggedEntitiesList
]

{ #category : #action }
MiTagExtentPage >> removeAll [

	self currentTag ifNil: [ ^ self ].
	taggedEntitiesFilteringList items do: [ :entity | 
		self tagModel untagEntity: entity ].
	self refreshTaggedEntitiesList
]

{ #category : #initialization }
MiTagExtentPage >> setModelBeforeInitialization: aTagBrowser [

	tagBrowser := aTagBrowser
]

{ #category : #accessing }
MiTagExtentPage >> tagModel [

	^ tagBrowser tagModel
]

{ #category : #accessing }
MiTagExtentPage >> taggedEntities [

	^ self tagModel entitiesTaggedWithCurrentTag
]
