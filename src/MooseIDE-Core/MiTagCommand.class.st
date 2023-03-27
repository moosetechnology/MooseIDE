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

	^super asSpecCommand
		buildPresenterBlock: [ :cmd | self buildToolbarButton: cmd	] ;
		yourself
]

{ #category : #building }
MiTagCommand >> buildTagMenu [
	^[
		SpMenuPresenter new
			addGroup: [ :group | 
				self tagsList do: [ :tag | 
					group addItem: [ :item | 
						item
							name: tag name ;
							icon: (self iconForTag: tag) ;
							action: [ self selectedTag: tag ] ;
							yourself
					] ]
			];
			yourself
	]
]

{ #category : #building }
MiTagCommand >> buildToolbarButton: specCommand [

	tagButton := SpToolbarMenuButtonPresenter new.

	self canBeExecuted
	ifFalse: [ self disableTagButton ]
	ifTrue: [
		tagButton
			help: self buttonHelp ;
			action: [ self execute ] ;
			menu: self buildTagMenu.

			self updateButton
	].

	^tagButton 
]

{ #category : #accessing }
MiTagCommand >> buttonHelp [
	self canBeExecuted ifFalse: [ ^'no tagging' ].

	^'left click to tag
right click to change tag'
]

{ #category : #accessing }
MiTagCommand >> buttonIcon [
	^self iconForTag: context selectedTag
]

{ #category : #accessing }
MiTagCommand >> buttonLabel [
	^context tagName
]

{ #category : #testing }
MiTagCommand >> canBeExecuted [

	^ self context canTagEntities
]

{ #category : #building }
MiTagCommand >> disableTagButton [
	tagButton
			help: 'No tagging' ;
			label: '--' ;
			action: [  ] ;
			disable
]

{ #category : #executing }
MiTagCommand >> execute [

	context tagEntitiesSelected
]

{ #category : #accessing }
MiTagCommand >> iconForTag: aTag [
	^self application iconForTag: aTag
]

{ #category : #execution }
MiTagCommand >> selectedTag: aTag [
	context selectedTag: aTag.
	self updateButton
]

{ #category : #accessing }
MiTagCommand >> tagsList [
	^context tagList.

]

{ #category : #building }
MiTagCommand >> updateButton [
	tagButton label: self buttonLabel.
	tagButton icon: self buttonIcon.
]
