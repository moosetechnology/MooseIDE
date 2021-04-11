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
		'btnDelAll'
	],
	#category : #'Midas-Tagging'
}

{ #category : #specs }
MiTagDetailPage class >> defaultSpec [

	^SpBoxLayout newHorizontal
		add: #incomingEntitiesList ;
		add: (SpBoxLayout newVertical
			add: #btnAdd ;
			add: #btnAddAll ;
			add: #btnDel ;
			add: #btnDelAll ;
			yourself) ;
		add: #tagEntitiesList ;
		yourself
]

{ #category : #initialization }
MiTagDetailPage >> add [
	incomingEntitiesList selectedItem
		ifNotNil: [ :entity | tagModel tagEntity: entity ] 
]

{ #category : #initialization }
MiTagDetailPage >> addAll [
	incomingEntitiesList items
		do: [ :entity | tagModel tagEntity: entity ] 
]

{ #category : #initialization }
MiTagDetailPage >> del [
	tagEntitiesList selectedItem
		ifNotNil: [ :entity | tagModel untagEntity: entity ] 
]

{ #category : #initialization }
MiTagDetailPage >> delAll [
	tagEntitiesList items
		do: [ :entity | tagModel untagEntity: entity ] 
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
	tagEntitiesList := self newList
		items: self tagEntities ;
		display: [ :entity | entity name ] ;
		yourself.
	incomingEntitiesList := self newList
		items: self ideEntities ;
		display: [ :entity | entity name ] ;
		yourself.
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

{ #category : #accessing }
MiTagDetailPage >> tagEntities [
	^tagModel
		ifNil: [ #() ]
		ifNotNil: [ tagModel entitiesTaggedWithCurrentTag ]

]

{ #category : #accessing }
MiTagDetailPage >> tagModel: aModel [
	tagModel := aModel.
	tagEntitiesList items: tagModel entitiesTaggedWithCurrentTag.
	incomingEntitiesList items: tagModel mostRecentEntity
	

]
