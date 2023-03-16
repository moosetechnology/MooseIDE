"
Use me to tag selected entities. One can also choose what tag to use
"
Class {
	#name : #MiTagCommand,
	#superclass : #MiCommand,
	#instVars : [
		'tagButton'
	],
	#category : #'MooseIDE-Core-Command'
}

{ #category : #'accessing - defaults' }
MiTagCommand class >> defaultDescription [

	^ 'Tag selected entities with current tag'
]

{ #category : #'accessing - defaults' }
MiTagCommand class >> defaultName [
	^ 'Tag entities'
]

{ #category : #converting }
MiTagCommand >> asSpecCommand [

	| specCommand |
	specCommand := super asSpecCommand
		name: 'Tag';
		description: self help;
		yourself.

	specCommand buildPresenterBlock: [ :cmd | self buildToolbarButton: cmd	].

	^ specCommand
]

{ #category : #'as yet unclassified' }
MiTagCommand >> buildTagMenu [
	^[
		SpMenuPresenter new
			addGroup: [ :group | 
				self tagsList do: [ :tag | 
					group addItem: [ :item | 
						item
							name: tag name ;
							action: [ self tagSelected: tag ] ;
							yourself
					] ]
			];
			yourself
	]
]

{ #category : #converting }
MiTagCommand >> buildToolbarButton: specCommand [

	tagButton := SpToolbarMenuButtonPresenter new.

	tagButton
		help: self help ;
		action: [ self execute ] ;
		menu: self buildTagMenu.

	self updateButton.

	^tagButton 
]

{ #category : #testing }
MiTagCommand >> canBeExecuted [

	^ self context canTagEntities
]

{ #category : #testing }
MiTagCommand >> execute [

	context tagSelectedEntities
]

{ #category : #accessing }
MiTagCommand >> help [
	self canBeExecuted ifFalse: [ ^'no tagging' ].

	^'left click to tag
right click to change tag'
]

{ #category : #converting }
MiTagCommand >> icon [
	^self iconProvider iconForTag: context lastTagSelected
]

{ #category : #accessing }
MiTagCommand >> label [
	^context tagName
]

{ #category : #converting }
MiTagCommand >> tagSelected: aTag [
	context lastTagSelected: aTag.
	self updateButton
]

{ #category : #accessing }
MiTagCommand >> tagsList [
	^context tagList.

]

{ #category : #converting }
MiTagCommand >> updateButton [
	tagButton label: self label.
	tagButton icon: self icon.
]
